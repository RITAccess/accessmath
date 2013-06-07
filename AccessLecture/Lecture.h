//
//  Lecture.h
//  AccessLecture
//
//  Created by Steven Brunwasser on 4/21/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//
//
//  An object to hold lecture data for a document.
//
//

#import <Foundation/Foundation.h>
#import "SocketIOPacket.h"

@interface Lecture : NSObject

// the name of the lecture/class
@property (strong, nonatomic) NSString * name;
// the date of the lecture (when the user created the lecture)
@property (strong, nonatomic) NSDate * date;
// the image of the bard from the lecture
@property (strong, nonatomic) NSData * image;

//
// create a lecture
//
- (id)init;
- (id)initWithName:(NSString *)name;
- (id)initWithPacket:(SocketIOPacket *)packet;

//
// create the lecture from serialized data
//
- (id)initWithCoder:(NSCoder *)aCoder;

//
// serialize the lecture
//
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
