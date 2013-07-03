// Copyright 2011 Access Lecture. All rights reserved.

#import <UIKit/UIKit.h>
#import "AboutViewController.h"
#import "Lecture.h"
#import "ALNetworkInterface.h"

@interface RootViewController : UIViewController {

    // The lecture view
    AboutViewController *aboutViewController;
    
}

-(IBAction)openAbout:(id)sender;
- (IBAction)connectToServer:(id)sender;
- (IBAction)openLecture:(id)sender;

@end
