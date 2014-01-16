//
//  TextNoteViewController.m
//  AccessLecture
//
//  Created by Michael on 1/6/14.
//
//

#import "TextNoteViewController.h"
#import "FullScreenNoteViewController.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Delegate

- (void)textNoteView:(id)sender didHide:(BOOL)hide
{

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
