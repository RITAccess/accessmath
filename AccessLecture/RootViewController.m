// Copyright 2011 Access Lecture. All rights reserved.

#import "RootViewController.h"

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


#pragma mark - Buttons

- (IBAction)openAbout:(id)sender
{
    [self performSegueWithIdentifier:@"toAbout" sender:nil];
}

- (IBAction)openLecture:(id)sender
{
    [self performSegueWithIdentifier:@"toLecture" sender:nil];    
}

@end