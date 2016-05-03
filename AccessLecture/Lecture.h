//
//  Lecture.h
//  AccessLecture
//
//  Created by Steven Brunwasser on 4/21/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//
//
//  An object to hold lecture data for a document.
//
//

#import <Foundation/Foundation.h>

@interface Lecture : NSObject <NSCoding>

// Parent Document
@property (weak) id parent;

// Access all the notes in the lecture, all objects conform to Note type
@property (readonly, nonatomic, strong) NSArray *notes __deprecated_msg("Moving to AMLecture");

/**
 * Add a note the the lecture
 * param notes - the set of notes to be added
 * returns - BOOL for success status
 */
- (BOOL)addNotes:(NSSet *)notes __deprecated_msg("Moving to AMLecture");

@end
