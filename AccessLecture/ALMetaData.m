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
    if (self = [super init]) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_dateCreated forKey:@"dateCreated"];
}

@end
