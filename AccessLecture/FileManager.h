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

@interface FileManager : NSObject

//
//  get the documents directory fo the current user
//  in iOS, this is the only place we are allowed to write files
//
+ (NSURL *)localDocumentsDirectoryURL;

//
// get the iCloud documents directory
// return nil if none available
//
+ (NSURL *)iCloudDirectory;

//
//  get a list of all the files in the specified directory
//
+ (NSArray *)localDocumentsIn:(NSURL *)URL;

//
//  find a file in the given array of files that fits the given block condition
//
//  the block should take an NSURL* argument and return a BOOL if the NSURL is correct
//
+ (NSURL *)findFileIn:(NSArray *)files thatFits:(BOOL(^)(NSURL*))condition;

@end
