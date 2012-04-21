// Copyright 2011 Access Lecture. All rights reserved.

#import "RootViewController.h"

@implementation RootViewController

/**
 Open the new lecture screen
 */
-(IBAction)openNewLecture:(id)sender{
    [self.navigationController pushViewController:lectureViewController animated:YES];
}

/**
 Open the about screen
 */
-(IBAction)openAbout:(id)sender{
    [self.navigationController pushViewController:aboutViewController animated:YES];
}

/**
 Do we want the application to be rotateable? Return YES or NO
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);

}

/**
 Logic for when the screen first loads
 */
- (void)viewDidLoad{
    
    // Hide the navigation bar if we don't want to see it
    self.navigationController.navigationBarHidden = YES; 
    
    // Initialize the controllers we want to be able to push onto the controller stack
    lectureViewController = [[LectureViewController alloc] initWithNibName:@"LectureViewController" bundle:nil];
    aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    
    [super viewDidLoad];
}

/**
 In case there's a memory warning
 */
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

/**
 Release resources from memory
 */
- (void)dealloc{
    [super dealloc];
}

@end