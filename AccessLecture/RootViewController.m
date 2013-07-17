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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toLectureConnect"]){
        LectureViewContainer *lectureViewContainer = [segue destinationViewController];
        StreamViewController *svc = (StreamViewController *)[[UIStoryboard storyboardWithName:StreamViewControllerStoryboard bundle:nil] instantiateViewControllerWithIdentifier:StreamViewControllerID];
        [lectureViewContainer addController:svc];
        svc.displayConnectView = YES;
    }
}

#pragma mark - Buttons

- (IBAction)openAbout:(id)sender
{
    [self performSegueWithIdentifier:@"toAbout" sender:nil];
}

/**
 * Open an active connection to the server.
 */
- (IBAction)connectToServer:(id)sender
{
    [self performSegueWithIdentifier:@"showConnect"sender:nil];
}

- (IBAction)openLecture:(id)sender
{
    [self performSegueWithIdentifier:@"toLectureController" sender:nil];    
}

/**
 * Takes user directly to the lecture connect view.
 */
- (IBAction)openConnect:(id)sender
{
    [self performSegueWithIdentifier:@"toLectureConnect" sender:nil];
}

@end
