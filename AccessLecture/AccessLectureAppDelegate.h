// Copyright 2011 Access Lecture. All rights reserved.

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AccessLectureAppDelegate : NSObject <UIApplicationDelegate>
{
    // The navigation controller that allows us to change views
    UINavigationController* navigationController;
    
    // The user settings
    NSUserDefaults* defaults;
    
    // Core Data
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic) IBOutlet UIWindow* window;
@property (nonatomic) NSUserDefaults* defaults;
@property (nonatomic, strong) UINavigationController* navigationController;

// Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory;

@end
