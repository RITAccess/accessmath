// Copyright 2011 Access Lecture. All rights reserved.

#import "InlineNotesViewController.h" 
#import <QuartzCore/QuartzCore.h> 

//CONSTANTS: 
#define kPaletteHeight   50
#define kPaletteSize   5
#define kMinEraseInterval  0.5 

//Padding for margins
#define kLeftMargin    10.0
#define kRightMargin   10.0
#define kTopMargin    10.0

#define SGMT_CTRL_HEIGHT 50.0f
#define DEFAULT_VIEW_HEIGHT 200.0f

@implementation InlineNotesViewController 

@synthesize segmentedControl;

/**
 Initialize the view controller by linking it to a specific xib file
 */
- (id)initWithScrollView:(UIScrollView*)sv {
    
    viewHeight = DEFAULT_VIEW_HEIGHT;
    parentScrollView = sv;
    self = [super initWithNibName:@"InlineNotesViewController" bundle:nil];
    return self;
}
/**
 Initialization function with a specified height
 */
-(id)initWithHeight:(float)height : (UIScrollView*) sv {
    
    viewHeight = height;
    parentScrollView = sv;
    self = [super initWithNibName:@"InlineNotesViewController" bundle:nil];
    return self;
}

/**
 Logic for when the screen first loads
 */
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;  
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Resize the frame according to the viewHeight
    CGRect vFrame = [self.view frame];
    vFrame.size.height = viewHeight;
    [self.view setFrame:vFrame];
    
    // Position the SegmentedControl relative to the height
    CGRect scFrame = [segmentedControl frame];
    scFrame.origin.y = viewHeight - SGMT_CTRL_HEIGHT;
    [segmentedControl setFrame:scFrame];
    CGRect frame = [[self view]frame];
    frame.origin.y = 800;
    [[self view]setFrame:frame];
    
    // Modify the parent UIViewController's scrollView frame
    CGRect newFrame = [parentScrollView frame];
    newFrame.size.height -= viewHeight - 74;
    [parentScrollView setFrame:newFrame];
    
    // Set button colors
    [[segmentedControl.subviews objectAtIndex:0] setTintColor:[UIColor redColor]];
    [[segmentedControl.subviews objectAtIndex:1] setTintColor:[UIColor greenColor]];
    [[segmentedControl.subviews objectAtIndex:2] setTintColor:[UIColor blueColor]];
    [[segmentedControl.subviews objectAtIndex:3] setTintColor:[UIColor blackColor]];
    [[segmentedControl.subviews objectAtIndex:4] setTintColor:[UIColor whiteColor]];
    
    UIGraphicsBeginImageContext(drawingView.bounds.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contextRef, 0, 0, 255, 0.1);
    [drawingView.layer  renderInContext:UIGraphicsGetCurrentContext()];
    // Draw a circle (filled)
    CGContextFillEllipseInRect(contextRef, CGRectMake(10, 10, 125, 125));
    
    // Set up pen & eraser
    mouseMoved = 0;
    isEraserOn = FALSE;
    eraserRadius = 20; 
    eraser = [[UIImageView alloc] initWithImage:nil];
    eraser.frame = CGRectMake(0, 0, eraserRadius, eraserRadius);
    [self resetEraser:TRUE];
    [drawingView addSubview:eraser]; 
    [self setColorRGB:0 green:0 blue:0];
    [self setPenRadius: 5]; 
} 

/**
 Returns to previous screen
 */
-(IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

/**
 Saves an image
 */
-(IBAction)saveButton:(id)sender {
    
    UIImage *saveImage;
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [drawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    saveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *docDir = @"/Users/Student/Desktop/";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"YYYY-MM-dd-h-m-s"];
    NSString* currentDate =  [dateFormatter stringFromDate:[NSDate date]];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir, currentDate ];
	NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(saveImage)];
	[data1 writeToFile:pngFilePath atomically:YES];
}

/**
 When the user first starts writing
 */
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    isMouseMoved = NO;
    UITouch *touch = [touches anyObject]; 
    
    // Remove all writing
    if([touch tapCount] == 2){
        drawingView.image = nil;
        return;
    } 
    
    CGPoint currentPoint = [touch locationInView:drawingView];
    
    if(isEraserOn) {
        [self changeEraserLocationTo:currentPoint];
    } 
    
    [self resetEraser:FALSE];
    lastPoint = [touch locationInView:drawingView];
    
} 

