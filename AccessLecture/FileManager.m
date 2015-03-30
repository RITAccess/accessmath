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

#import "Deferred.h"

@interface FileManager ()

@property (strong, nonatomic) AMLecture *document;

@end

@implementation FileManager
{
    // Completion handler
    void (^lectureLoaded)(AMLecture *);
}


+ (void)findDocumentWithName:(NSString *)name completion:(void(^)(AMLecture *lecture))completion
{
    AMLecture *lec = [self findDocumentWithName:name failure:nil];
    [lec openWithCompletionHandler:^(BOOL success) {
        completion(lec);
    }];
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
    return [[names filteredArrayUsingPredicate:dotLecture] sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(NSString *file1, NSString *file2) {
        NSError *error;
       
        NSString *f1 = [[self localDocumentsDirectoryPath] stringByAppendingPathComponent:file1];
        NSString *f2 = [[self localDocumentsDirectoryPath] stringByAppendingPathComponent:file2];
        
        NSDictionary* p1 = [[NSFileManager defaultManager]
                                    attributesOfItemAtPath:f1
                                    error:&error];
        
        NSDictionary* p2 = [[NSFileManager defaultManager]
                                    attributesOfItemAtPath:f2
                                    error:&error];
        
        NSDate *fileDate1 = [p1 objectForKey:NSFileModificationDate];
        NSDate *fileDate2 = [p2 objectForKey:NSFileModificationDate];
        
        return [fileDate2 compare:fileDate1];
    }];
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
    error = error ?: ^(NSError *e) { };
    NSString *docsDir = [FileManager localDocumentsDirectoryPath];
    NSString *filePath = [docsDir stringByAppendingPathComponent:name];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        AMLecture *lecture = [[AMLecture alloc] initWithFileURL:[NSURL fileURLWithPath:filePath]];
        return lecture;
    } else {
        NSError *err = [NSError errorWithDomain:NSOSStatusErrorDomain code:FileManagerErrorFileNotFound userInfo:@{ @"Message" : @"File not found" }];
        error(err);
    }
    return FALSE;
}

+ (void)createDocumentWithName:(NSString *) name success:(void (^)(AMLecture *current)) success failure:(void (^)(NSError *error)) failure
{
    assert(success);
    
    assert(failure);
    
    NSString *docsDir = [FileManager localDocumentsDirectoryPath];
    NSString *filePath = [[docsDir stringByAppendingPathComponent:name] stringByAppendingPathExtension:AMLectutueFileExtention];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *err = [NSError errorWithDomain:NSOSStatusErrorDomain code:FileManagerErrorFileExists userInfo:@{ @"Message" : @"File exists" }];
        failure(err);
    } else {
        __block AMLecture *newDoc = [[AMLecture alloc] initWithFileURL:[NSURL fileURLWithPath:filePath]];
        newDoc.metadata.title = name;
        newDoc.metadata.dateCreated = [NSDate new];
        dispatch_async(dispatch_get_main_queue(), ^{
            [newDoc saveToURL:newDoc.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL status) {
                if (status) {
                    NSLog(@"Created document instance %@", newDoc);
                    success(newDoc);
                } else {
                    NSError *err = [NSError errorWithDomain:NSOSStatusErrorDomain code:FileManagerErrorSaveError userInfo:@{ @"Message" : @"Failed to save document" }];
                    newDoc = nil;
                    failure(err);
                }
            }];
        });
    }

}

+ (void)createDocumentWithName:(NSString *)name completion:(void (^)(NSError *error, AMLecture *current))completion
{
    completion = completion ?: ^(NSError *error, AMLecture *current) { }; // Allows nil
    NSString *docsDir = [FileManager localDocumentsDirectoryPath];
    NSString *filePath = [[docsDir stringByAppendingPathComponent:name] stringByAppendingPathExtension:AMLectutueFileExtention];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *err = [NSError errorWithDomain:NSOSStatusErrorDomain code:FileManagerErrorFileExists userInfo:@{ @"Message" : @"File exists" }];
        completion(err, nil);
    } else {
        __block AMLecture *newDoc = [[AMLecture alloc] initWithFileURL:[NSURL fileURLWithPath:filePath]];
        newDoc.metadata.title = name;
        newDoc.metadata.dateCreated = [NSDate new];
        dispatch_async(dispatch_get_main_queue(), ^{
            [newDoc saveToURL:newDoc.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"Created document instance %@", newDoc);
                    completion(nil, newDoc);
                } else {
                    NSError *err = [NSError errorWithDomain:NSOSStatusErrorDomain code:FileManagerErrorSaveError userInfo:@{ @"Message" : @"Failed to save document" }];
                    newDoc = nil;
                    completion(err, newDoc);
                }
            }];
        });
    }
}

@end
