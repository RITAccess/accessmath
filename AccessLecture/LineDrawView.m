//
//  LineDrawViewController.m
//  AccessLecture
//
//  Created by Piper Chester on 6/6/13.
//
//

#import "LineDrawView.h"

@interface LineDrawView ()

@end

@implementation LineDrawView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        _bezierPath=[[UIBezierPath alloc]init];
        _bezierPath2=[[UIBezierPath alloc]init];
        _bezierPath3=[[UIBezierPath alloc]init];
        _bezierPath4=[[UIBezierPath alloc]init];
        _bezierPath5=[[UIBezierPath alloc]init];
        _currentPath = 0;
    }
    
    return self;
}

#pragma mark - Touch Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch=[[touches allObjects] objectAtIndex:0];
    
    switch (_currentPath) {
        case 0:
            [_bezierPath moveToPoint:[touch locationInView:self]];
            break;
        case 1:
            [_bezierPath2 moveToPoint:[touch locationInView:self]];
            break;
        case 2:
            [_bezierPath3 moveToPoint:[touch locationInView:self]];
            break;
        case 3:
            [_bezierPath4 moveToPoint:[touch locationInView:self]];
            break;
        default:
            [_bezierPath5 moveToPoint:[touch locationInView:self]];
            break;
    }    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch=[[touches allObjects] objectAtIndex:0];

    switch (_currentPath) {
        case 0:
            [_bezierPath addLineToPoint:[touch locationInView:self]];
            break;
        case 1:
            [_bezierPath2 addLineToPoint:[touch locationInView:self]];
            break;
        case 2:
            [_bezierPath3 addLineToPoint:[touch locationInView:self]];
            break;
        case 3:
            [_bezierPath4 addLineToPoint:[touch locationInView:self]];
            break;
        default:
            [_bezierPath5 addLineToPoint:[touch locationInView:self]];
            break;
    }
    
    [self setNeedsDisplay];
}

/**
 * Override drawRect() to allow for custom drawing. No override causes performance issues.
 * Alternating setting stroke and stroking to handle each individual path.
 */
- (void)drawRect:(CGRect)rect {
    [[UIColor redColor] setStroke];
    [_bezierPath stroke];
    [[UIColor greenColor] setStroke];
    [_bezierPath2 stroke];
    [[UIColor blueColor] setStroke];
    [_bezierPath3 stroke];
    [[UIColor blackColor] setStroke];
    [_bezierPath4 stroke];
    [[UIColor yellowColor] setStroke];
    [_bezierPath5 stroke];
}

@end
