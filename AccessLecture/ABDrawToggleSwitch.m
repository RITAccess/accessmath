//
//  ABDrawToggleSwitch.m
//  AccessLecture
//
//  Created by Michael on 4/1/14.
//
//

#import "ABDrawToggleSwitch.h"

@implementation ABDrawToggleSwitch

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
    UIColor* color0;
    UIColor* color3;
    UIColor* color5;
    UIColor* color6;
    UIColor* color7;
    UIColor* color8;
    if (self.on) {
        //// Color Declarations
        color0 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
        color3 = [UIColor colorWithRed: 1 green: 1 blue: 0.114 alpha: 1];
        color5 = [UIColor colorWithRed: 0.219 green: 0.657 blue: 0 alpha: 1];
        color6 = [UIColor colorWithRed: 0.886 green: 0 blue: 0 alpha: 1];
        color7 = [UIColor colorWithRed: 0 green: 0.295 blue: 0.886 alpha: 1];
        color8 = [UIColor colorWithRed: 1 green: 0.705 blue: 0.114 alpha: 1];
    } else {
        //// Color Declarations
        color0 = [UIColor grayColor];
        color3 = [UIColor grayColor];
        color5 = [UIColor grayColor];
        color6 = [UIColor grayColor];
        color7 = [UIColor grayColor];
        color8 = [UIColor grayColor];
    }

    //// Group
    {
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPath];
        [rectanglePath moveToPoint: CGPointMake(-2.5, 59.5)];
        [rectanglePath addLineToPoint: CGPointMake(9.5, 59.5)];
        [rectanglePath addLineToPoint: CGPointMake(9.5, 25.5)];
        [rectanglePath addLineToPoint: CGPointMake(3.5, 27.5)];
        [rectanglePath addLineToPoint: CGPointMake(-2.5, 25.5)];
        [rectanglePath addLineToPoint: CGPointMake(-2.5, 59.5)];
        [rectanglePath closePath];
        [color8 setFill];
        [rectanglePath fill];
        [color0 setStroke];
        rectanglePath.lineWidth = 1;
        [rectanglePath stroke];


        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(3, 59.5)];
        [bezierPath addLineToPoint: CGPointMake(3, 27.5)];
        [bezierPath addLineToPoint: CGPointMake(4, 27.5)];
        [bezierPath addLineToPoint: CGPointMake(4, 59.5)];
        [bezierPath addLineToPoint: CGPointMake(3, 59.5)];
        [bezierPath closePath];
        bezierPath.miterLimit = 0;

        [color0 setFill];
        [bezierPath fill];


        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
        [bezier2Path moveToPoint: CGPointMake(-2.97, 25.34)];
        [bezier2Path addLineToPoint: CGPointMake(3.03, 7.34)];
        [bezier2Path addLineToPoint: CGPointMake(3.5, 5.92)];
        [bezier2Path addLineToPoint: CGPointMake(3.97, 7.34)];
        [bezier2Path addLineToPoint: CGPointMake(9.97, 25.34)];
        [bezier2Path addLineToPoint: CGPointMake(9.03, 25.66)];
        [bezier2Path addLineToPoint: CGPointMake(3.03, 7.66)];
        [bezier2Path addLineToPoint: CGPointMake(3.97, 7.66)];
        [bezier2Path addLineToPoint: CGPointMake(-2.03, 25.66)];
        [bezier2Path addLineToPoint: CGPointMake(-2.97, 25.34)];
        [bezier2Path closePath];
        [color0 setFill];
        [bezier2Path fill];


        //// Bezier 3 Drawing
        UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
        [bezier3Path moveToPoint: CGPointMake(-0.28, 18.05)];
        [bezier3Path addLineToPoint: CGPointMake(3.72, 20.05)];
        [bezier3Path addLineToPoint: CGPointMake(3.28, 20.05)];
        [bezier3Path addLineToPoint: CGPointMake(7.28, 18.05)];
        [bezier3Path addLineToPoint: CGPointMake(7.72, 18.95)];
        [bezier3Path addLineToPoint: CGPointMake(3.72, 20.95)];
        [bezier3Path addLineToPoint: CGPointMake(3.5, 21.06)];
        [bezier3Path addLineToPoint: CGPointMake(3.28, 20.95)];
        [bezier3Path addLineToPoint: CGPointMake(-0.72, 18.95)];
        [bezier3Path addLineToPoint: CGPointMake(-0.28, 18.05)];
        [bezier3Path closePath];
        [color0 setFill];
        [bezier3Path fill];
    }


    //// Group 2
    {
        //// Rectangle 2 Drawing
        UIBezierPath* rectangle2Path = [UIBezierPath bezierPath];
        [rectangle2Path moveToPoint: CGPointMake(10.5, 59.5)];
        [rectangle2Path addLineToPoint: CGPointMake(22.5, 59.5)];
        [rectangle2Path addLineToPoint: CGPointMake(22.5, 25.5)];
        [rectangle2Path addLineToPoint: CGPointMake(16.5, 27.5)];
        [rectangle2Path addLineToPoint: CGPointMake(10.5, 25.5)];
        [rectangle2Path addLineToPoint: CGPointMake(10.5, 59.5)];
        [rectangle2Path closePath];
        [color6 setFill];
        [rectangle2Path fill];
        [color0 setStroke];
        rectangle2Path.lineWidth = 1;
        [rectangle2Path stroke];


        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
        [bezier4Path moveToPoint: CGPointMake(16, 59.5)];
        [bezier4Path addLineToPoint: CGPointMake(16, 27.5)];
        [bezier4Path addLineToPoint: CGPointMake(17, 27.5)];
        [bezier4Path addLineToPoint: CGPointMake(17, 59.5)];
        [bezier4Path addLineToPoint: CGPointMake(16, 59.5)];
        [bezier4Path closePath];
        bezier4Path.miterLimit = 0;

        [color0 setFill];
        [bezier4Path fill];


        //// Bezier 5 Drawing
        UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
        [bezier5Path moveToPoint: CGPointMake(10.03, 25.34)];
        [bezier5Path addLineToPoint: CGPointMake(16.03, 7.34)];
        [bezier5Path addLineToPoint: CGPointMake(16.5, 5.92)];
        [bezier5Path addLineToPoint: CGPointMake(16.97, 7.34)];
        [bezier5Path addLineToPoint: CGPointMake(22.97, 25.34)];
        [bezier5Path addLineToPoint: CGPointMake(22.03, 25.66)];
        [bezier5Path addLineToPoint: CGPointMake(16.03, 7.66)];
        [bezier5Path addLineToPoint: CGPointMake(16.97, 7.66)];
        [bezier5Path addLineToPoint: CGPointMake(10.97, 25.66)];
        [bezier5Path addLineToPoint: CGPointMake(10.03, 25.34)];
        [bezier5Path closePath];
        [color0 setFill];
        [bezier5Path fill];


        //// Bezier 6 Drawing
        UIBezierPath* bezier6Path = [UIBezierPath bezierPath];
        [bezier6Path moveToPoint: CGPointMake(12.72, 18.05)];
        [bezier6Path addLineToPoint: CGPointMake(16.72, 20.05)];
        [bezier6Path addLineToPoint: CGPointMake(16.28, 20.05)];
        [bezier6Path addLineToPoint: CGPointMake(20.28, 18.05)];
        [bezier6Path addLineToPoint: CGPointMake(20.72, 18.95)];
        [bezier6Path addLineToPoint: CGPointMake(16.72, 20.95)];
        [bezier6Path addLineToPoint: CGPointMake(16.5, 21.06)];
        [bezier6Path addLineToPoint: CGPointMake(16.28, 20.95)];
        [bezier6Path addLineToPoint: CGPointMake(12.28, 18.95)];
        [bezier6Path addLineToPoint: CGPointMake(12.72, 18.05)];
        [bezier6Path closePath];
        [color0 setFill];
        [bezier6Path fill];
    }


    //// Group 3
    {
        //// Rectangle 3 Drawing
        UIBezierPath* rectangle3Path = [UIBezierPath bezierPath];
        [rectangle3Path moveToPoint: CGPointMake(23.5, 59.5)];
        [rectangle3Path addLineToPoint: CGPointMake(35.5, 59.5)];
        [rectangle3Path addLineToPoint: CGPointMake(35.5, 25.5)];
        [rectangle3Path addLineToPoint: CGPointMake(29.5, 27.5)];
        [rectangle3Path addLineToPoint: CGPointMake(23.5, 25.5)];
        [rectangle3Path addLineToPoint: CGPointMake(23.5, 59.5)];
        [rectangle3Path closePath];
        [color7 setFill];
        [rectangle3Path fill];
        [color0 setStroke];
        rectangle3Path.lineWidth = 1;
        [rectangle3Path stroke];


        //// Bezier 7 Drawing
        UIBezierPath* bezier7Path = [UIBezierPath bezierPath];
        [bezier7Path moveToPoint: CGPointMake(29, 59.5)];
        [bezier7Path addLineToPoint: CGPointMake(29, 27.5)];
        [bezier7Path addLineToPoint: CGPointMake(30, 27.5)];
        [bezier7Path addLineToPoint: CGPointMake(30, 59.5)];
        [bezier7Path addLineToPoint: CGPointMake(29, 59.5)];
        [bezier7Path closePath];
        bezier7Path.miterLimit = 0;

        [color0 setFill];
        [bezier7Path fill];


        //// Bezier 8 Drawing
        UIBezierPath* bezier8Path = [UIBezierPath bezierPath];
        [bezier8Path moveToPoint: CGPointMake(23.03, 25.34)];
        [bezier8Path addLineToPoint: CGPointMake(29.03, 7.34)];
        [bezier8Path addLineToPoint: CGPointMake(29.5, 5.92)];
        [bezier8Path addLineToPoint: CGPointMake(29.97, 7.34)];
        [bezier8Path addLineToPoint: CGPointMake(35.97, 25.34)];
        [bezier8Path addLineToPoint: CGPointMake(35.03, 25.66)];
        [bezier8Path addLineToPoint: CGPointMake(29.03, 7.66)];
        [bezier8Path addLineToPoint: CGPointMake(29.97, 7.66)];
        [bezier8Path addLineToPoint: CGPointMake(23.97, 25.66)];
        [bezier8Path addLineToPoint: CGPointMake(23.03, 25.34)];
        [bezier8Path closePath];
        [color0 setFill];
        [bezier8Path fill];


        //// Bezier 9 Drawing
        UIBezierPath* bezier9Path = [UIBezierPath bezierPath];
        [bezier9Path moveToPoint: CGPointMake(25.72, 18.05)];
        [bezier9Path addLineToPoint: CGPointMake(29.72, 20.05)];
        [bezier9Path addLineToPoint: CGPointMake(29.28, 20.05)];
        [bezier9Path addLineToPoint: CGPointMake(33.28, 18.05)];
        [bezier9Path addLineToPoint: CGPointMake(33.72, 18.95)];
        [bezier9Path addLineToPoint: CGPointMake(29.72, 20.95)];
        [bezier9Path addLineToPoint: CGPointMake(29.5, 21.06)];
        [bezier9Path addLineToPoint: CGPointMake(29.28, 20.95)];
        [bezier9Path addLineToPoint: CGPointMake(25.28, 18.95)];
        [bezier9Path addLineToPoint: CGPointMake(25.72, 18.05)];
        [bezier9Path closePath];
        [color0 setFill];
        [bezier9Path fill];
    }


    //// Group 4
    {
        //// Rectangle 4 Drawing
        UIBezierPath* rectangle4Path = [UIBezierPath bezierPath];
        [rectangle4Path moveToPoint: CGPointMake(36.5, 59.5)];
        [rectangle4Path addLineToPoint: CGPointMake(48.5, 59.5)];
        [rectangle4Path addLineToPoint: CGPointMake(48.5, 25.5)];
        [rectangle4Path addLineToPoint: CGPointMake(42.5, 27.5)];
        [rectangle4Path addLineToPoint: CGPointMake(36.5, 25.5)];
        [rectangle4Path addLineToPoint: CGPointMake(36.5, 59.5)];
        [rectangle4Path closePath];
        [color3 setFill];
        [rectangle4Path fill];
        [color0 setStroke];
        rectangle4Path.lineWidth = 1;
        [rectangle4Path stroke];


        //// Bezier 10 Drawing
        UIBezierPath* bezier10Path = [UIBezierPath bezierPath];
        [bezier10Path moveToPoint: CGPointMake(42, 59.5)];
        [bezier10Path addLineToPoint: CGPointMake(42, 27.5)];
        [bezier10Path addLineToPoint: CGPointMake(43, 27.5)];
        [bezier10Path addLineToPoint: CGPointMake(43, 59.5)];
        [bezier10Path addLineToPoint: CGPointMake(42, 59.5)];
        [bezier10Path closePath];
        bezier10Path.miterLimit = 0;

        [color0 setFill];
        [bezier10Path fill];


        //// Bezier 11 Drawing
        UIBezierPath* bezier11Path = [UIBezierPath bezierPath];
        [bezier11Path moveToPoint: CGPointMake(36.03, 25.34)];
        [bezier11Path addLineToPoint: CGPointMake(42.03, 7.34)];
        [bezier11Path addLineToPoint: CGPointMake(42.5, 5.92)];
        [bezier11Path addLineToPoint: CGPointMake(42.97, 7.34)];
        [bezier11Path addLineToPoint: CGPointMake(48.97, 25.34)];
        [bezier11Path addLineToPoint: CGPointMake(48.03, 25.66)];
        [bezier11Path addLineToPoint: CGPointMake(42.03, 7.66)];
        [bezier11Path addLineToPoint: CGPointMake(42.97, 7.66)];
        [bezier11Path addLineToPoint: CGPointMake(36.97, 25.66)];
        [bezier11Path addLineToPoint: CGPointMake(36.03, 25.34)];
        [bezier11Path closePath];
        [color0 setFill];
        [bezier11Path fill];


        //// Bezier 12 Drawing
        UIBezierPath* bezier12Path = [UIBezierPath bezierPath];
        [bezier12Path moveToPoint: CGPointMake(38.72, 18.05)];
        [bezier12Path addLineToPoint: CGPointMake(42.72, 20.05)];
        [bezier12Path addLineToPoint: CGPointMake(42.28, 20.05)];
        [bezier12Path addLineToPoint: CGPointMake(46.28, 18.05)];
        [bezier12Path addLineToPoint: CGPointMake(46.72, 18.95)];
        [bezier12Path addLineToPoint: CGPointMake(42.72, 20.95)];
        [bezier12Path addLineToPoint: CGPointMake(42.5, 21.06)];
        [bezier12Path addLineToPoint: CGPointMake(42.28, 20.95)];
        [bezier12Path addLineToPoint: CGPointMake(38.28, 18.95)];
        [bezier12Path addLineToPoint: CGPointMake(38.72, 18.05)];
        [bezier12Path closePath];
        [color0 setFill];
        [bezier12Path fill];
    }


    //// Group 5
    {
        //// Rectangle 5 Drawing
        UIBezierPath* rectangle5Path = [UIBezierPath bezierPath];
        [rectangle5Path moveToPoint: CGPointMake(49.5, 59.5)];
        [rectangle5Path addLineToPoint: CGPointMake(61.5, 59.5)];
        [rectangle5Path addLineToPoint: CGPointMake(61.5, 25.5)];
        [rectangle5Path addLineToPoint: CGPointMake(55.5, 27.5)];
        [rectangle5Path addLineToPoint: CGPointMake(49.5, 25.5)];
        [rectangle5Path addLineToPoint: CGPointMake(49.5, 59.5)];
        [rectangle5Path closePath];
        [color5 setFill];
        [rectangle5Path fill];
        [color0 setStroke];
        rectangle5Path.lineWidth = 1;
        [rectangle5Path stroke];


        //// Bezier 13 Drawing
        UIBezierPath* bezier13Path = [UIBezierPath bezierPath];
        [bezier13Path moveToPoint: CGPointMake(55, 59.5)];
        [bezier13Path addLineToPoint: CGPointMake(55, 27.5)];
        [bezier13Path addLineToPoint: CGPointMake(56, 27.5)];
        [bezier13Path addLineToPoint: CGPointMake(56, 59.5)];
        [bezier13Path addLineToPoint: CGPointMake(55, 59.5)];
        [bezier13Path closePath];
        bezier13Path.miterLimit = 0;

        [color0 setFill];
        [bezier13Path fill];


        //// Bezier 14 Drawing
        UIBezierPath* bezier14Path = [UIBezierPath bezierPath];
        [bezier14Path moveToPoint: CGPointMake(49.03, 25.34)];
        [bezier14Path addLineToPoint: CGPointMake(55.03, 7.34)];
        [bezier14Path addLineToPoint: CGPointMake(55.5, 5.92)];
        [bezier14Path addLineToPoint: CGPointMake(55.97, 7.34)];
        [bezier14Path addLineToPoint: CGPointMake(61.97, 25.34)];
        [bezier14Path addLineToPoint: CGPointMake(61.03, 25.66)];
        [bezier14Path addLineToPoint: CGPointMake(55.03, 7.66)];
        [bezier14Path addLineToPoint: CGPointMake(55.97, 7.66)];
        [bezier14Path addLineToPoint: CGPointMake(49.97, 25.66)];
        [bezier14Path addLineToPoint: CGPointMake(49.03, 25.34)];
        [bezier14Path closePath];
        [color0 setFill];
        [bezier14Path fill];
        
        
        //// Bezier 15 Drawing
        UIBezierPath* bezier15Path = [UIBezierPath bezierPath];
        [bezier15Path moveToPoint: CGPointMake(51.72, 18.05)];
        [bezier15Path addLineToPoint: CGPointMake(55.72, 20.05)];
        [bezier15Path addLineToPoint: CGPointMake(55.28, 20.05)];
        [bezier15Path addLineToPoint: CGPointMake(59.28, 18.05)];
        [bezier15Path addLineToPoint: CGPointMake(59.72, 18.95)];
        [bezier15Path addLineToPoint: CGPointMake(55.72, 20.95)];
        [bezier15Path addLineToPoint: CGPointMake(55.5, 21.06)];
        [bezier15Path addLineToPoint: CGPointMake(55.28, 20.95)];
        [bezier15Path addLineToPoint: CGPointMake(51.28, 18.95)];
        [bezier15Path addLineToPoint: CGPointMake(51.72, 18.05)];
        [bezier15Path closePath];
        [color0 setFill];
        [bezier15Path fill];
    }
}


@end
