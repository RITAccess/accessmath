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

@synthesize bezierPath;
@synthesize bezierPath2;
@synthesize bezierPath3;
@synthesize bezierPath4;
@synthesize bezierPath5;
@synthesize currentPath;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        // Will move these to an array of UIBezierPaths soon.
        bezierPath=[[UIBezierPath alloc]init];
        bezierPath2=[[UIBezierPath alloc]init];
        bezierPath3=[[UIBezierPath alloc]init];
        bezierPath4=[[UIBezierPath alloc]init];
        bezierPath5=[[UIBezierPath alloc]init];
        
        currentPath = 0;
    }
    
    return self;
}

#pragma mark - Touch Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[[touches allObjects] objectAtIndex:0];
    
    switch (currentPath) {
        case 0:
            [bezierPath moveToPoint:[touch locationInView:self]]; 
            break;
        case 1:
            [bezierPath2 moveToPoint:[touch locationInView:self]];
            break;
        case 2:
            [bezierPath3 moveToPoint:[touch locationInView:self]];
            break;
        case 3:
            [bezierPath4 moveToPoint:[touch locationInView:self]];
            break;
        default:
            [bezierPath5 moveToPoint:[touch locationInView:self]];
            break;
    }    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[[touches allObjects] objectAtIndex:0];

    switch (currentPath) {
        case 0:
            [bezierPath addLineToPoint:[touch locationInView:self]];
            break;
        case 1:
            [bezierPath2 addLineToPoint:[touch locationInView:self]];
            break;
        case 2:
            [bezierPath3 addLineToPoint:[touch locationInView:self]];
            break;
        case 3:
            [bezierPath4 addLineToPoint:[touch locationInView:self]];
            break;
        default:
            [bezierPath5 addLineToPoint:[touch locationInView:self]];
            break;
    }
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}

/**
 * Override drawRect() to allow for custom drawing. No override causes performance issues.
 */
- (void)drawRect:(CGRect)rect
{
    [[UIColor redColor] setStroke];
    [bezierPath stroke];
    [[UIColor greenColor] setStroke];
    [bezierPath2 stroke];
    [[UIColor blueColor] setStroke];
    [bezierPath3 stroke];
    [[UIColor blackColor] setStroke];
    [bezierPath4 stroke];
    [[UIColor yellowColor] setStroke];
    [bezierPath5 stroke];
}

@end
