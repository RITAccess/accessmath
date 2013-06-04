// Copyright 2011 Access Lecture. All rights reserved.

#import "RootViewController.h"

@implementation RootViewController

/**
 Logic for when the screen first loads
 */
- (void)viewDidLoad{
    
    // Hide the navigation bar if we don't want to see it
    self.navigationController.navigationBarHidden = YES; 
    
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

- (IBAction)openAbout:(id)sender
{
    [self performSegueWithIdentifier:@"toAbout" sender:nil];
}

@end