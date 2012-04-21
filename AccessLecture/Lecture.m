//
//  Lecture.m
//  AccessLecture
//
//  Created by Steven Brunwasser on 4/21/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//

#import "Lecture.h"

//
//  static value keys for referencing the title and text properties from a serialized note
//
//  the key allows the serialized note to be stored in parts with key-value pairs
//
static NSString * NAME_KEY = @"NAME";       // key for the class name
static NSString * IMAGE_KEY = @"IMAGE";     // key for the lecture image

@implementation Lecture

@synthesize name = _name;
@synthesize image = _image;

- (id)init {
    if (self = [super init]) {
        self = [self initWithName:@"Generic Lecture"];
    }
    return self;
}
- (id)initWithName:(NSString *)name {
    if (self = [super init]) {
        _name = name;
        _image = [[UIImage alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    if (self = [super init]) {
        _name = [aCoder decodeObjectForKey:NAME_KEY];
        _image = [aCoder decodeObjectForKey:IMAGE_KEY];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:NAME_KEY];
    [aCoder encodeObject:_image forKey:IMAGE_KEY];
}

@end
