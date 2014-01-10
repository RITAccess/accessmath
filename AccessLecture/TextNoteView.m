//
//  TextNoteView.m
//  AccessLecture
//
//  Created by Michael on 1/6/14.
//
//

#import "TextNoteView.h"

@implementation TextNoteView

#pragma mark Creation

- (void)awakeFromNib
{
    _title.delegate = self;
    _text.delegate = self;
}

#pragma mark Actions

- (IBAction)hideView
{
    [_delegate textNoteView:self didHide:YES];
}

- (IBAction)titleActions:(id)sender forEvent:(UIEvent *)event
{
    self.data.title = _title.text;
}

- (IBAction)fullScreeen:(id)sender
{
    [_delegate textNoteView:self presentFullScreen:YES];
}

#pragma mark Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == _text) {
        if ([textView.text isEqualToString:@""]) {
            _placeholder.hidden = NO;
        } else {
            _placeholder.hidden = YES;
        }
    }
    // Update note
    self.data.content = _text.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
    
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:CGRectMake(43.5, 0.5, 356, 198.5)];
    [[UIColor whiteColor] setFill];
    [rectanglePath fill];
    [[UIColor grayColor] setStroke];
    rectanglePath.lineWidth = 1.0;
    [rectanglePath stroke];
    
    UIBezierPath *menu = [UIBezierPath bezierPathWithRect:CGRectMake(-0.5, -0.5, 43.5, 60)];
    CGContextSaveGState(context);
    [menu addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(6.75, -0.5), CGPointMake(6.75, 60), 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
