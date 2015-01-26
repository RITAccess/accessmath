//
//  SearchButton.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/26/15.
//
//

#import "SearchButton.h"
#import "AccessLectureKit.h"

@implementation SearchButton

- (void)drawRect:(CGRect)rect {
    [AccessLectureKit drawSearchButtonWithFrame:rect];
}

@end
