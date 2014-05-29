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
#import "StreamViewController.h"

#import "AMLecture.h"
#import "FileManager.h"

@implementation RootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 * Do we want the application to be rotateable? Return YES or NO.
 */
- (BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark - Buttons

- (IBAction)openAbout:(id)sender
{    
    [self performSegueWithIdentifier:@"toAbout" sender:@""];
}

- (IBAction)openLecture:(id)sender
{
    [self performSegueWithIdentifier:@"toLectureController" sender:@"lecture"];
}

/**
 * Takes user directly to the lecture connect view.
 */
- (IBAction)openConnect:(id)sender
{
    [self performSegueWithIdentifier:@"toStreamController" sender:@"rootView"];
}

@end
