//
//  NewLectureButton.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/26/15.
//
//

#import "NewLectureButton.h"
#import "AccessLectureKit.h"

@implementation NewLectureButton

- (void)drawRect:(CGRect)rect {
    [AccessLectureKit drawCreateButtonWithFrame:rect];
}

@end
