//
//  FileManager.m
//  AccessLecture
//
//  Created by Steven Brunwasser on 3/19/12.
//  Modified by Pratik Rasam on 6/26/2013
//  Refactored by Michael Timbrook on 9/20/12
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//
//
//  A class to manage the finding of the documents directory for saving
//  and the opening of the document.
//

#import <stdlib.h>
#import <dirent.h>

#import "FileManager.h"
#import "AMLecture.h"
#import "Lecture.h"
#import "FileMangerViewController.h"

#import "Deferred.h"

@interface FileManager ()

@property (strong, nonatomic) AMLecture *document;

@end

@implementation FileManager
{
    // Completion handler
    void (^lectureLoaded)(AMLecture *);
}

#pragma mark Public APIs

+ (instancetype)defaultManager
{
    static FileManager *defaultManger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManger = [FileManager new];
    });
    return defaultManger;
}

- (void)currentDocumentWithCompletion:(void(^)(AMLecture *lecture))completion
{
    lectureLoaded = completion ?: ^(AMLecture *lec){ NSLog(@"%@", lec); };
    if (_document == nil) {
        // Document wasn't loaded
        [self promptUserToPickDocument];
    } else {
        // Otherwise return the open document
        lectureLoaded(_document);
    }
}

- (AMLecture *)currentDocument
{
    return _document;
}

- (void)forceSave
{
    [_document save];
}

- (void)finishedWithDocument
{
    [_document closeWithCompletionHandler:^(BOOL success) {
        _document = nil;
    }];
}

- (Promise *)currentDocumentPromise
{
    Deferred *lecturePromise = [Deferred deferred];
    [self currentDocumentWithCompletion:^(AMLecture *lecture) {
        [lecturePromise resolve:lecture];
    }];
    return [lecturePromise promise];
}

#pragma mark Document Internal

/**
 * Called by FileMangerViewController when document is choosen
 */
- (void)openDocumentForEditing:(NSString *)docName
{
    _document = [FileManager findDocumentWithName:docName];
    if (_document == nil) {
        NSLog(@"Failed to find document %@", docName);
    } else {
        [_document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                lectureLoaded(_document);
            } else {
                NSLog(@"Something when wrong opening the docuement");
            }
        }];
    }
}

/**
 * Presents the document picker controllers onto of the current active controller
 */
- (void)promptUserToPickDocument
{
    FileMangerViewController *openDoc = [[FileMangerViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                            navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                          options:nil];
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows firstObject];
    UIViewController *activeViewController = [mainWindow.rootViewController presentedViewController];
    [openDoc setModalPresentationStyle:UIModalPresentationFormSheet];
    [openDoc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [activeViewController presentViewController:openDoc animated:YES completion:nil];
}

#pragma mark Class Helper Methods
   
+ (NSArray *)listContentsOfDirectory:(NSString *)path
{
    NSError *err;
    NSArray *names = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&err];
    if (err) {
        NSLog(@"There was an error reading directory '%@', %@", path, err);
        return nil;
    }
    NSPredicate *dotLecture = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
        NSArray *sub = [evaluatedObject componentsSeparatedByString:@"."];
        return [sub[1] isEqualToString:AMLectutueFileExtention];
    }];
    return [names filteredArrayUsingPredicate:dotLecture];
}

+ (NSString *)localDocumentsDirectoryPath {
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return documentsDirectoryPath;
}

+ (NSURL *)iCloudDirectoryURL {
    NSURL * ubiquity = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    return ubiquity;
}

+ (AMLecture *)findDocumentWithName:(NSString *)name
{
    return [self findDocumentWithName:name failure:nil];
}

+ (AMLecture *)findDocumentWithName:(NSString *)name failure:(void (^)(NSError *))error
{
    error = error ?: ^(NSError *error) { };
    NSString *docsDir = [FileManager localDocumentsDirectoryPath];
    NSString *filePath = [[docsDir stringByAppendingPathComponent:name] stringByAppendingPathExtension:AMLectutueFileExtention];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        AMLecture *lecture = [[AMLecture alloc] initWithFileURL:[NSURL fileURLWithPath:filePath]];
        return lecture;
    } else {
        NSError *err = [NSError errorWithDomain:NSOSStatusErrorDomain code:FileManagerErrorFileNotFound userInfo:@{ @"Message" : @"File not found" }];
        error(err);
    }
    return FALSE;
}

+ (void)createDocumentWithName:(NSString *)name completion:(void (^)(NSError *error))completion
{
    completion = completion ?: ^(NSError *error) { }; // Allows nil
    NSString *docsDir = [FileManager localDocumentsDirectoryPath];
    NSString *filePath = [[docsDir stringByAppendingPathComponent:name] stringByAppendingPathExtension:AMLectutueFileExtention];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *err = [NSError errorWithDomain:NSOSStatusErrorDomain code:FileManagerErrorFileExists userInfo:@{ @"Message" : @"File exists" }];
        completion(err);
    } else {
        __block AMLecture *newDoc = [[AMLecture alloc] initWithFileURL:[NSURL fileURLWithPath:filePath]];
        [newDoc saveToURL:newDoc.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Created document instance %@", newDoc);
                newDoc = nil;
                completion(nil);
            } else {
                NSError *err = [NSError errorWithDomain:NSOSStatusErrorDomain code:FileManagerErrorSaveError userInfo:@{ @"Message" : @"Failed to save document" }];
                newDoc = nil;
                completion(err);
            }
        }];
    }
}

@end
