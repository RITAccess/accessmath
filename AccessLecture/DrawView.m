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
        self.backgroundColor=[UIColor lightGrayColor];
        _selectedPath = [[UIBezierPath alloc]init];
        _redBezierPath = [[UIBezierPath alloc]init];
        _greenBezierPath = [[UIBezierPath alloc]init];
        _blueBezierPath = [[UIBezierPath alloc]init];
        _blackBezierPath = [[UIBezierPath alloc]init];
        _yellowBezierPath = [[UIBezierPath alloc]init];
        _eraserBezierPath = [[UIBezierPath alloc]init];
        
        UIPanGestureRecognizer *fingerDrag = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragToDraw:)];
        [self addGestureRecognizer:fingerDrag];
    }
    
    return self;
}

#pragma mark - Touch Methods

- (void)dragToDraw:(UIGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"Beginning...");
            CGPoint location = [gesture locationInView: self];
            [_selectedPath moveToPoint:location];
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint location = [gesture locationInView: self];
            [_selectedPath addLineToPoint:location];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            NSLog(@"Ended!");
            break;
        default:
            break;
    }
    
    [self setNeedsDisplay];
}


# pragma mark - Drawing Methods

- (void)clearAllPaths
{
    [_redBezierPath removeAllPoints];
    [_greenBezierPath removeAllPoints];
    [_blueBezierPath removeAllPoints];
    [_blackBezierPath removeAllPoints];
    [_yellowBezierPath removeAllPoints];
    [_eraserBezierPath removeAllPoints];
}

/**
 * Override drawRect() to allow for custom drawing. No override causes performance issues.
 * Alternating setting stroke and stroking to handle each individual path.
 */
- (void)drawRect:(CGRect)rect
{
    [[UIColor redColor] setStroke];
    [_redBezierPath stroke];
    [[UIColor greenColor] setStroke];
    [_greenBezierPath stroke];
    [[UIColor blueColor] setStroke];
    [_blueBezierPath stroke];
    [[UIColor blackColor] setStroke];
    [_blackBezierPath stroke];
    [[UIColor yellowColor] setStroke];
    [_yellowBezierPath stroke];
}


@end

