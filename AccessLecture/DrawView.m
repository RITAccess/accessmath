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
        
        _fingerDrag = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragToDraw:)];
        [self addGestureRecognizer:_fingerDrag];
        
        _tapStamp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToStamp:)];
        [self addGestureRecognizer:_tapStamp];
        
        _paths = [[NSMutableArray alloc] init];
        [_paths addObject:[[AMBezierPath alloc] init]];
        self.penSize = 1;
        
        _shapes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - Touch Methods

- (void)dragToDraw:(UIGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [_paths addObject:[[AMBezierPath alloc] init]];
            [[_paths lastObject] moveToPoint:[gesture locationInView:self]];
            [[_paths lastObject] setLineWidth:self.penSize];
            [[_paths lastObject] setColor:self.penColor];
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            [[_paths lastObject] addLineToPoint:[gesture locationInView:self]];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            [_shapes addObject:[_paths lastObject]]; // Adding finished path to Shapes array.
            break;
        }
            
        default:
            break;
    }
    
    [self setNeedsDisplay];
}


- (void)tapToStamp:(UITapGestureRecognizer *)gesture
{
    UIImageView *shapeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.png"]];
    [shapeImageView setFrame:CGRectMake([gesture locationInView:self].x, [gesture locationInView:self].y, 50, 50)];
    [_shapes addObject:shapeImageView];
    [self addSubview:shapeImageView];
}


# pragma mark - Drawing Methods

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

