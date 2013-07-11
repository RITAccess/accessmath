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

@interface ConnectionViewController ()

@end

@implementation ConnectionViewController {
    ALNetworkInterface *server;
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
    
    [_statusLabel setHidden:YES];
    [_activity stopAnimating];
    [_streamButton setEnabled:NO];
    
    AccessLectureAppDelegate *app = [UIApplication sharedApplication].delegate;
    server = app.server;
    
    // Check if already connected
    if ([server connected]) {
        [_statusLabel setText:@"Connected"];
        [_statusLabel setHidden:NO];
        [_connectionAddress setText:server.connectionURL];
        [_streamButton setEnabled:YES];
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
    [_statusLabel setText:@"Checking connection"];
    [_statusLabel setHidden:NO];
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [self connect];
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

#pragma mark Connect

- (void)connect
{
    [server disconnect];
    [server setConnectionURL:[_connectionAddress text]];
    [server connectCompletion:^(BOOL success) {
        if (success) {
            [_statusLabel setText:@"Connected"];
            [_activity stopAnimating];
            [_streamButton setEnabled:YES];
        } else {
            [_statusLabel setText:@"Failed to connect to server"];
            [_activity stopAnimating];
        }
    }];
}

@end
