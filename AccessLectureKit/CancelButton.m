//
//  CancelButton.m
//  AccessLecture
//
//  Created by Arun on 2/11/16.
//
//

#import "CancelButton.h"
#import "AccessLectureKit.h"

@implementation CancelButton

- (void)drawRect:(CGRect)rect
{
    [AccessLectureKit drawCancelButtonWithFrame:rect];
}

@end
