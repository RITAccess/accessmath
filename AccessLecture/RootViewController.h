//
//  RootViewController.h
//  AccessLecture
//
//  Modified by Piper Chester on 7/17/13.
//
//

#import <UIKit/UIKit.h>
#import "AboutViewController.h"
#import "Lecture.h"
#import "ALNetworkInterface.h"
#import "LectureViewContainer.h"


@interface RootViewController : UIViewController
{
    // The lecture view.
    AboutViewController *aboutViewController;
}

-(IBAction)openAbout:(id)sender;
- (IBAction)connectToServer:(id)sender;
- (IBAction)openLecture:(id)sender;
- (IBAction)openConnect:(id)sender;

@end
