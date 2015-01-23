//
//  AMOpenButton.m
//  AccessLecture
//
//  Created by Michael on 2/13/14.
//
//

#import "AMOpenButton.h"

@implementation AMOpenButton

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
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 0.571 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIColor* fillColor2 = [UIColor colorWithRed: 1 green: 1 blue: 0.8 alpha: 1];
    UIColor* color = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* fillColor4 = [UIColor colorWithRed: 0 green: .25 blue: 1 alpha: 1];
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.5, 5.5, 71, 69) cornerRadius: 4];
    [fillColor setFill];
    [roundedRectanglePath fill];
    [strokeColor setStroke];
    roundedRectanglePath.lineWidth = 2;
    [roundedRectanglePath stroke];
    
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(2.5, 60.5, 66, 8)];
    [fillColor2 setFill];
    [rectanglePath fill];
    [color setStroke];
    rectanglePath.lineWidth = 2;
    [rectanglePath stroke];
    
    
    //// Rectangle 2 Drawing
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(2.5, 45.5, 66, 8)];
    [fillColor2 setFill];
    [rectangle2Path fill];
    [color setStroke];
    rectangle2Path.lineWidth = 2;
    [rectangle2Path stroke];
    
    
    //// Rectangle 3 Drawing
    UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(2.5, 30.5, 66, 8)];
    [fillColor2 setFill];
    [rectangle3Path fill];
    [color setStroke];
    rectangle3Path.lineWidth = 2;
    [rectangle3Path stroke];
    
    
    //// Rectangle 4 Drawing
    UIBezierPath* rectangle4Path = [UIBezierPath bezierPathWithRect: CGRectMake(2.5, 15.5, 66, 8)];
    [fillColor2 setFill];
    [rectangle4Path fill];
    [color setStroke];
    rectangle4Path.lineWidth = 2;
    [rectangle4Path stroke];
    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(45.17, 47.5)];
    [bezierPath addLineToPoint: CGPointMake(64.5, 47.5)];
    [bezierPath addLineToPoint: CGPointMake(64.5, 20.5)];
    [bezierPath addLineToPoint: CGPointMake(74.5, 20.08)];
    [bezierPath addLineToPoint: CGPointMake(54.5, 0.5)];
    [bezierPath addLineToPoint: CGPointMake(34.5, 20.08)];
    [bezierPath addLineToPoint: CGPointMake(45.17, 20.08)];
    [bezierPath addLineToPoint: CGPointMake(45.17, 47.5)];
    [bezierPath closePath];
    [fillColor4 setFill];
    [bezierPath fill];
    [strokeColor setStroke];
    bezierPath.lineWidth = 2;
    [bezierPath stroke];
}


@end
