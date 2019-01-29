// Copyright 2011 Access Lecture. All rights reserved.

#import <IQKeyboardManager/IQKeyboardManager.h>

#import "AccessLectureAppDelegate.h"
#import "FileManager.h"
#import "MockData.h"
#import "AMIndex.h"

@implementation AccessLectureAppDelegate

@synthesize window, navigationController, defaults;

//Below is added by Rafique (for Core Data)
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContextForLecture:(AMLecture*)lecture{
    /*
    if (_managedObjectContext != nil) {
        NSEnumerator *enum1 = _persistentStoreCoordinator.persistentStores.objectEnumerator;
        
        return _persistentStoreCoordinator.persistentStores.objectEnumerator
    }*/
    
    if([[[self managedObjectModel] entitiesByName] objectForKey:lecture.metadata.title]) {
        return [[[[self managedObjectModel] entitiesByName] objectForKey:lecture.metadata.title] managedObjectModel] ;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AccessLecture" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", @"1Lecture"]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

//additional method to work with multiple lectures (multiple persistent stores)
- (NSPersistentStoreCoordinator *)addPersistentStoreCoordinatorForLecture:(AMLecture*)lecture
{
    /*
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
     */
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", lecture]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//Till here

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
