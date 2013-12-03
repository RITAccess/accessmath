//
//  Note.m
//  AccessLecture
//
//  Created by Steven Brunwasser on 3/19/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//

#import "Note.h"

//
//  static value keys for referencing the title and text properties from a serialized note
//
//  the key allows the serialized note to be stored in parts with key-value pairs
//
static NSString * POSITION_KEY = @"position_key";   // key to code for the position
static NSString * TEXT_KEY = @"text_key";         // key to code for the image

@implementation Note

@synthesize text = _text;

//- (id)initWithText:(UITextView *)textView andPosition:(Position *)position {
//    if (self = [super init]) {
////        _position = position;
//        _text = textView;
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aCoder {
    if (self = [super init]) {
//        _position = [aCoder decodeObjectForKey:POSITION_KEY];
        _text = [aCoder decodeObjectForKey:TEXT_KEY];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:_position forKey:POSITION_KEY];
    [aCoder encodeObject:_text forKey:TEXT_KEY];
}

@end
