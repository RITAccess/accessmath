// Copyright 2011 Access Lecture. All rights reserved.

#import "LectureViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UILargeAlertView.h"
#import "LineDrawView.h"
#import "FileManager.h"
#import "AccessDocument.h"

#define RED_TAG 111
#define GREEN_TAG 112
#define BLUE_TAG 113
#define BLACK_TAG 114
#define HILIGHT_TAG 115
#define ERASER_TAG 116

#define ZOOM_VIEW_TAG 100
#define MIN_ZOOM_SCALE 1.0
#define MAX_ZOOM_SCALE 20
#define SCREEN_WIDTH 768
#define USERNAME @"Student"
#define PASSWORD @"lecture"

#define IPAD_MINI_HEIGHT 1024
#define IPAD_MINI_WIDTH 768

#define BUTTON_SIZE 100
#define TOP_BUTTONS_Y 101
#define LANDSCAPE_BOTTOM_BUTTONS_Y 643
#define PORTRAIT_BOTTOM_BUTTONS_Y 904

NSString* urlString = @"http://michaeltimbrook.com/common/library/apps/Screen/test.png";

@interface LectureViewController (UtilityMethods)

@end

@implementation LectureViewController {
    __weak UIPopoverController *popover;
}

- (void)viewDidLoad {
    defaults = [NSUserDefaults standardUserDefaults];
    
    lineDrawView = [[LineDrawView alloc]initWithFrame:CGRectMake(0, 180, IPAD_MINI_HEIGHT, 468)];
    
    // Zoom Setup
    ZOOM_STEP = [defaults floatForKey:@"userZoomIncrement"];
	zoomHandler = [[ZoomHandler alloc] initWithZoomLevel: ZOOM_STEP];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 180, IPAD_MINI_HEIGHT, 468)];
    scrollView.contentSize = CGSizeMake(IPAD_MINI_HEIGHT, 468);
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];
    
    // Observe NSUserDefaults for setting changes
    // Will automatically call settingsChanged: when approproiate
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChange) name:NSUserDefaultsDidChangeNotification object:nil];
    
    panToMove = [[UIPanGestureRecognizer alloc]initWithTarget:self action
                                                             :@selector(panMove:)];
    panToMove.minimumNumberOfTouches = 3;
    panToMove.maximumNumberOfTouches = 3;
    [panToMove setTranslation:CGPointMake(40, 40) inView:lineDrawView];
    [self.view addGestureRecognizer:panToMove];
    
    
    tapToZoom = [[UITapGestureRecognizer alloc] initWithTarget:self action:
                                         @selector(zoomTap:)];
    tapToZoom.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapToZoom];
    
    [self settingsChange];     // Apply the stored settings
    
    [super viewDidLoad];
}

/**
 * In case there's a memory warning.
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setClearNotesButton:nil];
    [self setZoomOutButton:nil];
    [self setZoomInButton:nil];
    [self setStartNotesButton:nil];
    [self setExitNotesButton:nil];
    [self setSaveNotesButton:nil];
    [self setNavigationBar:nil];
    [self setNavigationBarBackButton:nil];
    [self setNavigationBarSettingsButton:nil];
    [super viewDidUnload];
}

/**
 * Gets called at launch & every time the settings are updated.
 */
-(void)settingsChange
{
    // Zoom increment 
    ZOOM_STEP = ([defaults floatForKey:@"userZoomIncrement"] * 100);
    [zoomHandler setZoomLevel:ZOOM_STEP];
    
    // Active usability testing image
    img = [UIImage imageNamed:[defaults valueForKey:@"testImage"]];
    [imageView setImage:img];
    
    // Hide Clear and Exit Notes Buttons on Start
    self.clearNotesButton.hidden = YES;
    self.exitNotesButton.hidden = YES;
    
    // Initialize Zoom check, will flip when zoomed in
    isZoomedIn = NO;
}

/**
 * Get a screenshot of a ScrollView's content.
 */
- (UIImage *)imageByCropping:(UIScrollView *)imageToCrop toRect:(CGRect)rect
{
    imageToCrop.clipsToBounds = NO;
    CGSize pageSize = rect.size;
    UIGraphicsBeginImageContext(pageSize);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    imageToCrop.clipsToBounds = YES;
    
    return image;
}


