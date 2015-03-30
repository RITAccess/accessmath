// Copyright 2011 Access Lecture. All rights reserved.

#import <IQKeyboardManager/IQKeyboardManager.h>

#import "AccessLectureAppDelegate.h"
#import "FileManager.h"
#import "MockData.h"

@implementation AccessLectureAppDelegate

@synthesize window, navigationController, defaults;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

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
        });
    }
    
    #endif    
    
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
    
    // Keyboard Manager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    return YES;
}

/**
 * Did fall from main view
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    
}

/**
 * Resume main view
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AccessLecture" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AccessLecture.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Should properly handle dump here, abort() shouldn't be used in production
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
