//
//  FileManager.h
//  AccessLecture
//
//  Created by Steven Brunwasser on 3/19/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//
//
//  A class to manage the finding of the documents directory for saving
//  and the opening of the document.
//

#import <Foundation/Foundation.h>
#import "AccessDocument.h"
@interface FileManager : NSObject

//
//  get the documents directory fo the current user
//  in iOS, this is the only place we are allowed to write files
//
+ (NSURL *)localDocumentsDirectoryURL;

//get the AccessMath directory of the current user
+ (NSURL *)accessMathDirectoryURL;

// delete all files in AccessMath directory
+ (void) clearAllDocuments;

//
// get the iCloud documents directory
// return nil if none available
//
+ (NSURL *)iCloudDirectoryURL;

//
//  get a list of all the files in the specified directory
//
+ (NSArray *)documentsIn:(NSURL *)URL;

//
//  find a file in the given array of files that fits the given block condition
//
//  the block should take an NSURL* argument and return a BOOL if the NSURL is correct
//
//  returns nil if no file was found
//
+ (NSURL *)findFileIn:(NSArray *)files thatFits:(BOOL(^)(NSURL*))condition;
+(BOOL) saveDocument:(AccessDocument *)document;


@end
