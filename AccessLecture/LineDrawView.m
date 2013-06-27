//
//  LineDrawViewController.m
//  AccessLecture
//
//  Created by Piper Chester on 6/6/13.
//
//

#import "LineDrawView.h"
#import "AccessLectureRuntime.h"
@interface LineDrawView ()

@end

@implementation LineDrawView
@synthesize start;
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
        _isDrawing = YES;
        _tapToCreateNote = [[UITapGestureRecognizer alloc]initWithTarget:self action
                                                                        :@selector(createNote:)];
        _tapToCreateNote.numberOfTapsRequired = 2;
        _tapToDismissKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action
                                                                             :@selector(dismissKeyboard)];
        [self addGestureRecognizer:_tapToDismissKeyboard];
        [self addGestureRecognizer:_tapToCreateNote];
//        [self addGestureRecognizer:_panToMoveNote];
    }
    
    return self;
}

#pragma mark - Touch Methods

- (void)dismissKeyboard
{
    [self endEditing:YES];
}

- (void)createNote:(UIGestureRecognizer *)gesture
{
    if (_isCreatingNote){
        if(self.isCreatingNote){
//            UIImageView *pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
//            [pinImageView setCenter:[gesture locationInView:self]];
//            [pinImageView setTransform:CGAffineTransformMakeScale(.25, .25)]; // Shrinking the pin...
//            pinImageView.userInteractionEnabled = YES;
//            [self addSubview:pinImageView];
        
            UIPanGestureRecognizer *panToMoveNote = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToRemoveNote:)];
            
            UILongPressGestureRecognizer *longPressGestureRecognizer2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDisplayNote:)];
            longPressGestureRecognizer.numberOfTouchesRequired = 3;
            longPressGestureRecognizer2.numberOfTouchesRequired = 2;

            UITextView *textBubble = [[UITextView alloc]initWithFrame:CGRectMake([gesture locationInView:self].x + 15, [gesture locationInView:self].y + 10, 300, 120)];
            UIImageView * anImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png" ]];
            [anImageView setCenter:textBubble.bounds.origin];
            [anImageView setBounds:CGRectMake([gesture locationInView:self].x, [gesture locationInView:self].y, 50, 50)];
            [textBubble addSubview:anImageView];
            textBubble.text = @"Type Notes Here...";
            textBubble.layer.borderWidth = 3;
            textBubble.layer.cornerRadius = 20;
            [textBubble setFont:[UIFont boldSystemFontOfSize:30]];
            [textBubble addGestureRecognizer:panToMoveNote];
           [textBubble addGestureRecognizer:longPressGestureRecognizer2];
            [textBubble addGestureRecognizer:longPressGestureRecognizer];
            

            [self addSubview:textBubble];
            [textBubble setClipsToBounds:NO];
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    [gestureRecognizer.view setFrame:CGRectMake([gestureRecognizer locationInView:self].x, [gestureRecognizer locationInView:self].y, 300, 120)];
}

- (void)longPressToRemoveNote:(UILongPressGestureRecognizer *)gestureRecognizer
{
            //[gestureRecognizer.view removeFromSuperview];
        [gestureRecognizer.view setHidden:YES];
        NSLog(@"Three");
   
}
- (void)longPressToDisplayNote:(UILongPressGestureRecognizer *)gestureRecognizer
{
        NSLog(@"Two");
}

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
    if (_isDrawing){
        switch (_currentPath){
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

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[[touches allObjects] objectAtIndex:0];

    if (_isDrawing){
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
    
      if(self.isCreatingNote == YES)
        for(UITextView *view in [self subviews] )
        {
            if (CGRectContainsPoint(view.frame,[aTouch locationInView:self]))
            {
                isNew = NO;
                view.hidden = NO;
                [view becomeFirstResponder];
            }
            
        }
    }
//    if (aTouch.tapCount >= 2) {
//        //Fetch all UITextViews currently
//        UITouch *touch=[[touches allObjects] objectAtIndex:0];
//         if(isNew == YES && self.isCreatingNote == YES)
//        {
//            NSLog(@"Is Creating Note...");
//            UIImageView * anImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png" ]];
//            [anImageView setCenter:[touch locationInView:self]];
//            [anImageView setBounds:CGRectMake([touch locationInView:self].x, [touch locationInView:self].y, 50, 50)];
//            [self addSubview:anImageView];
//            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake([touch locationInView:self].x, [touch locationInView:self].y ,300,90)];
//            [self addSubview:textView];
//            textView.text = @"Tap to Enter Notes";
//            [textView setScrollEnabled:YES];
//            [textView setFont:[UIFont systemFontOfSize:25]];
//            [textView setNeedsDisplay];
//            [textView becomeFirstResponder];
//            
//        }
 //   }

}

- (void)clearAllPaths
{
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
- (void)drawRect:(CGRect)rect
{
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

