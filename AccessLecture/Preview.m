//
//  Preview.m
//  AccessLecture
//
//  Created by Michael Timbrook on 2/6/15.
//
//

#import "Preview.h"
#import "AccessLectureKit.h"

@implementation Preview

- (void)drawRect:(CGRect)rect
{
    [AccessLectureKit drawLectureNoInfoWithFrame:rect];
}

@end
