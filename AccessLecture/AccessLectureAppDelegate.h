// Copyright 2011 Access Lecture. All rights reserved.

#import <UIKit/UIKit.h>

@interface AccessLectureAppDelegate : NSObject <UIApplicationDelegate>
{
    // The navigation controller that allows us to change views
    UINavigationController* navigationController;
    
    // The user settings
    NSUserDefaults* defaults;
}

@property (nonatomic) IBOutlet UIWindow* window;
@property (nonatomic) NSUserDefaults* defaults;
@property (nonatomic, strong) UINavigationController* navigationController;

@end
