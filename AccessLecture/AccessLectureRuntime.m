//
//  AccessLectureRuntime.m
//  AccessLecture
//
//  Created by Steven Brunwasser on 4/21/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//

#import "AccessLectureRuntime.h"
#import "AccessDocument.h"
#import "FileManager.h"
#import "Lecture.h"
static NSString * DEFAULT_FILENAME = @"Lecture001"; 

@interface AccessLectureRuntime ()

@end

@implementation AccessLectureRuntime

@synthesize currentDocument = _currentDocument;

- (id)init {
    if (self = [super init]) {
        // do initializing here
    }
    return self;
}

+ (AccessLectureRuntime *)defaultRuntime {
    static AccessLectureRuntime * defaults;
    if (defaults) return defaults;
    defaults = [[AccessLectureRuntime alloc] init];
    return defaults;
}

- (void)openDocument{
    NSURL * currentDirectory = [FileManager iCloudDirectoryURL];
    if (currentDirectory == nil) currentDirectory = [FileManager localDocumentsDirectoryURL];
    NSArray * docs = [FileManager documentsIn:currentDirectory];
    NSLog(@"%d",[docs count]);
    NSURL * document = [FileManager findFileIn:docs thatFits:^(NSURL* url){
        if (url != nil) return YES;
        return NO;
    }];
     
    if (document == nil) {
        NSString * filename = [DEFAULT_FILENAME stringByAppendingPathExtension:[AccessDocument fileType]];
        document = [currentDirectory URLByAppendingPathComponent:filename];
        }
    _currentDocument = [[AccessDocument alloc] initWithFileURL:document];
   
    [_currentDocument openWithCompletionHandler:^(BOOL success){
       if(success)
       {
           NSLog(@"Success");
           [AccessLectureRuntime defaultRuntime].currentDocument = _currentDocument;
          
       }
       else{
           [_currentDocument saveToURL:document
              forSaveOperation: UIDocumentSaveForCreating
             completionHandler:^(BOOL success) {
                 if (success){
                     NSLog(@"Created");
                 } else {
                     NSLog(@"Not created");
                 }
             }];
       }
       
          }];
   
}

@end
