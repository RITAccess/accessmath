//
//  TextNoteView.m
//  AccessLecture
//
//  Created by Michael on 1/6/14.
//
//

#import "TextNoteView.h"

@implementation TextNoteView

- (IBAction)hideView
{
    [_delegate textNoteView:self didHide:YES];
}

- (IBAction)titleActions:(id)sender forEvent:(UIEvent *)event
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _title.delegate = self;
    });
}

#pragma mark Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%@", _text);
    if (textField == _title) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark Drawing

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
