//
//  Note.h
//  AccessLecture
//
//  Created by Steven Brunwasser on 3/19/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//
//
//  A note object to hold data pertaining to user created notes.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class Position;

@interface Note : NSObject

// the psotion of the note
@property (strong, nonatomic) Position * position;
// the image for the note (notes are drawn)
@property (strong, nonatomic) UITextView * text;

//
//  default init
//
- (id)initWithText:(UITextView *)textView andPosition:(Position *)position;

//
//  init note with a coder to decode a serialized version of the note
//
- (id)initWithCoder:(NSCoder *)aCoder;

//
//  encode the note's persistant properties with a coder to serialize the note
//
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
