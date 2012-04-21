// Copyright 2011 Access Lecture. All rights reserved.

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AccessLectureAppDelegate : NSObject <UIApplicationDelegate> {
    
    // The navigation controller that allows us to change views
    UINavigationController* navigationController;
    
    // The first view we see
    RootViewController* rootViewController;
    
    // The user settings
    NSUserDefaults* defaults;

}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) NSUserDefaults* defaults;
@property (nonatomic, retain) IBOutlet RootViewController* rootViewController;
@property (nonatomic, retain) IBOutlet UINavigationController* navigationController;

@end
