// Copyright 2011 Access Lecture. All rights reserved.

#import "RootViewController.h"
#import "AccessLectureAppDelegate.h"

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
    [self performSegueWithIdentifier:@"toLecture" sender:nil];    
}

/**
 Release resources from memory
 */

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
