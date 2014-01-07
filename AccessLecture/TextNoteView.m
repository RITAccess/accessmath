//
//  TextNoteView.m
//  AccessLecture
//
//  Created by Michael on 1/6/14.
//
//

#import "TextNoteView.h"

@implementation TextNoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
    }
    return self;
}

- (IBAction)hideView
{
    
}

- (void)drawRect:(CGRect)rect
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSArray *gradientColors = @[ (__bridge id)[UIColor colorWithRed:0.0 green:0.0 blue:0.2 alpha:1.0].CGColor,
                                 (__bridge id)[UIColor colorWithRed:0.5 green:0.5 blue:0.6 alpha:1.0].CGColor,
                                 (__bridge id)[UIColor whiteColor].CGColor
                                ];
    CGFloat loc[] = {0.0, 0.89, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, loc);
    
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:CGRectMake(14.5, 0.5, 385, 198.5)];
    [[UIColor whiteColor] setFill];
    [rectanglePath fill];
    [[UIColor blackColor] setStroke];
    rectanglePath.lineWidth = 1.0;
    [rectanglePath stroke];
    
    UIBezierPath *menu = [UIBezierPath bezierPathWithRect:CGRectMake(-0.5, -0.5, 14.5, 59)];
    CGContextSaveGState(context);
    [menu addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(6.75, -0.5), CGPointMake(6.75, 58.5), 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
