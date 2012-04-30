//
//  Position.m
//  AccessLecture
//
//  Created by Steven Brunwasser on 4/21/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//

#import "Position.h"

static NSString * X_KEY = @"X";
static NSString * Y_KEY = @"Y";

@implementation Position

@synthesize x = _x;
@synthesize y = _y;

- (id)init {
    if (self = [super init]) {
        _x = [[NSNumber alloc] initWithInt:0];
        _y = [[NSNumber alloc] initWithInt:0];
    }
    return self;
}
- (id)initWithX:(NSNumber *)x andY:(NSNumber *)y {
    if (self = [super init]) {
        _x = x;
        _y = y;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    if (self = [super init]) {
        _x = [aCoder decodeObjectForKey:X_KEY];
        _y = [aCoder decodeObjectForKey:Y_KEY];
    }
    return self;
}

- (void)encodeForCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_x forKey:X_KEY];
    [aCoder encodeObject:_y forKey:Y_KEY];
}

@end
