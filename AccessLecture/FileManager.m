//
//  FileManager.m
//  UIDocumentExample
//
//  Created by Steven Brunwasser on 3/19/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//
//
//  A class to manage the finding of the documents directory for saving
//  and the opening of the document.
//

#import "FileManager.h"

@implementation FileManager

+ (NSURL *)localDocumentsDirectoryURL {
    // only find the location once
    static NSURL * localDocumentsDirectoryURL;
    
    if (localDocumentsDirectoryURL == nil) {
        NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        localDocumentsDirectoryURL = [NSURL fileURLWithPath:documentsDirectoryPath];
    }
    
    return localDocumentsDirectoryURL;
}

+ (NSArray *)localDocuments {
    NSError * error = nil;
    NSURL * localDocs = [self localDocumentsDirectoryURL];
    if (localDocs == nil) {
        NSLog(@"ERROR!");
        return nil;
    } else {
        NSArray * localDocuments = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[self localDocumentsDirectoryURL] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsPackageDescendants error:&error];
        return localDocuments;
    }
}

+ (NSURL *)findFileIn:(NSArray *)files thatFits:(BOOL (^)(NSURL *))condition {
    for (NSURL * file in files) {
        if (condition(file)) {
            return file;
        }
    }
    return nil;
}

@end