#pragma mark - Rotation Handling

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        self.zoomInButton.frame = CGRectMake(829, LANDSCAPE_BOTTOM_BUTTONS_Y, BUTTON_SIZE, BUTTON_SIZE);
        self.zoomOutButton.frame = CGRectMake(926, LANDSCAPE_BOTTOM_BUTTONS_Y, BUTTON_SIZE, BUTTON_SIZE);
        self.startNotesButton.frame = CGRectMake(6, LANDSCAPE_BOTTOM_BUTTONS_Y, BUTTON_SIZE, BUTTON_SIZE);
        self.saveNotesButton.frame = CGRectMake(6, TOP_BUTTONS_Y, BUTTON_SIZE, BUTTON_SIZE);
        self.exitNotesButton.frame = CGRectMake(829, TOP_BUTTONS_Y, BUTTON_SIZE, BUTTON_SIZE);
        self.clearNotesButton.frame = CGRectMake(926, TOP_BUTTONS_Y, BUTTON_SIZE, BUTTON_SIZE);
        
        if (lineDrawView){
            lineDrawView.frame = CGRectMake(0, 180, IPAD_MINI_HEIGHT, 450);
        }
        
        if (colorSegmentedControl){
            [colorSegmentedControl setFrame:CGRectMake(0, 670, IPAD_MINI_HEIGHT, 80)];
        }
        
        if (scrollView){
            scrollView.frame = CGRectMake(0, 180, IPAD_MINI_HEIGHT, 450);
        }
    } else if (self.interfaceOrientation == UIInterfaceOrientationPortrait){
        self.startNotesButton.frame = CGRectMake(6, PORTRAIT_BOTTOM_BUTTONS_Y, BUTTON_SIZE, BUTTON_SIZE);
        self.zoomInButton.frame = CGRectMake(573, PORTRAIT_BOTTOM_BUTTONS_Y, BUTTON_SIZE, BUTTON_SIZE);
        self.zoomOutButton.frame = CGRectMake(668, PORTRAIT_BOTTOM_BUTTONS_Y, BUTTON_SIZE, BUTTON_SIZE);
        self.saveNotesButton.frame = CGRectMake(6, TOP_BUTTONS_Y, BUTTON_SIZE, BUTTON_SIZE);
        self.exitNotesButton.frame = CGRectMake(573, TOP_BUTTONS_Y, BUTTON_SIZE, BUTTON_SIZE);
        self.clearNotesButton.frame = CGRectMake(668, TOP_BUTTONS_Y, BUTTON_SIZE, BUTTON_SIZE);
        
        if (colorSegmentedControl){
            [colorSegmentedControl setFrame:CGRectMake(0, 927, IPAD_MINI_WIDTH, 80)];
        }
        
        if (scrollView){
            scrollView.frame = CGRectMake(0, 180, IPAD_MINI_HEIGHT, 710); // Extending ScrollView past LineDrawView height
        }
    }
}

#pragma mark - NSURLConnection delegate Functionality

/**
 * When the NSURLConnection is complete.
 */
- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    loading = NO;
    
    // Put the received data in the imageView
    img = [[UIImage alloc]initWithData:receivedData];
    [imageView setImage:img];
    
    [imageView sizeToFit];
}

#pragma mark - Image Refresh Management
/**
 * Pulls new image from URLConnection and inserts into the UIImageView.
 */
- (void)updateImageView
{
       if(!loading) {
        // Create the request.
        NSURLRequest* theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString] 
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:60.0];
        
        // Create the connection with the request and start loading the data.
        NSURLConnection *theConnection= [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        if (theConnection) {
            receivedData = [NSMutableData data]; // Create the NSMutableData to hold the received data.
            loading = true;
        }
    }
}

#pragma mark - Zooming and Scrolling

- (void)zoomTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (isZoomedIn) {
        lineDrawView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        isZoomedIn = NO;
    } else {
        lineDrawView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        isZoomedIn = YES;
    }
}

/**
 * Helps with tap to zoom.
 */
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    
	// Choose an origin so as to get the right center.
    zoomRect.origin.x = center.x / scale;
    zoomRect.origin.y = center.y / scale;
    
	return zoomRect;
}


- (void)panMove:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        
        CGPoint translation = [gesture translationInView:self.view];
        lineDrawView.center = CGPointMake(lineDrawView.center.x + translation.x,
                                             lineDrawView.center.y + translation.y);
        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}


# pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    popover = [(UIStoryboardPopoverSegue *)segue popoverController];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (popover) {
        [popover dismissPopoverAnimated:YES];
        return NO;
    } else {
        return YES;
    }
}

