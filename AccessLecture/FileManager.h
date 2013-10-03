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
#import "AccessDocument.h"
#import "AMLecture.h"

typedef enum {
    FileManagerErrorFileNotFound    = -8901,
    FileManagerErrorFileExists      = -8902,
    FileManagerErrorSaveError       = -8903,
} FileManagerError;

@interface FileManager : NSObject

/**
 * Get the documents directory fo the current user
 * in iOS, this is the only place we are allowed to write files
 */
+ (NSString *)localDocumentsDirectoryPath;

/**
 * Opens a AMLecture with that name from the douments directory
 */
+ (AMLecture *)findDocumentWithName:(NSString *)name;
+ (AMLecture *)findDocumentWithName:(NSString *)name failure:(void (^)(NSError *error))error;

/**
 * Creates and returns a UIDocument instance in the users documents directory
 */
+ (AMLecture *)createDocumentWithName:(NSString *)name;
+ (AMLecture *)createDocumentWithName:(NSString *)name failure:(void (^)(NSError *error))error;

@end
