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

@property (nonatomic) IBOutlet UIWindow* window;
@property (nonatomic) NSUserDefaults* defaults;
@property (nonatomic) IBOutlet RootViewController* rootViewController;
@property (nonatomic) IBOutlet UINavigationController* navigationController;

@end
