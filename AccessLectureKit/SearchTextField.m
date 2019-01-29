//
//  SearchTextField.m
//  AccessLectureKit
//
//  Created by Mohammad Rafique on 4/4/18.
//

#import "SearchTextField.h"
#import "AccessLectureKit.h"

@implementation SearchTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    [AccessLectureKit drawTextInputWithFrame:rect];
}

@end
