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
        self.view.frame = CGRectMake(point.x - 200, point.y - 100, self.view.frame.size.width, self.view.frame.size.height);
        [(TextNoteView *)self.view setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Delegate

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