# pragma mark - Button Callbacks

-(IBAction)zoomOutButtonPress:(id)sender
{
    lineDrawView.transform = CGAffineTransformMakeScale(MIN_ZOOM_SCALE, MIN_ZOOM_SCALE);
}

-(IBAction)zoomInButtonPress:(id)sender
{
    lineDrawView.transform = CGAffineTransformMakeScale(1.25, 1.25);
}

- (IBAction)backButtonPress:(id)sender
{
    if (popover) {
        [popover dismissPopoverAnimated:YES];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveButtonPress:(id)sender
{    
    // Tell the user that notes are saved
	UIAlertView* alert = [[UILargeAlertView alloc] initWithText:NSLocalizedString(@"Notes Saved!", nil) fontSize:48];
	[alert show];
}

- (IBAction)startNotesButtonPress:(id)sender
{
    self.clearNotesButton.hidden = NO;
    self.exitNotesButton.hidden = NO;
    self.zoomInButton.hidden = YES;
    self.zoomOutButton.hidden = YES;
    self.startNotesButton.hidden = YES;
    
    [self initColorSegmentedControl];
    
    lineDrawView.userInteractionEnabled = YES;
    [self.view addSubview:lineDrawView];
    
    tapToZoom.enabled = YES;
    panToMove.enabled = YES;
}

- (IBAction)exitNotesButtonPress:(id)sender
{
    [colorSegmentedControl removeFromSuperview];
    
    self.clearNotesButton.hidden = YES;
    self.exitNotesButton.hidden = YES;
    self.zoomInButton.hidden = NO;
    self.zoomOutButton.hidden = NO;
    self.startNotesButton.hidden = NO;
    
    // Disabling drawing to allow the user to scroll, zoom, or pan!
    lineDrawView.userInteractionEnabled = NO;
    
    [scrollView addSubview:lineDrawView];
    [scrollView addGestureRecognizer:panToMove];
}

- (IBAction)clearNotesButtonPress:(id)sender
{
    [lineDrawView clearAllPaths];
    
	UIAlertView* alert = [[UILargeAlertView alloc] initWithText:
                          NSLocalizedString(@"Notes Cleared!", nil) fontSize:48];
	[alert show];     // Tell the user that notes are cleared.
}

# pragma mark - ColorSegmentedControl

- (void)initColorSegmentedControl
{
    NSArray *segments = [[NSArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"Eraser", nil];
    colorSegmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
    [colorSegmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [colorSegmentedControl setTintColor:[UIColor lightGrayColor]];
    
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait){
        [colorSegmentedControl setFrame:CGRectMake(0, 927, IPAD_MINI_WIDTH, 80)];
    } else {
        [colorSegmentedControl setFrame:CGRectMake(0, 670, IPAD_MINI_HEIGHT, 80)];
    }
    
    [colorSegmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:colorSegmentedControl];
    
    // Indices change; need to set tags on the segments before rendering.
    [colorSegmentedControl setTag:RED_TAG forSegmentAtIndex:0];
    [colorSegmentedControl setTag:GREEN_TAG forSegmentAtIndex:1];
    [colorSegmentedControl setTag:BLUE_TAG forSegmentAtIndex:2];
    [colorSegmentedControl setTag:BLACK_TAG forSegmentAtIndex:3];
    [colorSegmentedControl setTag:HILIGHT_TAG forSegmentAtIndex:4];
    [colorSegmentedControl setTag:ERASER_TAG forSegmentAtIndex:5];
    
    [colorSegmentedControl setTintColor:[UIColor redColor] forTag:RED_TAG];
    [colorSegmentedControl setTintColor:[UIColor greenColor] forTag:GREEN_TAG];
    [colorSegmentedControl setTintColor:[UIColor blueColor] forTag:BLUE_TAG];
    [colorSegmentedControl setTintColor:[UIColor blackColor] forTag:BLACK_TAG];
    [colorSegmentedControl setTintColor:[UIColor yellowColor] forTag:HILIGHT_TAG];
    [colorSegmentedControl setTintColor:[UIColor whiteColor] forTag:ERASER_TAG];
}

/**
 * Called when the SegmentedControl is changed to a new color.
 */
- (void)segmentChanged:(id)sender
{
    lineDrawView.currentPath = [colorSegmentedControl selectedSegmentIndex];
}

@end