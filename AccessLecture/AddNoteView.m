//
//  AddNoteView.m
//  AccessLecture
//
//  Created by Michael on 1/13/14.
//
//

#import "AddNoteView.h"

@implementation AddNoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* fillColor2 = [UIColor colorWithRed: 0 green: 0.59 blue: 0.886 alpha: 1];
    UIColor* fillColor3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Abstracted Attributes
    NSString* symbolContent = @"+";
    
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint: CGPointMake(23.6, 74.5)];
    [ovalPath addCurveToPoint: CGPointMake(41.72, 35.93) controlPoint1: CGPointMake(28.95, 74.51) controlPoint2: CGPointMake(38.96, 39.76)];
    [ovalPath addCurveToPoint: CGPointMake(37.25, 8.22) controlPoint1: CGPointMake(47.21, 28.3) controlPoint2: CGPointMake(45.4, 15.86)];
    [ovalPath addCurveToPoint: CGPointMake(7.75, 8.22) controlPoint1: CGPointMake(29.11, 0.59) controlPoint2: CGPointMake(15.89, 0.59)];
    [ovalPath addCurveToPoint: CGPointMake(3.28, 35.93) controlPoint1: CGPointMake(-0.4, 15.86) controlPoint2: CGPointMake(-2.21, 28.3)];
    [ovalPath addCurveToPoint: CGPointMake(23.6, 74.5) controlPoint1: CGPointMake(6.02, 39.73) controlPoint2: CGPointMake(18.27, 74.49)];
    [ovalPath closePath];
    [fillColor2 setFill];
    [ovalPath fill];
    
    
    //// Symbol Drawing
    CGRect symbolRect = CGRectMake(11, 0, 25, 52);
    [fillColor3 setFill];
    [symbolContent drawInRect: symbolRect withFont: [UIFont fontWithName: @"Helvetica" size: 36] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
}

@end
