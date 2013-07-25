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

@implementation ConnectionViewController
{
    ALNetworkInterface *server;
    QRScanner *scanner;
    AVCaptureVideoPreviewLayer *preview;
    UIButton *cancelButton;
    BOOL isScanning;
    NSMutableArray *lectureFavorites, *serverFavorites;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_activity stopAnimating];
    [_streamButton setEnabled:NO];
    
    AccessLectureAppDelegate *app = [UIApplication sharedApplication].delegate;
    server = app.server;
    
    [self checkAddress:nil];
    
    // Check if already connected
    if ([server connected]) {
        [_statusLabel.topItem setTitle:@"Connected"];
        [_connectionAddress setText:server.connectionURL];
        [_streamButton setEnabled:YES];
    }
    
    // Checking for proper OS. We might need to enhance this check later.
    if ([[[UIDevice currentDevice]systemVersion] isEqualToString:@"7.0"]){
        [_scanStatusLabel removeFromSuperview];
    } else {
        [_previewView setBackgroundColor:[UIColor redColor]];
    }
    
    isScanning = NO;
    
    if (!lectureFavorites) lectureFavorites = [NSMutableArray new];
    if (!serverFavorites) serverFavorites = [NSMutableArray new];
    
    [self populateFavorites];
}

# pragma mark - UI Events

- (IBAction)checkAddress:(id)sender
{
    [_activity startAnimating];
    [_statusLabel.topItem setTitle:@"Checking connection"];
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [self connectWithURL:[NSURL URLWithString:_connectionAddress.text]];
    }];
}

- (IBAction)startScan:(id)sender
{
    isScanning = YES;
    
    // Hiding UI elements.
    [_connectionAddress setHidden:YES];
    [_lecture setHidden:YES];
    [_statusLabel setHidden:YES];
    [self.view endEditing:YES];  // Along with method override, dimisses keyboard.
    
    scanner = [QRScanner new];
    [scanner startCaptureWithCompletion:^(NSDictionary *info) {
        [server disconnect];
        [server setConnectionURL:info[@"url"]];
        [server connectCompletion:^(BOOL success) {
            if (success) {
                [server requestAccessToLectureSteam:info[@"lecture"]];
                if ([_delegate respondsToSelector:@selector(didCompleteWithConnection: toLecture: from:)]) {
                    [_delegate didCompleteWithConnection:server toLecture:_lecture.text from:_connectionAddress.text];
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
        [_previewView setBackgroundColor:[UIColor clearColor]];
        
        cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(_previewView.frame.size.width - 100, _previewView.frame.size.height - 50, 100, 50)];
        [cancelButton addTarget:self action:@selector(userDidCancel:) forControlEvents:UIControlEventTouchDown];
        [cancelButton setBackgroundColor:[UIColor clearColor]];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_previewView addSubview:cancelButton];
    }];
}

/**
 * Called when 'Cancel' button is pressed. Sets scanning flag to NO, dismisses ConnectionViewController nib.
 */
- (IBAction)userDidCancel:(id)sender
{
    isScanning = NO;
    if ([_delegate respondsToSelector:@selector(userDidCancel)]) {
        
        [_delegate userDidCancel];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)connectToStream:(id)sender
{
    [server requestAccessToLectureSteam:_lecture.text];
    if ([_delegate respondsToSelector:@selector(didCompleteWithConnection: toLecture: from:)]) {
        [_delegate didCompleteWithConnection:server toLecture:_lecture.text from:_connectionAddress.text];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - Rotation Handling

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //  NOTE: decimal points in the CATransform are necessary.
    if (_previewView && isScanning){
        if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait){
            [_previewView.layer setTransform:CATransform3DMakeRotation(0 / 180.0 * M_PI, 0.0, 0.0, 1.0)];
            [self configureScanViewWithOrientation:0];
        } else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft){
            [_previewView.layer setTransform:CATransform3DMakeRotation(90.0 / 180.0 * M_PI, 0.0, 0.0, 1.0)];
            [self configureScanViewWithOrientation:90];
        } else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown){
            [_previewView.layer setTransform:CATransform3DMakeRotation(180.0 / 180.0 * M_PI, 0.0, 0.0, 1.0)];
            [self configureScanViewWithOrientation:180];
        }else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight){
            [_previewView.layer setTransform:CATransform3DMakeRotation(270.0 / 180.0 * M_PI, 0.0, 0.0, 1.0)];
            [self configureScanViewWithOrientation:270];
        }
    }
}

/**
 * Resets scan view to fill the view. Used for handling rotation.
 */
- (void)configureScanViewWithOrientation:(int)orientation
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

#pragma mark - Table View

- (void)populateFavorites
{
    [lectureFavorites insertObject:@"Physics" atIndex:0];
    [lectureFavorites insertObject:@"Math" atIndex:1];
    [lectureFavorites insertObject:@"Programming" atIndex:2];
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [serverFavorites insertObject:@"michaeltimbrook.com" atIndex:0];
    [serverFavorites insertObject:@"testing.rit.edu" atIndex:1];
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? lectureFavorites.count : serverFavorites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"LectureCell" forIndexPath:indexPath];
        cell.textLabel.text = [lectureFavorites[indexPath.row] description];
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ServerCell" forIndexPath:indexPath];
        cell.textLabel.text = [serverFavorites[indexPath.row] description];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        [_lecture setText:[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]];
    } else {
        [_connectionAddress setText:[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:@"SectionHeader"];
    headerView.textLabel.font = [UIFont boldSystemFontOfSize:14];
    headerView.textLabel.text = @"Lectures";
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

# pragma mark - Helpers

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 * Overriding to allow for automatic keyboard dismissal once scan button is pressed.
 */
- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

@end
