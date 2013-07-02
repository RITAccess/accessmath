//
//  StreamViewController.h
//  AccessLecture
//
//  Created by Michael Timbrook on 6/27/13.
//
//

#import <UIKit/UIKit.h>
#import "LectureViewContainer.h"
#import "AccessLectureAppDelegate.h"
#import "ALNetworkInterface.h"
#import "ConnectionViewController.h"
#import "StreamDrawing.h"

static NSString* const StreamViewControllerXIB = @"StreamViewController";

@interface StreamViewController : UIViewController <LectureViewChild, LectureStreaming, ConnectionView>
- (IBAction)connectToStream:(id)sender; // Or leave

@property (strong, nonatomic) IBOutlet StreamDrawing *canvas;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;
@property (weak, nonatomic) IBOutlet UIProgressView *loadProgress;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *joinLeaveStream;
@end
