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
        _isSelected = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* fillColorNormal = [UIColor colorWithRed: 0 green: 0.59 blue: 0.886 alpha: 1];
    UIColor* fillColorSelected = [UIColor colorWithRed: 0 green: 0.286 blue: 0.429 alpha: 1];
    UIColor* fillColor3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Abstracted Attributes
    NSString* symbolContent = @"+";
    
    
    //// Oval Drawing
    _collisionPath = [UIBezierPath bezierPath];
    [_collisionPath moveToPoint: CGPointMake(23.6, 73.5)];
    [_collisionPath addCurveToPoint: CGPointMake(41.72, 36.93) controlPoint1: CGPointMake(28.95, 73.51) controlPoint2: CGPointMake(40.07, 40.76)];
    [_collisionPath addCurveToPoint: CGPointMake(37.25, 6.22) controlPoint1: CGPointMake(45, 29.3) controlPoint2: CGPointMake(45.4, 13.86)];
    [_collisionPath addCurveToPoint: CGPointMake(7.75, 6.22) controlPoint1: CGPointMake(29.11, -1.41) controlPoint2: CGPointMake(15.89, -1.41)];
    [_collisionPath addCurveToPoint: CGPointMake(3.28, 36.93) controlPoint1: CGPointMake(-0.4, 13.86) controlPoint2: CGPointMake(0, 29.3)];
    [_collisionPath addCurveToPoint: CGPointMake(23.6, 73.5) controlPoint1: CGPointMake(4.92, 40.73) controlPoint2: CGPointMake(18.27, 73.49)];
    [_collisionPath closePath];
    [(_isSelected ? fillColorSelected : fillColorNormal) setFill];
    [_collisionPath fill];
    
    
    //// Symbol Drawing
    CGRect symbolRect = CGRectMake(10, -2, 25, 52);
    [fillColor3 setFill];
    [symbolContent drawInRect: symbolRect withFont: [UIFont fontWithName: @"Helvetica" size: 36] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
}

- (NSString *)description
{
    return _identifier;
}

@end
