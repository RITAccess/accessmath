// Copyright 2011 Access Lecture. All rights reserved.

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "ALNetworkInterface.h"

@interface AccessLectureAppDelegate : NSObject <UIApplicationDelegate>
{
    
    // The navigation controller that allows us to change views
    UINavigationController* navigationController;
    
    // The first view we see
    RootViewController* rootViewController;
    
    // The user settings
    NSUserDefaults* defaults;

}

@property (nonatomic) IBOutlet UIWindow* window;
@property (nonatomic) NSUserDefaults* defaults;
@property (nonatomic, strong)  RootViewController* rootViewController;
@property (nonatomic, strong) UINavigationController* navigationController;

// Network Interface
@property (nonatomic, strong) ALNetworkInterface *server;
@property (nonatomic, strong) NSString *serverAddress;

@end
