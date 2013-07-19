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
    ALNetworkInterface *_server;
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
    [_loadProgress setProgress:0.0];
    [_loadProgress setHidden:YES];
    
    [self.canvas setHidden:YES];
    
    // Clear view
    [self.view setBackgroundColor:[UIColor clearColor]];
}

#pragma mark Actions

- (IBAction)connectToStream:(id)sender
{
    if (!_connectedToStream) {
        ConnectionViewController *cvc = [[ConnectionViewController alloc] initWithNibName:ConnectionViewControllerXIB bundle:nil];
        [cvc setDelegate:self];
        [self presentViewController:cvc animated:YES completion:^{
            [_loadProgress setProgress:0.0];
            [_loadProgress setHidden:NO];
        }];
    } else {
        [_server disconnect];
        _connectedToStream = NO;
        [_joinLeaveStream setTitle:@"Join Stream"];
    }
}

#pragma mark Connection View Delegate Methods

- (void)didCompleteWithConnection:(ALNetworkInterface *)server toLecture:(NSString *)lectureName
{
    [_joinLeaveStream setTitle:@"Disconnect"];
    _connectedToStream = YES;
    [server setDelegate:self];
    _server = server;
    [self.lectureNameLabel setText:lectureName];
    [self.canvas setHidden:NO];
}

- (void)userDidCancel
{
    NSLog(@"User Canceled");
    [_loadProgress setHidden:YES];
}

#pragma mark Child View Controller Calls

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [_bottomToolbar setHidden:NO];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"Active!");
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
    NSLog(@"Will leave active state");
}

- (void)didLeaveActiveState
{
    NSLog(@"Did leave active state");
}

- (UIView *)contentView
{
    return self.canvas;
}

#pragma mark Streaming

- (void)didFinishDownloadingLecture:(Lecture *)lecture
{
    
}

- (void)didFinishRecievingUpdate:(NSArray *)data
{
    
}

- (void)didRecieveUpdate:(CGPoint)point type:(ALPointType)type
{
    if (type == ALPointTypeMoveTo) {
        [_canvas startNewLineAtPoint:point];
    } else {
        [_canvas addPointToLine:point];
    }
    [_canvas setNeedsDisplay];
}

- (void)currentStreamUpdatePercentage:(float)percent
{
    [_loadProgress setProgress:percent/100 animated:YES];
}

- (void)didFinishRecievingBulkUpdate:(NSArray *)data
{
    [_canvas drawBulkUpdate:data];
    [_loadProgress setHidden:YES];
}

- (void)didFailToConnectTo:(NSString *)lecture
{
    UIAlertView *failed = [[UIAlertView alloc] initWithTitle:@"No Class Found" message:[NSString stringWithFormat:@"Failed to connect to %@.", lecture] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [self connectToStream:nil];
    [_loadProgress setHidden:YES];
    [failed show];
}

- (void)didWantToClearScreen
{
    [self.canvas clearScreen];
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
