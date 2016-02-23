//
//  Note.m
//  AccessLecture
//
//  Created by Steven Brunwasser on 3/19/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//

#import "Note.h"

@implementation Note

- (id)initWithCoder:(NSCoder *)aCoder
{
    if (self = [super init]) {
        _color = [aCoder decodeObjectForKey:@"color"];
        _type = [aCoder decodeObjectForKey:@"type-note"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:(_color ?: @"") forKey:@"color"];
    [aCoder encodeObject:(_type ?: @"Default") forKey:@"type-note"];
}

@end
