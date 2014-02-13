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
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIColor* fillColorSelected = [UIColor colorWithRed: 0 green: 0.219 blue: 0.657 alpha: 1];
    UIColor* fillColorNormal = [UIColor colorWithRed: 0.114 green: 0.41 blue: 1 alpha: 1];
    UIColor* fillColor3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* color = [UIColor colorWithRed: 1 green: 0.571 blue: 0.571 alpha: 1];
    
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
    [bezierPath moveToPoint: CGPointMake(18, 8)];
    [bezierPath addLineToPoint: CGPointMake(11, 21)];
    [bezierPath addLineToPoint: CGPointMake(12, 23)];
    [bezierPath addLineToPoint: CGPointMake(19, 26)];
    [bezierPath addLineToPoint: CGPointMake(20.95, 28.18)];
    [bezierPath addLineToPoint: CGPointMake(22, 30)];
    [bezierPath addLineToPoint: CGPointMake(25, 39)];
    [bezierPath addLineToPoint: CGPointMake(24, 39)];
    [bezierPath addLineToPoint: CGPointMake(19, 30)];
    [bezierPath addLineToPoint: CGPointMake(18, 28)];
    [bezierPath addLineToPoint: CGPointMake(10, 24)];
    [bezierPath addLineToPoint: CGPointMake(8.88, 22.73)];
    [bezierPath addLineToPoint: CGPointMake(8, 18)];
    [bezierPath addLineToPoint: CGPointMake(13.03, 11.33)];
    [bezierPath addLineToPoint: CGPointMake(18, 8)];
    [bezierPath closePath];
    [fillColor3 setFill];
    [bezierPath fill];
    
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(36, 15)];
    [bezier2Path addLineToPoint: CGPointMake(39, 17)];
    [bezier2Path addLineToPoint: CGPointMake(29.8, 35.67)];
    [bezier2Path addLineToPoint: CGPointMake(29, 33)];
    [bezier2Path addLineToPoint: CGPointMake(26.2, 34.58)];
    [bezier2Path addLineToPoint: CGPointMake(36, 15)];
    [bezier2Path closePath];
    [color setFill];
    [bezier2Path fill];
    
    
    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(26, 39)];
    [bezier3Path addLineToPoint: CGPointMake(26, 39)];
    [bezier3Path closePath];
    [color setFill];
    [bezier3Path fill];
    
    
    //// Bezier 4 Drawing
    UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
    [bezier4Path moveToPoint: CGPointMake(25, 39)];
    [bezier4Path addLineToPoint: CGPointMake(27, 34)];
    [bezier4Path addLineToPoint: CGPointMake(29, 33)];
    [bezier4Path addLineToPoint: CGPointMake(30, 35)];
    [bezier4Path addLineToPoint: CGPointMake(25, 39)];
    [strokeColor setFill];
    [bezier4Path fill];
    
}


@end
