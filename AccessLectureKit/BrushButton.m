//
//  BrushButton.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/26/15.
//
//

#import "BrushButton.h"
#import "AccessLectureKit.h"

@implementation BrushButton

- (void)drawRect:(CGRect)rect
{
    [AccessLectureKit drawBrushButtonWithFrame:rect brushColor:[AccessLectureKit brushDefault]];
}

@end
