//
//  SaveButton.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/26/15.
//
//

#import "SaveButton.h"
#import "AccessLectureKit.h"

@implementation SaveButton

- (void)drawRect:(CGRect)rect
{
    [AccessLectureKit drawSaveButtonWithFrame:rect];
}

@end
