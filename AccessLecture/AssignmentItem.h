//
//  AssignmentItem.h
//  LandScapeV2
//
//  Created by Kimberly Sookoo on 6/24/15.
//  Copyright (c) 2015 Kimberly Sookoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssignmentItem : NSObject <NSCoding>

@property NSString *itemName;
@property NSDate *creationDate;
@property NSString *associatedLecture;
@property NSString *notes;
@property BOOL completed;

-(instancetype)initWithName:(NSString*)name Date:(NSDate*)creationDate Lecture:(NSString*)associatedLecture;

+ (void)saveAssignment:(AssignmentItem*)assignment;
+ (NSMutableArray*)loadAssignments;
+ (void)replaceArrayOfAssignmentsWith:(NSMutableArray*)replacement;

@end
