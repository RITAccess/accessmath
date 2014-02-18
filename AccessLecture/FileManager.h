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
#import "AMLecture.h"

#import "Promise.h"

typedef enum {
    FileManagerErrorFileNotFound    = -8901,
    FileManagerErrorFileExists      = -8902,
    FileManagerErrorSaveError       = -8903,
} FileManagerError;

@interface FileManager : NSObject

/**
 * Get this shared and default configured file manager for Access Lecture
 * @return The filemanager
 */
+ (instancetype)defaultManager;

/**
 * Gives you the current document the user wants to be working on. Handles asking
 * user for a document and holds onto it for the lifetime of the document. If a
 * user has already opened a document, it will be returned again. Call finishedWithDocument
 * when you feel the user no longer wants to have that document open.
 * @param completion The completion block called on the main thread when the
 * document is returned to you. This may return instantly if the document was 
 * already opened.
 */
- (void)currentDocumentWithCompletion:(void(^)(AMLecture *lecture))completion;

/**
 * Returns the open active instance of the lecture, if no lecture is open nil is
 * returned. THIS CALL DOES NOT GUARANTEE A DOCUMENT. Use the sycronous call if
 * possible.
 * @return The current document or nil
 */
- (AMLecture *)currentDocument;

/**
 * Forces the save of any currently open documents. This call is not blocking.
 * Documents save automaticly so this methods should rarely be called.
 */
- (void)forceSave;

/**
 * Closes the current document and removes is as active. Used when done editing
 * a document and the user wishes to open a new one.
 */
- (void)finishedWithDocument;

/**
 * TESTING Returns a promise objects to get a lecture
 */
- (Promise *)currentDocumentPromise;

@end
