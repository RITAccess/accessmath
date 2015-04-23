//
//  FileManager.h
//  AccessLecture
//
//  Created by Steven Brunwasser on 3/19/12.
//  Modified by Pratik Rasam on 6/26/2013
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//
//
//  A class to manage the finding of the documents directory for saving
//  and the opening of the document.
//

#import <Foundation/Foundation.h>
#include <AvailabilityMacros.h>
#import "AMLecture.h"

#import "Promise.h"

typedef enum {
    FileManagerErrorFileNotFound    = -8901,
    FileManagerErrorFileExists      = -8902,
    FileManagerErrorSaveError       = -8903,
} FileManagerError;

@interface FileManager : NSObject

+ (void)findDocumentWithName:(NSString *)name completion:(void(^)(AMLecture *lecture))completion __deprecated;

+ (AMLecture *)findDocumentWithName:(NSString *)name;
+ (AMLecture *)findDocumentWithName:(NSString *)name failure:(void (^)(NSError *))error __deprecated;

+ (void)createDocumentWithName:(NSString *) name success:(void (^)(AMLecture *current)) success failure:(void (^)(NSError *error)) failure;
+ (void)createDocumentWithName:(NSString *)name completion:(void (^)(NSError *error, AMLecture *current))completion;

+ (NSArray *)listContentsOfDirectory:(NSString *)path __deprecated;
+ (NSString *)localDocumentsDirectoryPath __deprecated;
+ (NSURL *)iCloudDirectoryURL __deprecated;

@end
