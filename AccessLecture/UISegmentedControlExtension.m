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
    // must operate by tags.  Subview index is unreliable
    UIView *segment = [self viewWithTag:aTag];
    SEL tint = @selector(setTintColor:);
    
    // UISegment is an undocumented class, so tread carefully
    // if the segment exists and if it responds to the setTintColor message
    if (segment && ([segment respondsToSelector:tint])) {
        [segment performSelector:tint withObject:color];
    }
}

-(void)setShadowColor:(UIColor*)color forTag:(NSInteger)aTag {
    
    // you could also combine setShadowColor and setTextColor
    UIView *segment = [self viewWithTag:aTag];
    for (UIView *view in segment.subviews) {
        SEL shadowColor = @selector(setShadowColor:);
        if (view && ([view respondsToSelector:shadowColor])) {
            [view performSelector:shadowColor withObject:color];
        }
    }
}

@end
