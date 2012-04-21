//
//  Position.h
//  AccessLecture
//
//  Created by Student on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Position : NSObject

@property NSNumber * x;
@property NSNumber * y;

- (id)init;
- (id)initWithX:(NSNumber *)x andY:(NSNumber *)y;

- (id)initWithCoder:(NSCoder *)aCoder;

- (void)encodeForCoder:(NSCoder *)aCoder;

@end
