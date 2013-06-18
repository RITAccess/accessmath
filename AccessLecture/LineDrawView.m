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

@synthesize brushColor;
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
        self.backgroundColor=[UIColor lightGrayColor];
        
        // Will move these to an array of UIBezierPaths soon.
        bezierPath=[[UIBezierPath alloc]init];
        bezierPath.lineWidth=1;
        
        bezierPath2=[[UIBezierPath alloc]init];
        bezierPath2.lineWidth=5;
        
        bezierPath3=[[UIBezierPath alloc]init];
        bezierPath3.lineWidth=10;
        
        bezierPath4=[[UIBezierPath alloc]init];
        bezierPath4.lineWidth=15;
        
        bezierPath5=[[UIBezierPath alloc]init];
        bezierPath5.lineWidth=20;
        
        brushColor=[UIColor redColor];
        
        currentPath = 0; // Current UIBezierPath is 0; this is the Red Segment.
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
    UITouch *aTouch = [touches anyObject];
    //Boolean variable to decide whether current location needs to edit an existing note or create a new one
    BOOL isNew = YES;
    //Check for double tap
    if (aTouch.tapCount >= 1 && [self subviews].count >0)
    {
        for(UITextView *view in [self subviews] )
            
        {
            if([view isKindOfClass:[UITextView class]])
            {
                
                view.hidden = YES;
            }
            
            
        }
        
    }
    if (aTouch.tapCount >= 2) {
        //Fetch all UITextViews currently
        UITouch *touch=[[touches allObjects] objectAtIndex:0];
        for(UITextView *view in [self subviews] )
            
        {
            if (CGRectContainsPoint(view.frame,[aTouch locationInView:self]))
            {
                isNew=NO;
                view.hidden = NO;
                [view becomeFirstResponder];
                
            }
            
        }
        if(isNew==YES)
        {
            
            [bezierPath addArcWithCenter:CGPointMake([touch locationInView:self].x,[touch locationInView:self].y ) radius:15 startAngle:90 endAngle:180 clockwise:YES];
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake([touch locationInView:self].x, [touch locationInView:self].y ,300,90)];
            [self addSubview:textView];
            textView.text = @"Tap to Enter Notes";
            
            [textView setScrollEnabled:YES];
            [textView scrollRectToVisible:CGRectMake([touch locationInView:self].x, [touch locationInView:self].y, 300,90) animated:NO];
            [textView setFont:[UIFont systemFontOfSize:25]];
          //  textView.layer.borderWidth=0.5f;
            [textView setNeedsDisplay];
            [textView becomeFirstResponder];
                       
        }
    }
    
    
}

/**
 * Override drawRect() to allow for custom drawing. No override causes performance issues.
 */
- (void)drawRect:(CGRect)rect
{
    [brushColor setStroke];
    [bezierPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    [bezierPath2 strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
    [bezierPath3 strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
    [bezierPath4 strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
    [bezierPath5 strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
}

@end
