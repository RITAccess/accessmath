//
//  TextNoteView.m
//  AccessLecture
//
//  Created by Michael on 1/6/14.
//
//

#import "TextNoteView.h"
#import "FullScreenNoteViewController.h"
#import "TextNoteViewController.h"

@implementation TextNoteView

#pragma mark - Creation

- (void)awakeFromNib
{
    _title.delegate = self;
    _text.delegate = self;
    UIPanGestureRecognizer *panGesture =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panNote:)];
    panGesture.minimumNumberOfTouches = 2;
    [self addGestureRecognizer:panGesture];
}

#pragma mark - Actions

- (IBAction)hideView
{
    [_delegate textNoteView:self didHide:YES];
}

- (IBAction)titleActions:(id)sender forEvent:(UIEvent *)event
{
    self.data.title = _title.text;
}
- (IBAction)removeNote:(id)sender
{
    _delegate = [[TextNoteViewController alloc] init];
    [_delegate textNoteView:self willClose:YES];
}

- (IBAction)fullScreeen:(id)sender
{
    FullScreenNoteViewController *fsnvc= [FullScreenNoteViewController new];
    fsnvc.modalPresentationStyle = UIModalPresentationPageSheet;
    
    // Get the current view controller
    UIViewController *currentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (currentViewController.presentedViewController) {
        currentViewController = currentViewController.presentedViewController;
    }
    
    [currentViewController presentViewController:fsnvc animated:YES completion:^(void){
        // Only assign title if it's been edited
        if (![_title.text isEqualToString:@""]){
            fsnvc.titleLabel.title = _title.text;
        } else {
            fsnvc.titleLabel.title = @"<Blank Title>";
        }
        
        fsnvc.text.text = _text.text;
        
        // Refs the current note being edited
        fsnvc.noteView = self;
        
        [_placeholder setText:@""];
    }];
}

- (void)panNote:(UIPanGestureRecognizer *)gesture {
    
    [self.superview bringSubviewToFront:self];
    
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self.superview];
        gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
        [gesture setTranslation:CGPointZero inView:self.superview];
    }
}

#pragma mark - Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == _text) {
        if ([textView.text isEqualToString:@""]) {
            _placeholder.hidden = NO;
        } else {
            _placeholder.hidden = YES;
        }
    }
    // Update note
    self.data.content = _text.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _title) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    // TODO: Add more rectangle drawing customization if we so choose.
}

@end
