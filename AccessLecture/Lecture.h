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
#import "SocketIOPacket.h"

@interface Lecture : NSObject <NSCoding>

// Access all the notes in the lecture, all objects conform to Note type
@property (readonly, nonatomic, strong) NSArray *notes;

/**
 * Add a note the the lecture
 * param notes - the set of notes to be added
 * returns - BOOL for success status
 */
- (BOOL)addNotes:(NSSet *)notes;

@end
