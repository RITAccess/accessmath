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
        _title = [aCoder decodeObjectForKey:@"title-note"];
        _content = [aCoder decodeObjectForKey:@"content"];
        _location = [aCoder decodeCGPointForKey:@"location"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:(_title ?: @"Untitled") forKey:@"title-note"];
    [aCoder encodeObject:(_content ?: @"") forKey:@"content"];
    [aCoder encodeCGPoint:_location forKey:@"location"];
}

@end
