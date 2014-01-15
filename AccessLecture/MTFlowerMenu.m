//
//  MTFlowerMenu.m
//  AccessLecture
//
//  Created by Michael on 1/13/14.
//
//

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

#import <objc/runtime.h>
#import "MTFlowerMenu.h"
#import "AddNoteView.h"

CGPoint CGRectCenterPoint(CGRect rect) {
    return CGPointMake(rect.size.width / 2.0,
                       rect.size.height / 2.0);
}

CGAffineTransform CGAffineTransformOrientOnAngle(CGFloat angle){
    CGAffineTransform newTransform = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
    newTransform = CGAffineTransformTranslate(newTransform, 0.0, -60.0);
    return newTransform;
}

@interface MTFlowerMenu ()

@end

@implementation MTFlowerMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)showMenuAnimated:(BOOL)animated
{
    // Create menu items
    AddNoteView *addNote = [[AddNoteView alloc] initWithFrame:({
        CGRect frame = CGRectZero;
        frame.origin = CGRectCenterPoint(self.frame);
        frame = CGRectInset(frame, -22.5, -37.5);
        frame;
    })];
    addNote.identifier = @"AddNote";
    [self addSubview:addNote];
    
    AddNoteView *addImage = [[AddNoteView alloc] initWithFrame:({
        CGRect frame = CGRectZero;
        frame.origin = CGRectCenterPoint(self.frame);
        frame = CGRectInset(frame, -22.5, -37.5);
        frame;
    })];
    addImage.identifier = @"AddImage";
    [self addSubview:addImage];
    
    AddNoteView *addTest = [[AddNoteView alloc] initWithFrame:({
        CGRect frame = CGRectZero;
        frame.origin = CGRectCenterPoint(self.frame);
        frame = CGRectInset(frame, -22.5, -37.5);
        frame;
    })];
    addTest.identifier = @"AddTest";
    [self addSubview:addTest];
    
    // Animate them
    CGAffineTransform start = CGAffineTransformMakeScale(0.0, 0.0);
    addNote.transform = start;
    addImage.transform = start;
    addTest.transform = start;
    
    // Animate self
    self.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
    
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:0.3 options:UIViewAnimationCurveEaseOut animations:^{
        addNote.transform = CGAffineTransformOrientOnAngle(DEGREES_TO_RADIANS(-10));
        objc_setAssociatedObject(addNote, "display_angle", @(-10), OBJC_ASSOCIATION_RETAIN);
        addImage.transform = CGAffineTransformOrientOnAngle(DEGREES_TO_RADIANS(-60));
        objc_setAssociatedObject(addImage, "display_angle", @(-60), OBJC_ASSOCIATION_RETAIN);
        addTest.transform = CGAffineTransformOrientOnAngle(DEGREES_TO_RADIANS(-110));
        objc_setAssociatedObject(addTest, "display_angle", @(-110), OBJC_ASSOCIATION_RETAIN);
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)hideMenuAnimated:(BOOL)animated completed:(void(^)(BOOL finished))competion
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.alpha = 1.0;
        self.transform = CGAffineTransformIdentity;
        competion(finished);
    }];
}

- (void)prepareMenuAtPoint:(CGPoint)point
{
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    self.frame = CGRectMake(point.x, point.y, 0.0, 0.0);
    self.frame = CGRectInset(self.frame, -125, -125);
    [self setNeedsDisplayInRect:self.frame];
}

- (void)resetMenu
{
    self.frame = CGRectZero;
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
}

- (void)notifyObserversOfSelection
{
    for (AddNoteView *view in self.subviews) {
        if ([view isKindOfClass:[AddNoteView class]]) {
            if (view.isSelected) {
                _selectedIdentifier = view.identifier;
                _location = self.center;
                [self sendActionsForControlEvents:UIControlEventTouchUpInside];
                break;
            }
        }
    }
}

- (void)handleTouch:(UIGestureRecognizer *)reg
{
    if (!CGAffineTransformIsIdentity(self.transform)) {
        return;
    }
    for (AddNoteView *view in self.subviews) {
        if ([view isKindOfClass:[AddNoteView class]]) {
            CGPoint touch = [reg locationInView:view];
            view.isSelected = [view.collisionPath containsPoint:touch];
            if (view.isSelected) {
                CGAffineTransform bigTrans = CGAffineTransformScale(CGAffineTransformOrientOnAngle(DEGREES_TO_RADIANS([objc_getAssociatedObject(view, "display_angle") integerValue])), 1.5, 1.5);
                bigTrans = CGAffineTransformTranslate(bigTrans, 0.0, -13.0);
                if (CGAffineTransformEqualToTransform(bigTrans, view.transform)) {
                    continue;
                }
                [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    view.transform = bigTrans;
                } completion:nil];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    view.transform = CGAffineTransformOrientOnAngle(DEGREES_TO_RADIANS([objc_getAssociatedObject(view, "display_angle") integerValue]));
                }];
            }
            [view setNeedsDisplay];
        }
    }
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)reg
{
    switch (reg.state) {
        case UIGestureRecognizerStateBegan:
            [self prepareMenuAtPoint:[reg locationInView:self.superview]];
            [self showMenuAnimated:YES];
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded: {
            [self notifyObserversOfSelection];
            [self hideMenuAnimated:YES completed:^(BOOL finished) {
                [self resetMenu];
            }];
        }
        case UIGestureRecognizerStateChanged:
            [self handleTouch:reg];
            break;
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect
{

}

@end
