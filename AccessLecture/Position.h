//
//  Position.h
//  AccessLecture
//
//  Created by Steven Brunwasser on 4/21/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//
//
//  An object to keep track of the location of a note relative to an XY plane.
//

#import <Foundation/Foundation.h>
#import "CommonLecture.h"

@interface Position : NSObject

// getters and setters for the x and y positions
@property NSNumber * x;
@property NSNumber * y;

//
// create the initial position
//
- (id)init;
- (id)initWithX:(NSNumber *)x andY:(NSNumber *)y;

//
// create the position from serialized data
//
- (id)initWithCoder:(NSCoder *)aCoder;

//
// serialize the position
//
- (void)encodeForCoder:(NSCoder *)aCoder;

@end
