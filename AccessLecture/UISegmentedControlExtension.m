//
//  UISegmentedControlExtension.m
//  AccessLecture
//
//  Created by Piper Chester on 6/12/13.
//
//

#import "UISegmentedControlExtension.h"


@implementation UISegmentedControl(CustomTintExtension)

-(void)setTag:(NSInteger)tag forSegmentAtIndex:(NSUInteger)segment {
    [[[self subviews] objectAtIndex:segment] setTag:tag];
}

-(void)setTintColor:(UIColor*)color forTag:(NSInteger)aTag {
    // Must operate by tags.  Subview index is unreliable.
    UIView *segment = [self viewWithTag:aTag];
    
    // Extending height of each subview of segments.
    for (UIView *view in segment.subviews){
        [view setFrame:CGRectMake(0, 0, 0, 600)];
    }
    
    // If the segment exists and if it responds to the setTintColor message.
    if (segment && ([segment respondsToSelector:@selector(setTintColor:)])) {
        [segment performSelector:@selector(setTintColor:) withObject:color];
    }
}

@end
