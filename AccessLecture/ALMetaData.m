//
//  ALMetaData.m
//  AccessLecture
//
//  Created by Michael Timbrook on 11/5/13.
//
//

#import "ALMetaData.h"

@implementation ALMetaData


#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    _title = [aDecoder decodeObjectForKey:@"title"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_title forKey:@"title"];
}

@end
