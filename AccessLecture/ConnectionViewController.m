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
    BOOL isScanning, isDeleting;
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
    
    // Initializing Lecture and Server arays.
    if (!lectureFavorites) lectureFavorites = [NSMutableArray new];
    if (!serverFavorites) serverFavorites = [NSMutableArray new];
    
    // Adding Gestures.
    UISwipeGestureRecognizer *swipeToDelete = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleCell:)];
    [swipeToDelete setDirection:UISwipeGestureRecognizerDirectionRight];
    [_tableView addGestureRecognizer:swipeToDelete];
    
    UITapGestureRecognizer *tapToAdd = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addFavoriteCellAtSection:)];
    [tapToAdd setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:tapToAdd];
    
    isScanning = NO;  // Flag for QR scanning. Hides on load.
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
    [_tableView setHidden:YES];
    [_scanButton setHidden:YES];
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
    
    // Set up Scan View.
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

/**
 * Handles gestures on table view cells. Hold to delete, swipe in either direction to show insert mode.
 */
- (void)handleCell:(UIGestureRecognizer *)gesture
{
    if (_tableView.editing == YES){
        isDeleting = NO;
        [_tableView setEditing:NO];
    } else {
        isDeleting = YES;
        [_tableView setEditing:YES];
    }
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
    } else if (indexPath.section == 1) {
        [_connectionAddress setText:[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]];
    }
    
    [self checkAddress:nil];  // After selected cell, check the address.
    [self setEditing:YES animated:YES];
}

/**
 * Setting up headers.
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    [headerCell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [headerCell.textLabel setTextColor:[UIColor grayColor]];
    [headerCell setBackgroundColor:[UIColor clearColor]];
    
    (section == 0) ? [[headerCell textLabel] setText:@"Lectures"] : [[headerCell textLabel] setText:@"Servers"];
    return headerCell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0){
            [lectureFavorites removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else if (indexPath.section == 1){
            [serverFavorites removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        isDeleting = NO;
        [_tableView setEditing:NO animated:NO];
    }
}

- (void)addFavoriteCellAtSection:(int)section
{
    if (![lectureFavorites containsObject:_lecture.text] && ![_lecture.text isEqualToString:@""]){
        [lectureFavorites insertObject:_lecture.text atIndex:0];
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    if (![serverFavorites containsObject:_connectionAddress.text] && ![_connectionAddress.text isEqualToString:@""]){
        [serverFavorites insertObject:_connectionAddress.text atIndex:0];
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return isDeleting ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? lectureFavorites.count : serverFavorites.count;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

# pragma mark - Rotation Handling

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
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

# pragma mark - Helpers

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

@end
