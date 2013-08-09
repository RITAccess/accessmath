// Copyright 2011 Access Lecture. All rights reserved.

#import "AccessLectureAppDelegate.h"
#import "FileManager.h"

@implementation AccessLectureAppDelegate

@synthesize window, rootViewController, navigationController, defaults;

/**
 Customization after application launches
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

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
    
    // Set up the network socket connection
    _server = [[ALNetworkInterface alloc] initWithURL:_serverAddress];
    
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
