//
//  FullScreenNoteViewController.m
//  AccessLecture
//
//  Created by Michael on 1/8/14.
//
//

#import "FullScreenNoteViewController.h"

@implementation FullScreenNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Interface Actions

/**
 * Dismiss controller, update note's text and font from 
 * the full screen editor.
 */
- (IBAction)returnToLecture:(id)sender
{
    _noteView.text.text = _text.text;
    _noteView.text.font = _text.font;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeFontSize:(UIStepper *)sender
{
    [_text setFont:[UIFont systemFontOfSize:[sender value]]];
}

#pragma mark - Helpers

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
