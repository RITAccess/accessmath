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
@interface FileManager : NSObject

/**
 * Get the documents directory fo the current user
 * in iOS, this is the only place we are allowed to write files
 */
+ (NSURL *)localDocumentsDirectoryURL;

//Get the AccessMath directory of the current user
+ (NSURL *)accessMathDirectoryURL;

// delete all files in AccessMath directory
+ (void) clearAllDocuments;

/**
* Get the iCloud documents directory
* return nil if none available
*/
+ (NSURL *)iCloudDirectoryURL;

//Get a list of all the files in the specified directory

+ (NSArray *)documentsIn:(NSURL *)URL;

/**
 * Find a file in the given array of files that fits the given block condition.
 * the block should take an NSURL* argument and return a BOOL if the NSURL is correct.
 * returns nil if no file was found
 */
+ (NSURL *)findFileIn:(NSArray *)files thatFits:(BOOL(^)(NSURL*))condition;

/**
 * Creates and returns a UIDocument instance in the users documents directory
 */
+ (AMLecture *)createDocumentWithName:(NSString *)name;

@end
