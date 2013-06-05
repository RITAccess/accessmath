// Copyright 2011 Access Lecture. All rights reserved.

#import "RootViewController.h"
#import "AccessLectureAppDelegate.h"

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
 * Open an active connection to the server
 */
- (IBAction)connectToServer:(id)sender {
    
    AccessLectureAppDelegate *app = [[UIApplication sharedApplication] delegate];

    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"Disconnect"]) {
        [app.server disconnect];
    } else {
        [app.server connectCompletion:^(BOOL success) {
            NSLog(@"%@", success ? @"Success" : @"Failed to connect");
        }];
    }
}

- (IBAction)connectToLecture:(id)sender {
    
    AccessLectureAppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    [app.server requestAccessToLectureSteam:@"Test Lecture 2"];
    
    [app.server setDelegate:self];
    
}

- (void)didRecieveUpdate:(id)data {
    NSLog(@"%@", data);
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

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end