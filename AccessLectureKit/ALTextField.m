//
//  ALTextField.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/28/15.
//
//

#import "ALTextField.h"
#import "AccessLectureKit.h"

@implementation ALTextField

- (void)drawRect:(CGRect)rect
{
    [AccessLectureKit drawTextInputWithFrame:rect];
}

@end
