//
//  AboutViewController.m
//  AccessLecture
//
//  Modified by Piper Chester on 7/17/13.
//
//

#import "AboutViewController.h"

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

/**
 * Dismisses about view and returns to home view.
 */
- (IBAction)returnToHome:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
