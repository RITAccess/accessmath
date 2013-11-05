
//
//  AccessLectureRuntime.m
//  AccessLecture
//
//  Created by Steven Brunwasser on 4/21/12.
//  Modified by Pratik Rasam on 6/26/2013
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//

#import "AccessLectureRuntime.h"
#import "FileManager.h"
#import "Lecture.h"

static NSString * DEFAULT_FILENAME = @"Lecture001"; 

@interface AccessLectureRuntime ()

@end

@implementation AccessLectureRuntime

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

/**
 * Returns the global runtime object containing the current document.
 */
+ (AccessLectureRuntime *)defaultRuntime
{
    static AccessLectureRuntime *defaults;
    if (defaults) return defaults;
    defaults = [[AccessLectureRuntime alloc] init];
    return defaults;
}

/**
 * Opens the AccessDocument with the specified URL. The docuement is then attached to the default runtime.
 * object.
 */
- (void)openDocument:(NSURL *) withURL
{
//    NSURL *currentDirectory = [FileManager iCloudDirectoryURL];
//    if (currentDirectory == nil) {
//        currentDirectory = [FileManager accessMathDirectoryURL];
//    }
//    
//    NSArray *docs = [FileManager documentsIn:currentDirectory];
//    NSURL *document = [FileManager findFileIn:docs thatFits:^(NSURL* url){
//        if (url != nil) {
//            return YES;
//        }
//        return NO;
//    }];
//    
//    if (document == nil) {
//        NSString *filename = [DEFAULT_FILENAME stringByAppendingPathExtension:[AccessDocument fileType]];
//        document = [currentDirectory URLByAppendingPathComponent:filename];
//    }
//    
//    _currentDocument = [[AccessDocument alloc] initWithFileURL:withURL];
//    dispatch_barrier_async(dispatch_get_main_queue(), ^{
//        [_currentDocument openWithCompletionHandler:^(BOOL success){
//            if(success) {
//                [AccessLectureRuntime defaultRuntime].currentDocument = _currentDocument;
//            } else {
//                [_currentDocument saveToURL:withURL forSaveOperation: UIDocumentSaveForCreating completionHandler:^(BOOL success) {
//                    success ? NSLog(@"Created!") : NSLog(@"Not created.");
//                }];
//            }
//        }];
//    });
}

@end
