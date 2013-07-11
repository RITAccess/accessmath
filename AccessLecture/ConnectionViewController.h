//
//  ConnectionViewController.h
//  AccessLecture
//
//  Created by Michael Timbrook on 6/28/13.
//
//

#import <UIKit/UIKit.h>
#import "ALNetworkInterface.h"

static NSString* const ConnectionViewControllerXIB = @"ConnectionViewController";

@protocol ConnectionView <NSObject>

- (void)didCompleteWithConnection:(ALNetworkInterface *)server;
- (void)userDidCancel;

@end

@interface ConnectionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UITextField *connectionAddress;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *streamButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITextField *lecture;

@property id<ConnectionView> delegate;

- (IBAction)checkAddress:(id)sender;
- (IBAction)userDidCancel:(id)sender;
- (IBAction)connectToStream:(id)sender;

@end
