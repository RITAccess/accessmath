//
//  ContinueButton.m
//  AccessLecture
//
//  Created by Michael Timbrook on 2/9/15.
//
//

#import "ContinueButton.h"
#import "AccessLectureKit.h"

@implementation ContinueButton

- (void)drawRect:(CGRect)rect
{
    [AccessLectureKit drawContButtonWithFrame:rect];
}

@end
