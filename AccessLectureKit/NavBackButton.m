//
//  NavBackButton.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/26/15.
//
//

#import "NavBackButton.h"
#import "AccessLectureKit.h"

@implementation NavBackButton

- (void)drawRect:(CGRect)rect
{
    [AccessLectureKit drawBackButtonWithFrame:rect];
}
@end
