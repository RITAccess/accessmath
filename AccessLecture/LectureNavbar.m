//
//  LectureNavbar.m
//  AccessLecture
//
//  Created by Michael on 2/13/14.
//
//

#import <Colours/Colours.h>

#import "LectureNavbar.h"
#import "AMOpenButton.h"

@implementation LectureNavbar

- (void)layoutSubviews
{
    [super layer];
    // Set hight
    self.frame = ({
        CGRect frame = self.frame;
        frame.size.height = 100.0;
        frame;
    });
    // Set color
    self.backgroundColor = [UIColor paleGreenColor];
}

- (void)didMoveToSuperview
{
    _openButton = ({
        AMOpenButton *open = [AMOpenButton buttonWithType:UIButtonTypeCustom];
        open.frame = CGRectMake(20, 20, 75, 75);
        [self addSubview:open];
        open;
    });
}

@end
