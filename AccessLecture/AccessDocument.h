//
//  AccessDocument.h
//  AccessLecture
//
//  Created by Steven Brunwasser on 3/19/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//
//
//  UIDocument Subclass
//  Make an instance and dump data into it.
//  Manages saving data based on NSUndoManager (given automatically as the peoperty undoManager).
//  All we need to do is implement the actual saving and loading from a file
//  with loadFromContents:ofType:error: and with contentsForType:error:
//

#import <UIKit/UIKit.h>

@class Note;
@class Lecture;

@interface AccessDocument : UIDocument

//
//  We are going to wrap all of our data saved in the document to this note object
//  (this makes saving and opening the file a little easier on us)
//
@property (strong, nonatomic) NSMutableArray * notes;
@property (strong, nonatomic) Lecture * lecture;

//
//  The file extension of the document.
//  Not necessary for the Document at all, but a convienent location
//  to store this kind of information.
//
+ (NSString *)fileType;

@end