/**
 * When the user first starts moving the pen
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    isMouseMoved = YES; 
    UITouch *touch = [touches anyObject]; 
    CGPoint currentPoint = [touch locationInView:drawingView]; 
    
    // Setup the context
    UIGraphicsBeginImageContext(drawingView.frame.size);
    [drawingView.image drawInRect:CGRectMake(0, 0, drawingView.frame.size.width, drawingView.frame.size.height)];
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), penRadius);
    
    if(isEraserOn) {
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
        CGRect eraserFrame = eraser.frame; 
        eraserFrame.origin.x = currentPoint.x - (eraserRadius/2);
        eraserFrame.origin.y = currentPoint.y - (eraserRadius/2);
        eraser.frame = eraserFrame;
        
    } else {
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), r, g, b, 1.0); 
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    }
    
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    drawingView.image = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext(); 
    lastPoint = currentPoint; 
    mouseMoved++; 
    
    if (mouseMoved == 1) {
        mouseMoved = 0;
    } 
} 

/**
 When the user stops writing
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event { 
    
    UITouch *touch = [touches anyObject]; 
    
    // Remove all writing
    if ([touch tapCount] == 2) {
        drawingView.image = nil;
        return;
    } 
    
    [self resetEraser:TRUE]; 
    
    if (!isMouseMoved) {
        UIGraphicsBeginImageContext(drawingView.frame.size);
        CGContextRef contextRef = UIGraphicsGetCurrentContext(); 
        
        [drawingView.image drawInRect:CGRectMake(0, 0, drawingView.frame.size.width, drawingView.frame.size.height)];
        
        CGContextSetLineWidth(contextRef, penRadius);
        CGContextSetRGBStrokeColor(contextRef, r, g, b, 1.0);
        CGContextMoveToPoint(contextRef, lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(contextRef, lastPoint.x, lastPoint.y);
        CGContextStrokePath(contextRef);
        drawingView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
} 

/**
 Get the height of the segmented control
 */
-(float) getSegmentCtrlHeight {
    return SGMT_CTRL_HEIGHT;
}

/**
 Changing pen color
 */
-(IBAction) segmentedControlIndexChanged {
    [self setPenRadius:5];
    isEraserOn = FALSE;
    [eraser removeFromSuperview];
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self setColorRGB:1 green:0 blue:0]; //red
            break;
        case 1:
            [self setColorRGB:0 green:1 blue:0]; //green
            break;
        case 2:
            [self setColorRGB:0 green:0 blue:1]; //blue
            break;
        case 4:
            [self setPenRadius:20]; // set the eraser radius a little bigger
            isEraserOn = TRUE;
            break;
        default:
            [self setColorRGB:0 green:0 blue:0]; // black
    }
} 

/**
 Set color of the pen
 */
-(void) setColorRGB:(int)red green:(int)green blue:(int)blue {
    r = red;
    g = green;
    b = blue;
} 

/**
 Set radius of pen tip
 */
-(void) setPenRadius:(int)pixels {
    penRadius = pixels;
} 

/**
 Reset the eraser & pen
 */
-(void)resetEraser:(BOOL)isSet { 
    
    if(isEraserOn) {
        if(isSet) {
            CGRect eraserFrame = eraser.frame;
            eraserFrame.size.width = 0;
            eraserFrame.size.height = 0;
            eraser.frame = eraserFrame;
        } else {
            CGRect eraserFrame = eraser.frame;
            eraserFrame.size.width = 20;
            eraserFrame.size.height = 20;
            eraser.backgroundColor = [UIColor grayColor];
            eraser.frame = eraserFrame;
            [drawingView addSubview:eraser];   
        }
    }
} 

/**
 Move the location of the eraser/pen tip
 */
- (void)changeEraserLocationTo:(CGPoint)locationPoint {
    
    CGRect eraserFrame = eraser.frame; 
    eraserFrame.origin.x = locationPoint.x - (eraserRadius/2);
    eraserFrame.origin.y = locationPoint.y - (eraserRadius/2);
    eraser.frame = eraserFrame; 
} 

/**
 Do we want the application to be rotateable? Return YES or NO
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
} 

/**
 In case there's a memory warning
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
} 

/**
 Release resources from memory
 */

@end
