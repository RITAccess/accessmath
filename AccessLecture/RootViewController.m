//
//  RootViewController.m
//  AccessLecture
//
//  Modified by Piper Chester on 7/17/13.
//
//

#import "RootViewController.h"
#import "AccessLectureAppDelegate.h"
#import "InlineViewVController.h"

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 * Open an active connection to the server.
 */
- (IBAction)connectToServer:(id)sender
{
    [self performSegueWithIdentifier:@"showConnect"sender:nil];
}

/**
 * Do we want the application to be rotateable? Return YES or NO.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Buttons

- (IBAction)openAbout:(id)sender
{
    [self performSegueWithIdentifier:@"toAbout" sender:nil];
}

- (IBAction)openLecture:(id)sender
{
    [self performSegueWithIdentifier:@"toLectureController" sender:nil];    
}

@end
