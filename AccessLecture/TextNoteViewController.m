//
//  TextNoteViewController.m
//  AccessLecture
//
//  Created by Michael on 1/6/14.
//
//

#import "TextNoteViewController.h"
#import "FullScreenNoteViewController.h"
#import "ImageNoteViewController.h"

@interface TextNoteViewController ()

@end

@implementation TextNoteViewController

- (instancetype)initWithPoint:(CGPoint)point
{
    self = [super initWithNibName:@"TextNoteView" bundle:nil];
    if (self) {
        TextNoteView *view = (TextNoteView *)self.view;
        view.frame = CGRectMake(point.x - 200, point.y - 100, self.view.frame.size.width, self.view.frame.size.height);
        view.data = [Note new];
        view.data.location = self.view.frame.origin;
    }
    return self;
}

- (instancetype)initWithNote:(Note *)note
{
    self = [super initWithNibName:@"TextNoteView" bundle:nil];
    if (self) {
        TextNoteView *view = (TextNoteView *)self.view;
        view.data = note;
        view.frame = CGRectMake(note.location.x, note.location.y, self.view.frame.size.width, self.view.frame.size.height);
        view.title.text = note.title;
        view.text.text = note.content;
        view.placeholder.hidden = ![view.text.text isEqualToString:@""];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [NSNotificationCenter.defaultCenter addObserverForName:INVScreenShotNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        self.view.hidden = [note.object boolValue];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Delegate

- (void)textNoteView:(id)sender willClose:(BOOL)toClose
{
    [(TextNoteView *)sender removeFromSuperview];
    [self textNoteView:sender didClose:YES];
}

- (void)textNoteView:(id)sender didClose:(BOOL)closed
{
    NSLog(@"Removed: %@ note.", [[(TextNoteView *)sender data] title]);
}

- (void)textNoteView:(id)sender didHide:(BOOL)hide
{

}

- (void)textNoteView:(id)sender didMinimize:(BOOL)minimize
{
    TextNoteView* note = (TextNoteView *)sender;
    [UIView animateWithDuration:.25
                     animations:^{
                         note.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.08, 0.15);
                     }
                     completion:^(BOOL completed){
                         [note setBackgroundColor:[UIColor purpleColor]];
                     }
     ];
}

- (void)textNoteView:(id)sender didMaximize:(BOOL)maximize
{
    TextNoteView* note = (TextNoteView *)sender;
    [UIView animateWithDuration:.25
                     animations:^{
                         note.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                     }
                     completion:^(BOOL completed){
                         [note setBackgroundColor:[UIColor colorWithRed:236.0f/255.0f
                                                                  green:236.0f/255.0f
                                                                   blue:236.0f/255.0f
                                                                  alpha:0.9f]];
                     }
     ];
}

- (void)textNoteView:(id)sender presentFullScreen:(BOOL)animated
{
    FullScreenNoteViewController *fullScreen = [[FullScreenNoteViewController alloc] initWithNibName:FullScreenNoteVCNibName bundle:nil];
    fullScreen.text.text = [(TextNoteView *)sender text].text;
    fullScreen.title = [(TextNoteView *)sender title].text;
    [[self parentViewController] presentViewController:fullScreen animated:YES completion:^{
        //
    }];
}

@end
