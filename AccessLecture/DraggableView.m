//
//  DraggableView.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 5/2/16.
//
//

#import "DraggableView.h"

@implementation DraggableView

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    // Retrieve the touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
    [[self superview] bringSubviewToFront:self];
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    // Move relative to the original touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    frame.origin.x += pt.x - startLocation.x;
    frame.origin.y += pt.y - startLocation.y;
    [self setFrame:frame];
}

@end
