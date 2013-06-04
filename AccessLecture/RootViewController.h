// Copyright 2011 Access Lecture. All rights reserved.

#import <UIKit/UIKit.h>
#import "LectureViewController.h"
#import "AboutViewController.h"

@interface RootViewController : UIViewController {

    // The lecture view
    LectureViewController *lectureViewController;
    AboutViewController *aboutViewController;
    
}

- (IBAction)openAbout:(id)sender;

@end
