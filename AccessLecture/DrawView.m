//
//  LineDrawViewController.m
//  AccessLecture
//
//  Created by Piper Chester on 6/6/13.
//
//

#import "DrawView.h"

@interface DrawView ()

@end

@implementation DrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIPanGestureRecognizer *fingerDrag = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragToDraw:)];
        [self addGestureRecognizer:fingerDrag];
        
        _paths = [[NSMutableArray alloc] init];
        [_paths addObject:[[AMBezierPath alloc] init]];
        self.penSize = 1;
    }
    
    return self;
}

#pragma mark - Touch Methods

- (void)dragToDraw:(UIGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint location = [gesture locationInView: self];
            
            [_paths addObject:[[AMBezierPath alloc] init]];
            [[_paths objectAtIndex:_paths.count - 1] moveToPoint:location];
            [[_paths lastObject] setLineWidth:self.penSize];
            [[_paths lastObject] setColor:self.penColor];
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint location = [gesture locationInView: self];
            
            [[_paths objectAtIndex:_paths.count -1] addLineToPoint:location];
            
            break;
        }
            
        default:
            break;
    }
    
    [self setNeedsDisplay];
    
}


# pragma mark - Drawing Methods

- (void)clearAllPaths
{
    [_paths removeAllObjects];
}

/**
 * Override drawRect() to allow for custom drawing. No override causes performance issues.
 * Alternating setting stroke and stroking to handle each individual path.
 */
- (void)drawRect:(CGRect)rect
{
    for (AMBezierPath *path in _paths)
    {
        [path.color setStroke];
        [path stroke];
    }
}

@end

