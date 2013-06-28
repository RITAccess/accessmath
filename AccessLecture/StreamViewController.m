//
//  StreamViewController.m
//  AccessLecture
//
//  Created by Michael Timbrook on 6/27/13.
//
//

#import "StreamViewController.h"
#import "ConnectionViewController.h"

@interface StreamViewController ()

@property BOOL connectedToStream;

@end

@implementation StreamViewController {
    UIView *test;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        [self.view setFrame:CGRectMake(0, 0, 768, 1024)];
    } else {
        [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    }
    // Do any additional setup after loading the view from its nib.
    test = [[UIView alloc] initWithFrame:CGRectMake(300, 400, 200, 200)];
    [test setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:test];
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
        test.transform = transform;
    } completion:nil];
}

#pragma mark Actions

- (IBAction)connectToStream:(id)sender
{
    ConnectionViewController *cvc = [[ConnectionViewController alloc] initWithNibName:ConnectionViewControllerXIB bundle:nil];
    [cvc setDelegate:self];
    [self presentViewController:cvc animated:YES completion:nil];
    
}

#pragma mark Connection View Delegate Methods

- (void)didCompleteWithConnection:(ALNetworkInterface *)server
{
    [server setDelegate:self];
}

- (void)userDidCancel
{
    NSLog(@"User Canceled");
}

#pragma mark Child View Controller Calls

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [_bottomToolbar setHidden:NO];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"Active!");
    
    
    [test setBackgroundColor:[UIColor orangeColor]];
}

- (void)willSaveState
{
    NSLog(@"Will save state");
}

- (void)didSaveState
{
    NSLog(@"Did save state");
}

- (void)willLeaveActiveState
{
    [_bottomToolbar setHidden:YES];
    [test setBackgroundColor:[UIColor grayColor]];
    NSLog(@"Will leave active state");
}

- (void)didLeaveActiveState
{
    NSLog(@"Did leave active state");
}

#pragma mark Streaming

- (void)didFinishDownloadingLecture:(Lecture *)lecture
{
    
}

- (void)didRecieveUpdate:(id)data
{
    NSLog(@"Recieved Data!");
}

- (void)currentStreamUpdatePercentage:(float)percent
{
    
}

- (void)didFinishRecievingBulkUpdate:(NSArray *)data
{
    
}

#pragma mark Orientation

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [UIView animateWithDuration:0.1 animations:^{
        if (UIInterfaceOrientationIsPortrait(fromInterfaceOrientation)) {
            [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
        } else {
            [self.view setFrame:CGRectMake(0, 0, 768, 1024)];
        }
    }];
}

@end
