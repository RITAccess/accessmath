//
//  FileManager.m
//  AccessLecture
//
//  Created by Steven Brunwasser on 3/19/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//
//
//  A class to manage the finding of the documents directory for saving
//  and the opening of the document.
//

#import "FileManager.h"
#import "UILargeAlertView.h"
#import "Lecture.h"
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
+ (void) clearAllDocuments{
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
    NSLog(@"Files succesfully deleted");
}
+(BOOL) saveDocument:(AccessDocument *)document{
    
    AccessDocument *currentDocument;
    Lecture *currentLecture = document.lecture;
    NSURL * currentDirectory = [FileManager iCloudDirectoryURL];
    if (currentDirectory == nil) currentDirectory = [FileManager localDocumentsDirectoryURL];
    NSArray * docs = [FileManager documentsIn:currentDirectory];
    
  
    NSString *docsPath =[[currentDirectory absoluteString] stringByAppendingString:[NSString stringWithFormat:@"/%@.lecture",currentLecture.name]];
    NSURL *docURL = [NSURL URLWithString:docsPath];
    NSURL *temp = [docs objectAtIndex:0];
    
    currentDocument = [[AccessDocument alloc] initWithFileURL:docURL];
  //  currentLecture.image = UIImagePNGRepresentation(saveImage);
    currentDocument.lecture = document.lecture;
    currentDocument.notes = document.notes;
    if([[NSFileManager defaultManager] fileExistsAtPath:[docURL path]])
    {
        [currentDocument saveToURL:docURL
                  forSaveOperation:UIDocumentSaveForOverwriting
                 completionHandler:^(BOOL success) {
                     if (success){
                         UIAlertView* alert = [[UILargeAlertView alloc] initWithText:NSLocalizedString(@"Notes Overwitten!", nil) fontSize:48];
                         [alert show];
                     } else {
                         NSLog(@"Not saved for overwriting");
                     }
                 }];
        
    } else {
        [currentDocument saveToURL:docURL
                  forSaveOperation:UIDocumentSaveForCreating
                 completionHandler:^(BOOL success) {
                     if (success){
                         UIAlertView* alert = [[UILargeAlertView alloc] initWithText:NSLocalizedString(@"New Notes Created!", nil) fontSize:48];
                         [alert show];
                     } else {
                         NSLog(@"Not created");
                     }
                 }];
    }
    return true;
}

@end
