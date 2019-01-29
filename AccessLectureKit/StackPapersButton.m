//
//  StackPapersButton.m
//  AccessLectureKit
//
//  Created by Mohammad Rafique on 6/12/18.
//

#import "StackPapersButton.h"
#import "AccessLectureKit.h"

@implementation StackPapersButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawRect:(CGRect)rect
{
    [AccessLectureKit drawStackPapersButtonWithFrame:rect];
}

@end
