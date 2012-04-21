//
//  Note.m
//  AccessLecture
//
//  Created by Steven Brunwasser on 3/19/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//

#import "Note.h"
#import "Position.h"

//
//  static value keys for referencing the title and text properties from a serialized note
//
//  the key allows the serialized note to be stored in parts with key-value pairs
//
static NSString * POSITION_KEY = @"position_key";   // key to code for the position
static NSString * IMAGE_KEY = @"image_key";         // key to code for the image

@implementation Note

@synthesize position = _position;
@synthesize image = _image;

- (id)init {
    if (self = [super init]) {
        _position = [[Position alloc] init];
        _image = [[UIImage alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    if (self = [super init]) {
        _position = [aCoder decodeObjectForKey:POSITION_KEY];
        _image = [aCoder decodeObjectForKey:IMAGE_KEY];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_position forKey:POSITION_KEY];
    [aCoder encodeObject:_image forKey:IMAGE_KEY];
}

@end
