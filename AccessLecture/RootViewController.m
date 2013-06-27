// Copyright 2011 Access Lecture. All rights reserved.

#import "RootViewController.h"
#import "AccessLectureAppDelegate.h"
#import "DrawViewController.h" // Only for testing

@implementation RootViewController

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES; 
    
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Instantiating DrawViewController for testing
    DrawViewController *drawViewController = [[DrawViewController alloc] initWithNibName:@"DrawViewController" bundle:nil];
    [self presentModalViewController:drawViewController animated:NO];
}

/**
 * Open an active connection to the server
 */
- (IBAction)connectToServer:(id)sender {
    
    [self performSegueWithIdentifier:@"showConnect"sender:nil];
    
}

/**
 Do we want the application to be rotateable? Return YES or NO
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
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

/**
 Release resources from memory
 */

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
