//
//  ImageNoteView.m
//  AccessLecture
//
//  Created by Michael on 1/15/14.
//
//

#import "ImageNoteView.h"

@implementation ImageNoteView

- (CGRect)sizeForImage
{
    CGRect frame = self.bounds;
    CGRect minFrame = CGRectMake(34, 29, 51, 50);
    if (CGRectGetHeight(frame) <= CGRectGetHeight(minFrame)) {
        frame.size.height = minFrame.size.height;
        [self setBounds:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, minFrame.size.height)];
    }
    if (CGRectGetWidth(frame) <= CGRectGetWidth(minFrame)) {
        frame.size.width = minFrame.size.width;
        [self setBounds:CGRectMake(frame.origin.x, frame.origin.y, minFrame.size.width, frame.size.height)];
    }
    return frame;
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* light = [UIColor colorWithRed: 0.667 green: 0.667 blue: 0.667 alpha: 1];
    UIColor* black = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIColor* grey = [UIColor colorWithRed: 0.5 green: 0.5 blue: 0.5 alpha: 1];
    
    //// Frames
    CGRect frame = [self sizeForImage];
    
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 4, CGRectGetMinY(frame) + 5, CGRectGetWidth(frame) - 9, CGRectGetHeight(frame) - 9)];
    [light setStroke];
    rectanglePath.lineWidth = 0.5;
    [rectanglePath stroke];
    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 7.85, CGRectGetMinY(frame) + 25)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 7.85, CGRectGetMinY(frame) + 8.85)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 24, CGRectGetMinY(frame) + 8.85)];
    [black setStroke];
    bezierPath.lineWidth = 0.5;
    [bezierPath stroke];
    
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 12.95, CGRectGetMinY(frame) + 25)];
    [bezier2Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 12.95, CGRectGetMinY(frame) + 13.95)];
    [bezier2Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 24, CGRectGetMinY(frame) + 13.95)];
    [grey setStroke];
    bezier2Path.lineWidth = 0.5;
    [bezier2Path stroke];
    
    
    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 7.85, CGRectGetMaxY(frame) - 24)];
    [bezier3Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 7.85, CGRectGetMaxY(frame) - 7.85)];
    [bezier3Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 24, CGRectGetMaxY(frame) - 7.85)];
    [black setStroke];
    bezier3Path.lineWidth = 0.5;
    [bezier3Path stroke];
    
    
    //// Bezier 4 Drawing
    UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
    [bezier4Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 12.95, CGRectGetMaxY(frame) - 24)];
    [bezier4Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 12.95, CGRectGetMaxY(frame) - 12.95)];
    [bezier4Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 24, CGRectGetMaxY(frame) - 12.95)];
    [grey setStroke];
    bezier4Path.lineWidth = 0.5;
    [bezier4Path stroke];
    
    
    //// Bezier 5 Drawing
    UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
    [bezier5Path moveToPoint: CGPointMake(CGRectGetMaxX(frame) - 9.85, CGRectGetMinY(frame) + 25)];
    [bezier5Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 9.85, CGRectGetMinY(frame) + 8.85)];
    [bezier5Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 26, CGRectGetMinY(frame) + 8.85)];
    [black setStroke];
    bezier5Path.lineWidth = 0.5;
    [bezier5Path stroke];
    
    
    //// Bezier 6 Drawing
    UIBezierPath* bezier6Path = [UIBezierPath bezierPath];
    [bezier6Path moveToPoint: CGPointMake(CGRectGetMaxX(frame) - 14.95, CGRectGetMinY(frame) + 25)];
    [bezier6Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 14.95, CGRectGetMinY(frame) + 13.95)];
    [bezier6Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 26, CGRectGetMinY(frame) + 13.95)];
    [grey setStroke];
    bezier6Path.lineWidth = 0.5;
    [bezier6Path stroke];
    
    
    //// Bezier 7 Drawing
    UIBezierPath* bezier7Path = [UIBezierPath bezierPath];
    [bezier7Path moveToPoint: CGPointMake(CGRectGetMaxX(frame) - 9.85, CGRectGetMaxY(frame) - 24)];
    [bezier7Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 9.85, CGRectGetMaxY(frame) - 7.85)];
    [bezier7Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 26, CGRectGetMaxY(frame) - 7.85)];
    [black setStroke];
    bezier7Path.lineWidth = 0.5;
    [bezier7Path stroke];
    
    
    //// Bezier 8 Drawing
    UIBezierPath* bezier8Path = [UIBezierPath bezierPath];
    [bezier8Path moveToPoint: CGPointMake(CGRectGetMaxX(frame) - 14.95, CGRectGetMaxY(frame) - 24)];
    [bezier8Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 14.95, CGRectGetMaxY(frame) - 12.95)];
    [bezier8Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 26, CGRectGetMaxY(frame) - 12.95)];
    [grey setStroke];
    bezier8Path.lineWidth = 0.5;
    [bezier8Path stroke];
    
    
}

@end
