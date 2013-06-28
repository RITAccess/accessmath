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

@property id<ConnectionView> delegate;

- (IBAction)userDidCancel:(id)sender;
@end
