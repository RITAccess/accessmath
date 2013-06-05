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
static NSString * NAME_KEY = @"NAME_KEY";       // key for the class name
static NSString * DATE_KEY = @"DATE_KEY";       // key for the lecture time
static NSString * IMAGE_KEY = @"IMAGE_KEY";     // key for the lecture image

@implementation Lecture

@synthesize name = _name;
@synthesize date = _date;
@synthesize image = _image;

- (id)init {
    return [self initWithName:@"Generic Lecture"];
}
- (id)initWithName:(NSString *)name {
    if (self = [super init]) {
        _name = name;
        _date = [NSDate date];
        _image = [[UIImage alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    if (self = [super init]) {
        _name = [aCoder decodeObjectForKey:NAME_KEY];
        _date = [aCoder decodeObjectForKey:DATE_KEY];
        _image = [aCoder decodeObjectForKey:IMAGE_KEY];
    }
    return self;
}

- (id)initWithPacket:(SocketIOPacket *)packet {
    self = [super init];
    if (self) {
        
        id JSON = [packet.dataAsJSON valueForKeyPath:@"args"];
        _name = [JSON valueForKeyPath:@"name"][0];
        _date = [NSDate dateWithTimeIntervalSince1970:[[JSON valueForKeyPath:@"date"][0] integerValue]];
        _image= nil;
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:NAME_KEY];
    [aCoder encodeObject:_date forKey:DATE_KEY];
    [aCoder encodeObject:_image forKey:IMAGE_KEY];
}

/**
 * Description of lecture
 */
- (NSString *)description {
    return [NSString stringWithFormat:@"%@ : %@", _name, _date];;
}

@end
