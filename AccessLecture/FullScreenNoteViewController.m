//
//  FullScreenNoteViewController.m
//  AccessLecture
//
//  Created by Michael on 1/8/14.
//
//

#import "FullScreenNoteViewController.h"

@interface FullScreenNoteViewController ()

@end

@implementation FullScreenNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

- (IBAction)returnToLecture:(id)sender
{
    // Update note's text and size from the full screen editor.
    _noteView.text.text = _text.text;
    [_noteView.text setFont:[UIFont systemFontOfSize:_stepper.value]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeFontSize:(UIStepper *)sender
{
    [_text setFont:[UIFont systemFontOfSize:[sender value]]];
}
@end
