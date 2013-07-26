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
 * Do we want the application to be rotateable? Return YES or NO.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Buttons

- (IBAction)openAbout:(id)sender
{
    [self performSegueWithIdentifier:@"toAbout" sender:@""];
}

- (IBAction)openLecture:(id)sender
{
    [self performSegueWithIdentifier:@"toLectureController" sender:@""];
}

/**
 * Takes user directly to the lecture connect view.
 */
- (IBAction)openConnect:(id)sender
{
    [self performSegueWithIdentifier:@"toLectureController" sender:@"connect"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isEqualToString:@"connect"]){
        LectureViewContainer *lectureViewContainer = [segue destinationViewController];
        StreamViewController *svc = (StreamViewController *)[[UIStoryboard storyboardWithName:StreamViewControllerStoryboard bundle:nil] instantiateViewControllerWithIdentifier:StreamViewControllerID];
        [lectureViewContainer addController:svc];
        [svc setDisplayServerConnectView:YES];   // Segue directly into the ServerConnectView.
    }
}

@end
