//
//  TopNav.m
//  AccessLecture
//
//  Created by Michael Timbrook on 6/27/13.
//
//

#import "TopNav.h"

@implementation TopNav

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, 1024, rect.size.height);
    CGContextStrokePath(context);
}


@end
