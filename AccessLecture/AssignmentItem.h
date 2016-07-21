//
//  AssignmentItem.h
//  LandScapeV2
//
//  Created by Kimberly Sookoo on 6/24/15.
//  Copyright (c) 2015 Kimberly Sookoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssignmentItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property NSDate *creationDate;
@property BOOL warningEnabled;

@end
