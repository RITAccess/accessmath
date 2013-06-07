// Copyright 2011 Access Lecture. All rights reserved.

#import <UIKit/UIKit.h>
#import "LectureViewController.h"
#import "AboutViewController.h"
#import "Lecture.h"
#import "ALNetworkInterface.h"

@interface RootViewController : UIViewController <LectureStreaming> {

    // The lecture view
    LectureViewController *lectureViewController;
    AboutViewController *aboutViewController;
    
}

-(IBAction)openNewLecture:(id)sender;
-(IBAction)openAbout:(id)sender;
- (IBAction)connectToServer:(id)sender;
- (IBAction)connectToLecture:(id)sender;
- (IBAction)openLecture:(id)sender;

@end
