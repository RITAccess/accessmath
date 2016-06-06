//
//  DraggableView.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 5/2/16.
//
//

#import "DraggableView.h"

@implementation DraggableView
{
    BOOL tappedTwice;
    CGRect prevFrame;
    
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    startLocation = pt;
    if (([touch tapCount] == 2) && !tappedTwice) {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            //save previous frame
            prevFrame = self.frame;
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 500, 500)];
        }completion:^(BOOL finished){
            tappedTwice = YES;
        }];
        return;
    }
    else if (([touch tapCount] == 2) && tappedTwice) {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            [self setFrame:prevFrame];
        }completion:^(BOOL finished){
            tappedTwice = NO;
        }];
        return;
    }
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