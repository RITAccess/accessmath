//
//  StatusMark.m
//  AccessLecture
//
//  Created by Michael on 1/10/14.
//
//

#import "StatusMark.h"

@implementation StatusMark

- (id)initWithPoint:(CGPoint)point
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, 40, 40)];
    if (self) {
        _isGood = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_isGood) {
        //// Color Declarations
        UIColor* fillColor = [UIColor colorWithRed: 0 green: 0.886 blue: 0 alpha: 1];
        UIColor* fillColor2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];

        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0.5, 0.5, 39, 39)];
        [fillColor setFill];
        [ovalPath fill];
        
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(14.9, 25.88)];
        [bezierPath addCurveToPoint: CGPointMake(5.49, 21.18) controlPoint1: CGPointMake(10.78, 22.94) controlPoint2: CGPointMake(5.49, 21.18)];
        [bezierPath addLineToPoint: CGPointMake(8.63, 18.04)];
        [bezierPath addCurveToPoint: CGPointMake(16.47, 21.96) controlPoint1: CGPointMake(8.63, 18.04) controlPoint2: CGPointMake(13.73, 19.8)];
        [bezierPath addCurveToPoint: CGPointMake(20.39, 25.88) controlPoint1: CGPointMake(19.22, 24.12) controlPoint2: CGPointMake(20.39, 25.88)];
        [bezierPath addCurveToPoint: CGPointMake(23.53, 16.47) controlPoint1: CGPointMake(20.39, 25.88) controlPoint2: CGPointMake(21.57, 20.59)];
        [bezierPath addCurveToPoint: CGPointMake(28.24, 8.63) controlPoint1: CGPointMake(25.49, 12.35) controlPoint2: CGPointMake(28.24, 8.63)];
        [bezierPath addLineToPoint: CGPointMake(32.94, 10.98)];
        [bezierPath addCurveToPoint: CGPointMake(26.67, 21.96) controlPoint1: CGPointMake(32.94, 10.98) controlPoint2: CGPointMake(29.41, 16.47)];
        [bezierPath addCurveToPoint: CGPointMake(21.96, 32.94) controlPoint1: CGPointMake(23.92, 27.45) controlPoint2: CGPointMake(21.96, 32.94)];
        [bezierPath addCurveToPoint: CGPointMake(14.9, 25.88) controlPoint1: CGPointMake(21.96, 32.94) controlPoint2: CGPointMake(19.02, 28.82)];
        [bezierPath closePath];
        [fillColor2 setFill];
        [bezierPath fill];
    } else {
        //// Color Declarations
        UIColor* fillColor2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
        UIColor* color = [UIColor colorWithRed: 0.886 green: 0 blue: 0 alpha: 1];

        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0.5, 0.5, 39, 39)];
        [color setFill];
        [ovalPath fill];

        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(8, 13)];
        [bezierPath addLineToPoint: CGPointMake(16, 20)];
        [bezierPath addLineToPoint: CGPointMake(9, 28)];
        [bezierPath addLineToPoint: CGPointMake(13, 32)];
        [bezierPath addLineToPoint: CGPointMake(20, 24)];
        [bezierPath addCurveToPoint: CGPointMake(28, 31) controlPoint1: CGPointMake(20, 24) controlPoint2: CGPointMake(28.28, 31)];
        [bezierPath addCurveToPoint: CGPointMake(31.5, 26.5) controlPoint1: CGPointMake(27.72, 31) controlPoint2: CGPointMake(31.5, 26.5)];
        [bezierPath addLineToPoint: CGPointMake(24, 20)];
        [bezierPath addLineToPoint: CGPointMake(31, 13)];
        [bezierPath addLineToPoint: CGPointMake(27, 8)];
        [bezierPath addLineToPoint: CGPointMake(20, 16)];
        [bezierPath addLineToPoint: CGPointMake(12, 9)];
        [bezierPath addLineToPoint: CGPointMake(8, 13)];
        [bezierPath closePath];
        [fillColor2 setFill];
        [bezierPath fill];

    }
}

@end
