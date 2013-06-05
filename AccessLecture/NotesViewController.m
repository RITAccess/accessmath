// Copyright 2011 Access Lecture. All rights reserved.

#import "NotesViewController.h" 

//CONSTANTS: 
#define kPaletteHeight   50
#define kPaletteSize   5
#define kMinEraseInterval  0.5 
#define SCREEN_WIDTH 768
#define TOOLBAR_HEIGHT 74
#define SEGMENT_HEIGHT 44

//Padding for margins
#define kLeftMargin    10.0
#define kRightMargin   10.0
#define kTopMargin    10.0

@implementation NotesViewController 

@synthesize segmentedControl, imageView;

/**
 Initialize the view controller by linking it to a specific xib file
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    [self.view addSubview:segmentedControl];
    [segmentedControl setFrame: CGRectMake(0.0f, 940.0f, 768.0f, 64.0f)];
    
    // Initialize images
    redDown = [UIImage imageNamed:@"RedDown.png"];
    redUp = [UIImage imageNamed:@"RedUp.png"];
    greenDown = [UIImage imageNamed:@"GreenDown.png"];
    greenUp = [UIImage imageNamed:@"GreenUp.png"];
    blueDown = [UIImage imageNamed:@"BlueDown.png"];
    blueUp = [UIImage imageNamed:@"BlueUp.png"];
    blackDown = [UIImage imageNamed:@"BlackDown.png"];
    blackUp = [UIImage imageNamed:@"BlackUp.png"];
    eraserDown = [UIImage imageNamed:@"EraserDown.png"];
    eraserUp = [UIImage imageNamed:@"EraserUp.png"];
    
    // Set images
    [segmentedControl setImage: redUp forSegmentAtIndex:0];
    [segmentedControl setImage: greenUp forSegmentAtIndex:1];
    [segmentedControl setImage: blueUp forSegmentAtIndex:2];
    [segmentedControl setImage: blackDown forSegmentAtIndex:3];
    [segmentedControl setImage: eraserUp forSegmentAtIndex:4];
    
    [segmentedControl setHidden:YES];
    
    return self;
}


/**
 Logic for when the screen first loads
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
        NSLog(@"Notes View Loaded!");
    
    // Hide the navigation bar if we don't want to see it
    self.navigationController.navigationBarHidden = YES;  
    
    // Set up pen & eraser
    isEraserOn = FALSE;
    eraserRadius = ([defaults floatForKey:@"eraserSize"] * 100); 
    eraser = [[UIImageView alloc] initWithImage:nil];
    eraser.frame = CGRectMake(0, 0, eraserRadius, eraserRadius);
    [self resetEraser:TRUE];
    [imageView addSubview:eraser]; 
    [self setColorRGB:0 green:0 blue:0];
    [self setPenRadius: ([defaults floatForKey:@"penSize"] * 10)]; 
    
    // Add color-picking segmented control to the view
    [self.view addSubview:segmentedControl];
    [segmentedControl setFrame: CGRectMake(0.0f, 940.0f, 768.0f, 64.0f)];
    
    // User settings
    defaults = [NSUserDefaults standardUserDefaults]; 
    
    // Observe NSUserDefaults for setting changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChange) name:NSUserDefaultsDidChangeNotification object:nil];
    [self settingsChange];
} 


/**
 Gets called at launch & every time the settings are updated
 */
-(void)settingsChange {
    // Update pen size
    penRadius = ([defaults floatForKey:@"penSize"] * 10);
    
    // Update eraser size
    eraserRadius = ([defaults floatForKey:@"eraserSize"] * 100);
    eraser.frame = CGRectMake(0, 0, eraserRadius, eraserRadius);
}

