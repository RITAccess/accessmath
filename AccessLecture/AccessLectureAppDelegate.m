// Copyright 2011 Access Lecture. All rights reserved.

#import <IQKeyboardManager/IQKeyboardManager.h>

#import "AccessLectureAppDelegate.h"
#import "FileManager.h"
#import "MockData.h"
#import "AMIndex.h"

@implementation AccessLectureAppDelegate

@synthesize window, navigationController, defaults;

/**
 Customization after application launches
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Unit Testing
    #ifdef DEBUG
    NSDictionary *environment = [NSProcessInfo processInfo].environment;
    NSString *injectBundlePath = environment[@"XCInjectBundle"];
    if ([injectBundlePath.pathExtension isEqualToString:@"xctest"]) return YES;
    
    if ([environment[@"MOCKDATA"] boolValue]) {
        dispatch_queue_t generation = dispatch_queue_create("al.mockdata.generate", DISPATCH_QUEUE_CONCURRENT);
        NSLog(@"DEBUG: Mock Data loading");
        MockData *generator = [MockData new];
        dispatch_async(generation, ^{
            [generator generateData];
            NSLog(@"DEBUG: Mock Data Loaded");
            [[AMIndex sharedIndex] invalidate];
        });
    }
    #endif       
    
    // Index
    [AMIndex sharedIndex];
    
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
    [defaults setFloat:0.42f forKey:@"AMTextSize"];
    [defaults synchronize];
    
    // Keyboard Manager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    return YES;
}

/**
 * Resume main view
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

@end
