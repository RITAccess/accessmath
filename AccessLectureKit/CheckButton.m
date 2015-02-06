//
//  CheckButton.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/26/15.
//
//

#import "CheckButton.h"
#import "AccessLectureKit.h"

@implementation CheckButton

- (void)drawRect:(CGRect)rect
{
    [AccessLectureKit drawCheckButtonWithFrame:rect];
}

@end