/**
 When the user first starts writing
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"Touches began!");
    
    isMouseMoved = NO;
    UITouch *touch = [touches anyObject]; 
    
    CGPoint currentPoint = [touch locationInView:imageView];
    
    if(isEraserOn){
        [self changeEraserLocationTo:currentPoint];
    } 
    
    [self resetEraser:FALSE];
    lastPoint = [touch locationInView:imageView];
} 

/**
 When the user first starts moving the pen
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"Moving finger...");
    
    isMouseMoved = YES; 
    
    UITouch *touch = [touches anyObject]; 
    CGPoint currentPoint = [touch locationInView:imageView]; 
    
    // Setting up the context
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    if (isEraserOn) { // if user has pressed the eraser
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), eraserRadius);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
        CGRect eraserFrame = eraser.frame; 
        
        eraserFrame.origin.x = currentPoint.x - (eraserRadius/2);
        eraserFrame.origin.y = currentPoint.y - (eraserRadius/2);
        eraser.frame = eraserFrame;
    } else { // pen mode
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), penRadius);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), r, g, b, 1.0); 
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    }
    
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext(); 
    lastPoint = currentPoint; 
} 

/**
 When the user stops writing
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event { 
    [self resetEraser:TRUE]; 
    
    if (!isMouseMoved) {
        UIGraphicsBeginImageContext(imageView.frame.size);
        CGContextRef contextRef = UIGraphicsGetCurrentContext(); 
        
        [imageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        CGContextSetLineWidth(contextRef, penRadius);
        CGContextSetRGBStrokeColor(contextRef, r, g, b, 1.0);
        CGContextMoveToPoint(contextRef, lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(contextRef, lastPoint.x, lastPoint.y);
        CGContextStrokePath(contextRef);
        imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
} 

// Show the deselected button picture for indices we're not at
-(void)deselectColors:(int)index{
    // Iterate over segment indices
    for(int x = 0; x<5; x++){
        // If its an index we didn't click
        if( x != index){
            // Show the button up image for the indices we're not clicking
            if(x == 0){
                [segmentedControl setImage: redUp forSegmentAtIndex:0];
            }if(x == 1){
                [segmentedControl setImage: greenUp forSegmentAtIndex:1];
            }if(x == 2){
                [segmentedControl setImage: blueUp forSegmentAtIndex:2];
            }if(x == 3){
                [segmentedControl setImage: blackUp forSegmentAtIndex:3];
            }if(x == 4){
                [segmentedControl setImage: eraserUp forSegmentAtIndex:4];
            }
        }
    }
}

/**
 Change pen color
 */
-(IBAction) segmentedControlIndexChanged{
    [self setPenRadius: ([defaults floatForKey:@"penSize"] * 10)];
    isEraserOn = FALSE;
    [eraser removeFromSuperview];
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self setColorRGB:1 green:0 blue:0]; //red
            [segmentedControl setImage: redDown forSegmentAtIndex:0];
            [self deselectColors:0];
            break;
        case 1:
            [self setColorRGB:0 green:1 blue:0]; //green
            [segmentedControl setImage: greenDown forSegmentAtIndex:1];
            [self deselectColors:1];
            break;
        case 2:
            [self setColorRGB:0 green:0 blue:1]; //blue
            [segmentedControl setImage: blueDown forSegmentAtIndex:2];
            [self deselectColors:2];
            break;
        case 4:
            [self setPenRadius:([defaults floatForKey:@"eraserSize"] * 100)]; // eraser
            [segmentedControl setImage: eraserDown forSegmentAtIndex:4];
            [self deselectColors:4];
            isEraserOn = TRUE;
            break;
        default:
            [self setColorRGB:0 green:0 blue:0]; // black
            [segmentedControl setImage: blackDown forSegmentAtIndex:3];
            [self deselectColors:3];
    }
} 

/**
 Set color
 */
-(void) setColorRGB:(int)red green:(int)green blue:(int)blue {
    r = red;
    g = green;
    b = blue;
} 

/**
 Set radius of pen tip
 */
-(void)setPenRadius:(int)pixels{
    penRadius = pixels;
} 

/**
 Get radius of pen tip
 */
-(int)penRadius {
    return penRadius;
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
            eraserFrame.size.width = eraserRadius;
            eraserFrame.size.height = eraserRadius;;
            eraser.backgroundColor = [UIColor grayColor];
            eraser.frame = eraserFrame;
            [imageView addSubview:eraser];   
        }
        
    }
    
} 

/**
 Move the location of the eraser/pen tip
 */
- (void)changeEraserLocationTo:(CGPoint)locationPoint{
    CGRect eraserFrame = eraser.frame; 
    eraserFrame.origin.x = locationPoint.x - (eraserRadius/2);
    eraserFrame.origin.y = locationPoint.y - (eraserRadius/2);
    eraser.frame = eraserFrame; 
} 

/**
 Do we want the application to be rotateable? Return YES or NO
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Only support portrait
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);

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
