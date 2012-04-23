//
//  AccessLectureRuntime.m
//  AccessLecture
//
//  Created by Student on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccessLectureRuntime.h"

@interface AccessLectureRuntime ()

- (id)init;

@end

@implementation AccessLectureRuntime

- (id)init {
    return [super init];
}

+ (AccessLectureRuntime *)defaultRuntime {
    static AccessLectureRuntime * defaults;
    if (defaults) return defaults;
    defaults = [[AccessLectureRuntime alloc] init];
    return defaults;
}

@end
