//
//  ImageNoteView.m
//  AccessLecture
//
//  Created by Michael on 1/15/14.
//
//

#import "ImageNoteView.h"

@implementation ImageNoteView

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* light = [UIColor colorWithRed: 0.667 green: 0.667 blue: 0.667 alpha: 1];
    UIColor* black = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIColor* grey = [UIColor colorWithRed: 0.5 green: 0.5 blue: 0.5 alpha: 1];
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(14, 14, 172, 172)];
    [light setStroke];
    rectanglePath.lineWidth = 0.5;
    [rectanglePath stroke];
    
    
    //// Group
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(3.85, 20)];
        [bezierPath addLineToPoint: CGPointMake(3.85, 3.85)];
        [bezierPath addLineToPoint: CGPointMake(20, 3.85)];
        [black setStroke];
        bezierPath.lineWidth = 0.5;
        [bezierPath stroke];
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
        [bezier2Path moveToPoint: CGPointMake(8.95, 20)];
        [bezier2Path addLineToPoint: CGPointMake(8.95, 8.95)];
        [bezier2Path addLineToPoint: CGPointMake(20, 8.95)];
        [grey setStroke];
        bezier2Path.lineWidth = 0.5;
        [bezier2Path stroke];
    }
    
    
    //// Group 2
    {
        //// Bezier 3 Drawing
        UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
        [bezier3Path moveToPoint: CGPointMake(3.85, 180)];
        [bezier3Path addLineToPoint: CGPointMake(3.85, 196.15)];
        [bezier3Path addLineToPoint: CGPointMake(20, 196.15)];
        [black setStroke];
        bezier3Path.lineWidth = 0.5;
        [bezier3Path stroke];
        
        
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
        [bezier4Path moveToPoint: CGPointMake(8.95, 180)];
        [bezier4Path addLineToPoint: CGPointMake(8.95, 191.05)];
        [bezier4Path addLineToPoint: CGPointMake(20, 191.05)];
        [grey setStroke];
        bezier4Path.lineWidth = 0.5;
        [bezier4Path stroke];
    }
    
    
    //// Group 3
    {
        //// Bezier 5 Drawing
        UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
        [bezier5Path moveToPoint: CGPointMake(196.15, 20)];
        [bezier5Path addLineToPoint: CGPointMake(196.15, 3.85)];
        [bezier5Path addLineToPoint: CGPointMake(180, 3.85)];
        [black setStroke];
        bezier5Path.lineWidth = 0.5;
        [bezier5Path stroke];
        
        
        //// Bezier 6 Drawing
        UIBezierPath* bezier6Path = [UIBezierPath bezierPath];
        [bezier6Path moveToPoint: CGPointMake(191.05, 20)];
        [bezier6Path addLineToPoint: CGPointMake(191.05, 8.95)];
        [bezier6Path addLineToPoint: CGPointMake(180, 8.95)];
        [grey setStroke];
        bezier6Path.lineWidth = 0.5;
        [bezier6Path stroke];
    }

    
    //// Group 4
    {
        //// Bezier 7 Drawing
        UIBezierPath* bezier7Path = [UIBezierPath bezierPath];
        [bezier7Path moveToPoint: CGPointMake(196.15, 180)];
        [bezier7Path addLineToPoint: CGPointMake(196.15, 196.15)];
        [bezier7Path addLineToPoint: CGPointMake(180, 196.15)];
        [black setStroke];
        bezier7Path.lineWidth = 0.5;
        [bezier7Path stroke];
        
        
        //// Bezier 8 Drawing
        UIBezierPath* bezier8Path = [UIBezierPath bezierPath];
        [bezier8Path moveToPoint: CGPointMake(191.05, 180)];
        [bezier8Path addLineToPoint: CGPointMake(191.05, 191.05)];
        [bezier8Path addLineToPoint: CGPointMake(180, 191.05)];
        [grey setStroke];
        bezier8Path.lineWidth = 0.5;
        [bezier8Path stroke];
    }
}

@end
