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
#import "Lecture.h"

@implementation FileManager

+ (NSString *)localDocumentsDirectoryPath {
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return documentsDirectoryPath;
}

+ (NSURL *)iCloudDirectoryURL {
    NSURL * ubiquity = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    return ubiquity;
}

+ (NSURL *)accessMathDirectoryURL{
    NSFileManager *filemgr;
    NSArray *dirPaths;
    NSString *docsDir;
    NSString *newDir;
    filemgr =[NSFileManager defaultManager];
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
   
    docsDir = [dirPaths objectAtIndex:0];
    newDir = [docsDir stringByAppendingPathComponent:@"AccessMath"];
    if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
    {
        // Failed to create directory
        return nil;
    }
    else{
        return [NSURL URLWithString:newDir];
    }
 }
+ (NSArray *)documentsIn:(NSURL *)URL {
    NSError * error = nil;
    NSURL * docs = URL;
    if (docs == nil) {
        NSLog(@"ERROR!");
        return nil;
    } else {
        NSArray * documents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:docs 
                                                            includingPropertiesForKeys:nil 
                                                                               options:NSDirectoryEnumerationSkipsPackageDescendants 
                                                                                 error:&error];
        return documents;
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
+ (void)clearAllDocuments{
    NSString *path = [[NSMutableString alloc] init];
    NSArray *docs = [FileManager documentsIn:[FileManager localDocumentsDirectoryURL]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for(NSURL *docURL in docs)
    {
        path = [docURL path];
       
        if ([fileManager fileExistsAtPath:path])
        {
            NSError *error;
            if (![fileManager removeItemAtPath:path error:&error])
            {
                NSLog(@"Error removing file: %@", error);
            };
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notes"
                                                    message:@"All lectures removed" delegate:self cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];

}

+ (AMLecture *)createDocumentWithName:(NSString *)name
{
    
    NSString *docsDir = [[FileManager localDocumentsDirectoryPath] stringByAppendingPathComponent:@"AccessMath"];
    
    NSString *filePath = [[docsDir stringByAppendingPathComponent:name] stringByAppendingPathExtension:AMLectutueFileExtention];
    
    AMLecture *newDoc = [[AMLecture alloc] initWithFileURL:[NSURL fileURLWithPath:filePath]];

    [newDoc saveToURL:newDoc.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Created document instance %@", newDoc);
        } else {
            NSLog(@"Failed");
        }
    }];
    
    return newDoc;
}

@end
