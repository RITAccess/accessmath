// Copyright 2011 Access Lecture. All rights reserved.

#import "AccessLectureAppDelegate.h"


@implementation AccessLectureAppDelegate

@synthesize window, rootViewController, navigationController, defaults;

/**
 Customization after application launches
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    UINavigationController *rootNavigationController = (UINavigationController *)self.window.rootViewController;
//    RootViewController *rootViewController = (RootViewController *)[rootNavigationController topViewController];
    
    //    // Initalize the root view controller (our home screen)
//    rootViewController = (UINavigationController* )self.window.rootViewController;
    
    // Initialize the navigation cobtroller with the root view controller 
//    navigationController = [navigationController initWithRootViewController: rootViewController];
    
    // Set the application defaults
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:0.0f forKey:@"toolbarAlpha"];
    [defaults setFloat:0.5f forKey:@"userScrollSpeed"];
    [defaults setFloat:0.3f forKey:@"tbRed"];
    [defaults setFloat:0.3f forKey:@"tbGreen"];
    [defaults setFloat:0.3f forKey:@"tbBlue"];
    [defaults setFloat:1.0f forKey:@"textRed"];
    [defaults setFloat:1.0f forKey:@"textGreen"];
    [defaults setFloat:1.0f forKey:@"textBlue"];
    [defaults setFloat:0.0145f forKey:@"userZoomIncrement"];
    [defaults setFloat:.3 forKey:@"penSize"];
    [defaults setFloat:.2 forKey:@"eraserSize"];
    [defaults setValue:@"biology.png" forKey:@"testImage"];
    [defaults synchronize];
    
    // Set the starting view
//    self.window.rootViewController = self.navigationController;
//    [self.window makeKeyAndVisible];
    
    // Set up the network socket connection
    _server = [[ALNetworkInterface alloc] initWithURL:@"micaheltimbrook.com"];
    NSLog(@"Setup complete");
    
    return YES;
}

/**
 * Did fall from main view
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"Lost active");
    NSLog(@"Was connected to server? %@", _server.wasConnected ? @"Yes": @"No");
}

/**
 * Resume main view
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

@end
