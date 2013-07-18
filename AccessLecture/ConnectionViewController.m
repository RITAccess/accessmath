//
//  ConnectionViewController.m
//  AccessLecture
//
//  Created by Michael Timbrook on 6/28/13.
//
//

#import "ConnectionViewController.h"
#import "AccessLectureAppDelegate.h"
#import "ALNetworkInterface.h"
#import <QuartzCore/CATransform3D.h>

@interface ConnectionViewController ()

@end

@implementation ConnectionViewController {
    ALNetworkInterface *server;
    QRScanner *scanner;
    UITapGestureRecognizer *_tapToScan;
    AVCaptureVideoPreviewLayer *preview;
    UIButton *cancelButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_activity stopAnimating];
    [_streamButton setEnabled:NO];
    
    AccessLectureAppDelegate *app = [UIApplication sharedApplication].delegate;
    server = app.server;
    
    _connectionAddress.text = @"michaeltimbrook.com";
    [self checkAddress:nil];
    _lecture.text = @"Testing";
    
    // Check if already connected
    if ([server connected]) {
        [_statusLabel.topItem setTitle:@"Connected"];
        [_connectionAddress setText:server.connectionURL];
        [_streamButton setEnabled:YES];
    }
    
    // Checking for proper OS. We might need to enhance this check later.
    if ([[[UIDevice currentDevice]systemVersion] isEqualToString:@"7.0"]){
        _tapToScan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scan:)];
        [_tapToScan setCancelsTouchesInView:YES];
        [_previewView addGestureRecognizer:_tapToScan];
        [_previewView setBackgroundColor:[UIColor redColor]];
    } else {
        [_previewView setBackgroundColor:[UIColor grayColor]];
        UILabel *nope = [[UILabel alloc] initWithFrame:CGRectMake(_previewView.frame.size.width / 2 - 125, _previewView.frame.size.height / 2 - 15, 250, 30)];
        [nope setBackgroundColor:[UIColor clearColor]];
        [nope setTextColor:[UIColor whiteColor]];
        [nope setTextAlignment:NSTextAlignmentCenter];
        [nope setText:@"Scanning not available..."];
        [_previewView addSubview:nope];
        [_connectionAddress becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkAddress:(id)sender
{
    [_activity startAnimating];
    [_statusLabel.topItem setTitle:@"Checking connection"];
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [self connectWithURL:[NSURL URLWithString:_connectionAddress.text]];
    }];
}

- (IBAction)userDidCancel:(id)sender
{
    if ([_delegate respondsToSelector:@selector(userDidCancel)]) {
        [_delegate userDidCancel];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)connectToStream:(id)sender
{
    [server requestAccessToLectureSteam:_lecture.text];
    if ([_delegate respondsToSelector:@selector(didCompleteWithConnection:)]) {
        [_delegate didCompleteWithConnection:server];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scan:(UITapGestureRecognizer *)reg
{
    [_tapToScan setEnabled:NO];
    scanner = [QRScanner new];
    [scanner startCaptureWithCompletion:^(NSDictionary *info) {
        [server disconnect];
        [server setConnectionURL:info[@"url"]];
        [server connectCompletion:^(BOOL success) {
            if (success) {
                [server requestAccessToLectureSteam:info[@"lecture"]];
                if ([_delegate respondsToSelector:@selector(didCompleteWithConnection:)]) {
                    [_delegate didCompleteWithConnection:server];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSLog(@"fail");
            }
        }];
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        [_previewView setFrame:self.view.frame];
    } completion:^(BOOL finished) {
        AVCaptureSession *session  = [scanner session];
        preview = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [preview setBounds:_previewView.layer.bounds];
        [preview setPosition:CGPointMake(CGRectGetMidX(_previewView.layer.bounds), CGRectGetMidY(_previewView.layer.bounds))];
        [_previewView.layer addSublayer:preview];
        
        cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(_previewView.frame.size.width - 100, _previewView.frame.size.height - 50, 100, 50)];
        [cancelButton addTarget:self action:@selector(userDidCancel:) forControlEvents:UIControlEventTouchDown];
        [cancelButton setBackgroundColor:[UIColor clearColor]];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_previewView addSubview:cancelButton];
    }];
}

# pragma mark - Rotation Handling

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //  NOTE: decimal points in the CATransform are necessary.
    if (_previewView){
        if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait){
            [_previewView.layer setTransform:CATransform3DMakeRotation(0 / 180.0 * M_PI, 0.0, 0.0, 1.0)];
            [self configureScanViewWithDuration:0 withOrientation:0];
        } else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft){
            [_previewView.layer setTransform:CATransform3DMakeRotation(90.0 / 180.0 * M_PI, 0.0, 0.0, 1.0)];
            [self configureScanViewWithDuration:0 withOrientation:90];
        } else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown){
            [_previewView.layer setTransform:CATransform3DMakeRotation(180.0 / 180.0 * M_PI, 0.0, 0.0, 1.0)];
            [self configureScanViewWithDuration:0 withOrientation:180];
        }else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight){
            [_previewView.layer setTransform:CATransform3DMakeRotation(270.0 / 180.0 * M_PI, 0.0, 0.0, 1.0)];
            [self configureScanViewWithDuration:0 withOrientation:270];
        }
    }
}

/**
 * Resets scan view to fill the view. Used for handling rotation.
 */
- (void)configureScanViewWithDuration:(NSTimeInterval)seconds withOrientation:(int)orientation
{
    [_previewView setFrame:self.view.frame];
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [preview setBounds:_previewView.layer.bounds];
    [preview setPosition:CGPointMake(CGRectGetMidX(_previewView.layer.bounds), CGRectGetMidY(_previewView.layer.bounds))];
    
    switch (orientation) {
        case 0:
            [cancelButton setTransform:CGAffineTransformMakeRotation(0 * M_PI / 180)];
            [cancelButton setFrame:CGRectMake(_previewView.frame.size.width - 100, _previewView.frame.size.height - 50, 100, 50)];
            break;
            
        case 90:
            [cancelButton setTransform:CGAffineTransformMakeRotation(270 * M_PI / 180)];
            [cancelButton setFrame:CGRectMake(_previewView.frame.size.width + 25, _previewView.frame.size.height - 620, 50, 100)];
            break;
        
        case 180:
            [cancelButton setTransform:CGAffineTransformMakeRotation(180 * M_PI / 180)];
            [cancelButton setFrame:CGRectMake(7, _previewView.frame.size.height - 615, 100, 50)];
            break;
        
        case 270:
            [cancelButton setTransform:CGAffineTransformMakeRotation(90 * M_PI / 180)];
            [cancelButton setFrame:CGRectMake(0, _previewView.frame.size.height - 175, 50, 100)];
            break;
            
        default:
            break;
    }
}

#pragma mark Connect

- (void)connectWithURL:(NSURL *)url
{
    [server disconnect];
    [server setConnectionURL:url.description];
    [server connectCompletion:^(BOOL success) {
        if (success) {
            [_statusLabel.topItem setTitle:@"Connected"];
            [_activity stopAnimating];
            [_streamButton setEnabled:YES];
        } else {
            [_statusLabel.topItem setTitle:@"Failed to connect to server"];
            [_activity stopAnimating];
        }
    }];
}

@end
