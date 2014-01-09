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

#import "FileManager.h"
#import "AMLecture.h"
#import "Lecture.h"

@implementation FileManager

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
    completion(nil);
}

- (AMLecture *)currentDocument
{
    return nil;
}

- (void)forceSave
{
    
}

- (void)finishedWithDocument
{
    
}

- (void)invalidateCurrentDocument
{
    
}


#pragma mark Document Internal

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
    return [self findDocumentWithName:name failure:^(NSError *error) { }];
}

+ (AMLecture *)findDocumentWithName:(NSString *)name failure:(void (^)(NSError *))error
{
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

+ (AMLecture *)createDocumentWithName:(NSString *)name
{
    return [FileManager createDocumentWithName:name failure:^(NSError *error) { }];
}

+ (AMLecture *)createDocumentWithName:(NSString *)name failure:(void (^)(NSError *error))error
{
    NSString *docsDir = [FileManager localDocumentsDirectoryPath];
    NSString *filePath = [[docsDir stringByAppendingPathComponent:name] stringByAppendingPathExtension:AMLectutueFileExtention];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *err = [NSError errorWithDomain:NSOSStatusErrorDomain code:FileManagerErrorFileExists userInfo:@{ @"Message" : @"File exists" }];
        error(err);
    } else {
        
        AMLecture *newDoc = [[AMLecture alloc] initWithFileURL:[NSURL fileURLWithPath:filePath]];

        [newDoc saveToURL:newDoc.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Created document instance %@", newDoc);
            } else {
                NSError *err = [NSError errorWithDomain:NSOSStatusErrorDomain code:FileManagerErrorSaveError userInfo:@{ @"Message" : @"Failed to save document" }];
                error(err);
            }
        }];
        return newDoc;
    }
    return FALSE;
}

@end
