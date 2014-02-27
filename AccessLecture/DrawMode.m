//
//  DrawMode.m
//  AccessLecture
//
//  Created by Michael on 2/13/14.
//
//

#import "DrawMode.h"

@implementation DrawMode

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
    //// Color Declarations
    UIColor* fillColorSelected = [UIColor colorWithRed: 0 green: 0.219 blue: 0.657 alpha: 1];
    UIColor* fillColorNormal = [UIColor colorWithRed: 0.114 green: 0.41 blue: 1 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Oval Drawing
    self.collisionPath = [UIBezierPath bezierPath];
    [self.collisionPath moveToPoint: CGPointMake(23.6, 73.5)];
    [self.collisionPath addCurveToPoint: CGPointMake(41.72, 36.93) controlPoint1: CGPointMake(28.95, 73.51) controlPoint2: CGPointMake(40.07, 40.76)];
    [self.collisionPath addCurveToPoint: CGPointMake(37.25, 6.22) controlPoint1: CGPointMake(45, 29.3) controlPoint2: CGPointMake(45.4, 13.86)];
    [self.collisionPath addCurveToPoint: CGPointMake(7.75, 6.22) controlPoint1: CGPointMake(29.11, -1.41) controlPoint2: CGPointMake(15.89, -1.41)];
    [self.collisionPath addCurveToPoint: CGPointMake(3.28, 36.93) controlPoint1: CGPointMake(-0.4, 13.86) controlPoint2: CGPointMake(0, 29.3)];
    [self.collisionPath addCurveToPoint: CGPointMake(23.6, 73.5) controlPoint1: CGPointMake(4.92, 40.73) controlPoint2: CGPointMake(18.27, 73.49)];
    [self.collisionPath closePath];
    [(self.isSelected ? fillColorSelected : fillColorNormal) setFill];
    [self.collisionPath fill];
    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(23, 11)];
    [bezierPath addCurveToPoint: CGPointMake(9, 22) controlPoint1: CGPointMake(23, 11) controlPoint2: CGPointMake(8.88, 12.09)];
    [bezierPath addCurveToPoint: CGPointMake(23, 34) controlPoint1: CGPointMake(9.12, 31.91) controlPoint2: CGPointMake(23, 34)];
    [bezierPath addCurveToPoint: CGPointMake(35, 22) controlPoint1: CGPointMake(23, 34) controlPoint2: CGPointMake(35.34, 31.77)];
    [bezierPath addCurveToPoint: CGPointMake(23, 11) controlPoint1: CGPointMake(34.66, 12.23) controlPoint2: CGPointMake(23, 11)];
    [bezierPath closePath];
    [fillColorNormal setFill];
    [bezierPath fill];
    [color2 setStroke];
    bezierPath.lineWidth = 4;
    [bezierPath stroke];
    
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(29.11, 8.66)];
    [bezier2Path addLineToPoint: CGPointMake(23.11, 12.66)];
    [bezier2Path addLineToPoint: CGPointMake(23.84, 10.21)];
    [bezier2Path addLineToPoint: CGPointMake(26.84, 17.21)];
    [bezier2Path addLineToPoint: CGPointMake(23.16, 18.79)];
    [bezier2Path addLineToPoint: CGPointMake(20.16, 11.79)];
    [bezier2Path addLineToPoint: CGPointMake(19.51, 10.26)];
    [bezier2Path addLineToPoint: CGPointMake(20.89, 9.34)];
    [bezier2Path addLineToPoint: CGPointMake(26.89, 5.34)];
    [bezier2Path addLineToPoint: CGPointMake(29.11, 8.66)];
    [bezier2Path closePath];
    [color2 setFill];
    [bezier2Path fill];
    
    
    //// Bezier 4 Drawing
    UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
    [bezier4Path moveToPoint: CGPointMake(21.74, 26.01)];
    [bezier4Path addLineToPoint: CGPointMake(25.74, 33.01)];
    [bezier4Path addLineToPoint: CGPointMake(26.56, 34.44)];
    [bezier4Path addLineToPoint: CGPointMake(25.3, 35.52)];
    [bezier4Path addLineToPoint: CGPointMake(18.3, 41.52)];
    [bezier4Path addLineToPoint: CGPointMake(15.7, 38.48)];
    [bezier4Path addLineToPoint: CGPointMake(22.7, 32.48)];
    [bezier4Path addLineToPoint: CGPointMake(22.26, 34.99)];
    [bezier4Path addLineToPoint: CGPointMake(18.26, 27.99)];
    [bezier4Path addLineToPoint: CGPointMake(21.74, 26.01)];
    [bezier4Path closePath];
    [color2 setFill];
    [bezier4Path fill];
    
}


@end
