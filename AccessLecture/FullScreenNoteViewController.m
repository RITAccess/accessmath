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

- (IBAction)changeFontStyle:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [_text setFont:[UIFont systemFontOfSize:_text.font.pointSize]];
            break;
        case 1:
            [_text setFont:[UIFont boldSystemFontOfSize:_text.font.pointSize]];
            break;
        case 2:
            [_text setFont:[UIFont italicSystemFontOfSize:_text.font.pointSize]];
            break;
        default:
            break;
    }
}

#pragma mark - Helpers

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
