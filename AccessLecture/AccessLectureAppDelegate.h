// Copyright 2011 Access Lecture. All rights reserved.

#import <UIKit/UIKit.h>
#import "ALMetaData.h"//Added by Rafique
#import "AMLecture.h"

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

//Below is added by Rafique
@property (nonatomic, strong) ALMetaData *metadata;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) AMLecture *lecture;

- (NSURL *)applicationDocumentsDirectory; // nice to have to reference files for core data

@end
