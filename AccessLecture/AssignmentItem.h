//
//  AssignmentItem.h
//  LandScapeV2
//
//  Created by Student on 6/24/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssignmentItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property (readonly) NSDate *creationDate;

@end
