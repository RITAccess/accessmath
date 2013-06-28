//
//  ConnectionViewController.h
//  AccessLecture
//
//  Created by Michael Timbrook on 6/28/13.
//
//

#import <UIKit/UIKit.h>

static NSString* const ConnectionViewControllerXIB = @"ConnectionViewController";

@protocol ConnectionView <NSObject>

- (void)didCompleteWithConnection;
- (void)userDidCancel;

@end

@interface ConnectionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UITextField *connectionAddress;

@property id<ConnectionView> delegate;

- (IBAction)checkAddress:(id)sender;
- (IBAction)userDidCancel:(id)sender;
@end
