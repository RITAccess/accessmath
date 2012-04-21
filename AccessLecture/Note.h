//
//  Note.h
//  AccessLecture
//
//  Created by Steven Brunwasser on 3/19/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//
//
//  A note object to hold data for a document.
//
//

#import <Foundation/Foundation.h>

@class Position;

@interface Note : NSObject

@property (strong, nonatomic) Position * position;
@property (strong, nonatomic) UIImage * image;
//@property (strong, nonatomic) NSString * text;

//
//  default init
//
- (id)init;

//
//  init note with a coder to decode a serialized version of the note
//
- (id)initWithCoder:(NSCoder *)aCoder;

//
//  encode the note's persistant properties with a coder to serialize the note
//
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
