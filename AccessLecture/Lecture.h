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

@interface Lecture : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) UIImage * image;

- (id)init;
- (id)initWithName:(NSString *)name;

- (id)initWithCoder:(NSCoder *)aCoder;

- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
