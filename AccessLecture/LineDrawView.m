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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        _bezierPath = [[UIBezierPath alloc]init];
        _bezierPath2 = [[UIBezierPath alloc]init];
        _bezierPath3 = [[UIBezierPath alloc]init];
        _bezierPath4 = [[UIBezierPath alloc]init];
        _bezierPath5 = [[UIBezierPath alloc]init];
        _currentPath = 0;
        _isCreatingNote = NO;
    }
    
    return self;
}

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
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

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
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


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    //Boolean variable to decide whether current location needs to edit an existing note or create a new one
    BOOL isNew = YES;
    //Check for double tap
    if (aTouch.tapCount >= 1 && [self subviews].count > 0)
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
  //      UIBezierPath *notesBezierPath = [[UIBezierPath alloc]init];
        for(UITextView *view in [self subviews] )
        {
            if (CGRectContainsPoint(view.frame,[aTouch locationInView:self]))
            {
                isNew = NO;
                view.hidden = NO;
                [view becomeFirstResponder];
            }
            
        }
        if(isNew == YES && self.isCreatingNote == YES)
        {
            NSLog(@"Is Creating Note...");
//            [_bezierPath addArcWithCenter:CGPointMake([touch locationInView:self].x,[touch locationInView:self].y ) radius:15 startAngle:90 endAngle:180 clockwise:YES];
            UIImageView * anImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png" ]];
            [anImageView setCenter:[touch locationInView:self]];
            [anImageView setBounds:CGRectMake([touch locationInView:self].x, [touch locationInView:self].y, 50, 50)];
            [self addSubview:anImageView];
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

- (void)clearAllPaths {
    [_bezierPath removeAllPoints];
    [_bezierPath2 removeAllPoints];
    [_bezierPath3 removeAllPoints];
    [_bezierPath4 removeAllPoints];
    [_bezierPath5 removeAllPoints];
}

+ (void)setLineWidth:(NSInteger)newWidth {

    
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

