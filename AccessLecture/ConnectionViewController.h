//
//  ConnectionViewController.h
//  AccessLecture
//
//  Created by Michael Timbrook on 6/28/13.
//
//

#import <UIKit/UIKit.h>
#import "ALNetworkInterface.h"
#import "QRScanner.h"
#import <AVFoundation/AVFoundation.h>

static NSString* const ConnectionViewControllerXIB = @"ConnectionViewController";

@protocol ConnectionView <NSObject>

- (void)didCompleteWithConnection:(ALNetworkInterface *)server toLecture:(NSString *)lectureName from:(NSString *)connectionAddress;
- (void)userDidCancel;

@end

@interface ConnectionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationBar *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UITextField *connectionAddress;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *streamButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITextField *lecture;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIView *scanButtonView;
@property (weak, nonatomic) IBOutlet UIView *favoritesToolbar;
@property (weak, nonatomic) IBOutlet UILabel *scanStatusLabel;
@property id<ConnectionView> delegate;

- (IBAction)checkAddress:(id)sender;
- (IBAction)userDidCancel:(id)sender;
- (IBAction)connectToStream:(id)sender;
- (IBAction)startScan:(id)sender;

@end
