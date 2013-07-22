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
static NSString * PATH_KEY = @"path_key";
static NSString * SHAPE_KEY = @"shape_key";
static NSString * PENSIZE_KEY = @"pensize_key";
static NSString * PENCOLOR_KEY = @"pencolor_key";
static NSString * SHAPESELECT_KEY = @"shapeselect_key";
static NSString * TAMPSTAMP_KEY = @"tamstamp_key";
static NSString * FINGER_KEY = @"finger_key";
static NSString * BUTTON_KEY = @"button_key";
- (id)initWithFrame:(CGRect)frame
{ 
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _fingerDrag = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragToDraw:)];
        _fingerDrag.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:_fingerDrag];
        
        _tapStamp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToStamp:)];
        [self addGestureRecognizer:_tapStamp];
        
        _paths = [[NSMutableArray alloc] init];
        [_paths addObject:[[AMBezierPath alloc] init]];
        self.penSize = 1;
        
        _shapes = [[NSMutableArray alloc] init];
        _buttonString = [[NSMutableString alloc]init];
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
    UIImageView *shapeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_buttonString]];
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
//- (id)initWithCoder:(NSCoder *)aCoder {
//    if (self = [super init]) {
//        _paths = [aCoder decodeObjectForKey:PATH_KEY];
//        _penSize = [aCoder decodeFloatForKey:PENSIZE_KEY];
//        _penColor = [aCoder decodeObjectForKey:PENCOLOR_KEY];
//        _shapes = [aCoder decodeObjectForKey:SHAPE_KEY];
//        _shapeSelected = [aCoder decodeBoolForKey:SHAPESELECT_KEY];
//        _tapStamp = [aCoder decodeObjectForKey:TAMPSTAMP_KEY];
//        _fingerDrag = [aCoder decodeObjectForKey:FINGER_KEY];
//        _buttonString = [aCoder decodeObjectForKey:BUTTON_KEY];
//        
//      
//        
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//   // [aCoder encodeObject:_view forKey:VIEW_KEY];
//    [aCoder encodeObject:_paths forKey:PATH_KEY];
//    [aCoder encodeFloat:_penSize forKey:PENSIZE_KEY];
//    [aCoder encodeObject:_penColor forKey:PENCOLOR_KEY];
//    [aCoder encodeObject:_shapes forKey:SHAPE_KEY];
//    [aCoder encodeBool:_shapeSelected forKey:SHAPESELECT_KEY];
//    [aCoder encodeObject:_tapStamp forKey:TAMPSTAMP_KEY];
//    [aCoder encodeObject:_fingerDrag forKey:FINGER_KEY];
//    [aCoder encodeObject:_buttonString forKey:BUTTON_KEY];
//
//}

@end

