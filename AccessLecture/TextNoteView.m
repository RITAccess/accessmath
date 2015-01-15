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
#import "NoteTakingViewController.h"

@implementation TextNoteView

#pragma mark - Creation

- (void)awakeFromNib
{
    _title.delegate = self;
    _text.delegate = self;
    _delegate = [TextNoteViewController new];
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
    #pragma unused(sender)
    #pragma unused(event)
    self.data.title = _title.text;
}
- (IBAction)removeNote:(id)sender
{
    #pragma unused(sender)
    [_delegate textNoteView:self willClose:YES];
}

- (IBAction)fullScreeen:(id)sender
{
    #pragma unused(sender)
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
        fsnvc.text.font = _text.font;
        
        // Refs the current note being edited
        fsnvc.noteView = self;
        
        [_placeholder setText:@""];
    }];
}

- (void)panNote:(UIPanGestureRecognizer *)gesture
{
    // Dismiss keyboard
    for (UIView *view in[[[UIApplication sharedApplication] keyWindow] subviews]){
        [view endEditing:YES];
    }
    
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

- (IBAction)minimize:(id)sender forEvent:(UIEvent *)event
{
    UIButton* button = (UIButton *)sender;
    [_delegate textNoteView:self didMinimize:YES];
    [button setBackgroundColor:[UIColor greenColor]];
    [button setTitle:@"+" forState:UIControlStateNormal];
    [self changeUserInteraction:NO];
}

- (void)maximize:(UITapGestureRecognizer *)gesture
{
    [_delegate textNoteView:self didMaximize:YES];
    [_minimzeButton setBackgroundColor:[UIColor yellowColor]];
    [_minimzeButton setTitle:@"-" forState:UIControlStateNormal];
    [self changeUserInteraction:YES];
}

- (void)changeUserInteraction:(BOOL)isEnabled
{
    [_closeButton setUserInteractionEnabled:isEnabled];
    [_fullButton setUserInteractionEnabled:isEnabled];
    [_text setUserInteractionEnabled:isEnabled];
    [_title setUserInteractionEnabled:isEnabled];

    if (isEnabled == NO) {  // Switch to 1-finger pan, add tap to scale
        for (UIPanGestureRecognizer *recognizer in self.gestureRecognizers) {
            [self removeGestureRecognizer:recognizer];
        }

        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maximize:)];
        UIPanGestureRecognizer *panGesture =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panNote:)];
        panGesture.minimumNumberOfTouches = 1;
        [self addGestureRecognizer:panGesture];
        [self addGestureRecognizer:tapGesture];
    } else {
        for (UIPanGestureRecognizer *recognizer in self.gestureRecognizers) {
            [self removeGestureRecognizer:recognizer];
        }
        for (UITapGestureRecognizer *tapGesture in self.gestureRecognizers) {
            [self removeGestureRecognizer:tapGesture];
        }

        UIPanGestureRecognizer *panGesture =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panNote:)];
        panGesture.minimumNumberOfTouches = 2;
        [self addGestureRecognizer:panGesture];
    }
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
