// Copyright 2011 Access Lecture. All rights reserved.

#import "AccessLectureAppDelegate.h"

@implementation AccessLectureAppDelegate

@synthesize window, rootViewController, navigationController, defaults;

/**
 Customization after application launches
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initalize the root view controller (our home screen)
    rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    
    // Initialize the navigation cobtroller with the root view controller 
    [navigationController initWithRootViewController: rootViewController];
    
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
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
    
}

/**
 Release resources from memory
 */
- (void)dealloc{
    [window release];
    [navigationController release];
    [super dealloc];
}

@end
