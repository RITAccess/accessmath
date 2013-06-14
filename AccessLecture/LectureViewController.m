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
#define TOOLBAR_HEIGHT 74
#define USERNAME @"Student"
#define PASSWORD @"lecture"

NSString* urlString = @"http://michaeltimbrook.com/common/library/apps/Screen/test.png";

float ZOOM_STEP; // The magnification-increment for the +/- icons
float oldZoomScale;

@interface LectureViewController (UtilityMethods)
/**
 * Helper method to return the new frame for a UIScrollView after zooming
 */
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end

@implementation LectureViewController {
    __weak UIPopoverController *popover;
}

- (void)viewDidLoad {
    defaults = [NSUserDefaults standardUserDefaults];
    
    // Zoom Setup
    ZOOM_STEP = [defaults floatForKey:@"userZoomIncrement"];
	zoomHandler = [[ZoomHandler alloc] initWithZoomLevel: ZOOM_STEP];
	
	// ImageView Setup
    img = [[UIImage alloc] initWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    imageView = [[UIImageView alloc]initWithImage:img];
	imageView.userInteractionEnabled = YES;
    [imageView setTag:ZOOM_VIEW_TAG];
    // img = [UIImage imageWithData:[AccessLectureRuntime defaultRuntime].currentDocument.lecture.image];
    //    imageView = [[UIImageView alloc]initWithImage:img];
    //	imageView.userInteractionEnabled = YES;
    //    [imageView setTag:ZOOM_VIEW_TAG];
    
    // ScrollView Setup
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 180, 1024, 468)];
	scrollView.clipsToBounds = YES;	// default is NO, but we want to restrict drawing within our scrollview
    [scrollView setDelegate:self];
    [scrollView setContentMode:UIViewContentModeScaleAspectFit]; // If this is not set, the image will be distorted
	[scrollView setScrollEnabled:YES];
    [scrollView setMinimumZoomScale:MIN_ZOOM_SCALE];
    [scrollView setZoomScale:MIN_ZOOM_SCALE];
    [scrollView setMaximumZoomScale:MAX_ZOOM_SCALE];
	scrollView.bounces = FALSE;
	scrollView.bouncesZoom = FALSE;
    scrollView.backgroundColor = [UIColor lightGrayColor]; // Testing Purposes
    [self.view addSubview:scrollView];

    shouldSnapToZoom = YES;

    // Get the scrollView's pan gesture and store it for later use
    for (UIGestureRecognizer* rec in scrollView.gestureRecognizers) {
        if ([rec isKindOfClass:[UIPanGestureRecognizer class]]) {
            scrollViewPanGesture = (UIPanGestureRecognizer*)rec;
        }
    }
	
	// Get the screen resolution of the iPad and subtract the height of the toolbars (2* 74)
	screenSize = CGPointMake(scrollView.frame.size.width,scrollView.frame.size.height - (TOOLBAR_HEIGHT * 2) );
    
    // Observe NSUserDefaults for setting changes
    // Will automatically call settingsChanged: when approproiate
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChange) name:NSUserDefaultsDidChangeNotification object:nil];
    
    // Completely zoom out when user double taps with two fingers
    UITapGestureRecognizer *fullZoomOutRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetImageZoom:)];
    [fullZoomOutRecognizer setNumberOfTapsRequired:2];
    [fullZoomOutRecognizer setNumberOfTouchesRequired:2];
    [scrollView addGestureRecognizer:fullZoomOutRecognizer];
    
    // LineDrawView setup
    lineDrawView = [[LineDrawView alloc]initWithFrame:CGRectMake(0, 180, 1024, 468)];
    
    // Apply the stored settings
    [self settingsChange];
    
    [super viewDidLoad];
}

/**
 * In case there's a memory warning.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setClearNotesButton:nil];
    [self setZoomOutButton:nil];
    [self setZoomInButton:nil];
    [self setStartNotesButton:nil];
    [super viewDidUnload];
}

/**
 * Gets called at launch & every time the settings are updated.
 */
-(void)settingsChange {
    // Scrolling speed
    scrollView.decelerationRate = [defaults floatForKey:@"userScrollSpeed"];
    
    // Zoom increment 
    ZOOM_STEP = ([defaults floatForKey:@"userZoomIncrement"] * 100);
    [zoomHandler setZoomLevel:ZOOM_STEP];
    
    // Active usability testing image
    img = [UIImage imageNamed:[defaults valueForKey:@"testImage"]];
    [imageView setImage:img];
    
    
    // Hide Clear Button on Start
    self.clearNotesButton.hidden = YES;
    
    // Initialize Zoom check, will flip when zoomed in
    isZoomedIn = NO;
}

/**
 * Get a screenshot of a ScrollView's content.
 */
- (UIImage *)imageByCropping:(UIScrollView *)imageToCrop toRect:(CGRect)rect {
    imageToCrop.clipsToBounds = NO;
    CGSize pageSize = rect.size;
    UIGraphicsBeginImageContext(pageSize);
    
    [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    imageToCrop.clipsToBounds = YES;
    
    return image;
}


#pragma mark - Rotation Handling

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (lineDrawView != NULL){
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
            lineDrawView.frame = CGRectMake(0, 180, 1024, 468);
        }
    }
    
    if (scrollView != NULL){
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
            scrollView.frame = CGRectMake(0, 180, 1024, 468);
        }
    }
    
    if (colorSegmentedControl != NULL){
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
            [colorSegmentedControl setFrame:CGRectMake(0, 670, 1024, 80)];
        } else if (self.interfaceOrientation == UIInterfaceOrientationPortrait){
            [colorSegmentedControl setFrame:CGRectMake(0, 927, 768, 80)];
        }
    }
}

/**
 * Save a screenshot of the current notes to the iPad Photo Album
 */
-(IBAction)saveButton:(id)sender {
    UIImage *saveImage;
    
    // Take the screenshot
    saveImage = [self imageByCropping:scrollView toRect:imageView.frame];
    
    // Adds a photo to the saved photos album.  The optional completionSelector should have the form:
    UIImageWriteToSavedPhotosAlbum(saveImage, nil, nil, nil);
    //Save document with current image to user documents directory
 
       NSURL * currentDirectory = [FileManager iCloudDirectoryURL];
    if (currentDirectory == nil) currentDirectory = [FileManager localDocumentsDirectoryURL];
    NSArray * docs = [FileManager documentsIn:currentDirectory];
    NSURL * document = [FileManager findFileIn:docs thatFits:^(NSURL* url){
        if (url != nil) return YES;
        return NO;
    }];
    
    currentDocument = [[AccessDocument alloc] initWithFileURL:document];
    currentLecture.image = UIImagePNGRepresentation(saveImage);
    currentDocument.lecture = currentLecture;
    
    // Tell the user that notes are saved
	UIAlertView* alert = [[UILargeAlertView alloc]
                          initWithText:NSLocalizedString(@"Notes Saved!", nil)
                          fontSize:48];
	[alert show];
}

#pragma mark - NSURLConnection delegate Functionality

/**
 * When the NSURLConnection is complete.
 */
- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    loading = false;
    
    // Put the received data in the imageView
    img = [[UIImage alloc]initWithData:receivedData];
    [imageView setImage:img];
    
    [imageView sizeToFit];
	[scrollView setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
    if (shouldSnapToZoom) {
        shouldSnapToZoom = NO;
        [scrollView setZoomScale:MIN_ZOOM_SCALE];
    }
}

#pragma mark - Image Refresh Management
/**
 * Pulls new image from URLConnection and inserts into the UIImageView.
 */
- (void)updateImageView {
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

#pragma mark - UIScrollViewDelegate Protocol

/**
 * Required ScrollView delegate method.
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sv
{
	return [sv viewWithTag:ZOOM_VIEW_TAG];
}

- (void)scrollViewDidZoom:(UIScrollView *)sv
{
    //int newPenRadius = scrollView.zoomScale * notesViewController.penRadius;
    //[notesViewController setPenRadius:newPenRadius];
}

/**
 * Required scrollview delegate method.
 */
- (void)scrollViewDidEndZooming:(UIScrollView *)sv withView:(UIView *)view atScale:(float)scale {
    [sv setZoomScale:scale+0.01 animated:NO];
    [sv setZoomScale:scale animated:NO];
}

#pragma mark - Zooming 

/**
 Resetting the scrollView to be completely zoomed out
 */
-(void)resetImageZoom: (UIGestureRecognizer *)gestureRecognizer {
    [scrollView setZoomScale:1.0 animated:YES];
}

/**
 * Helps with tap to zoom.
 */
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    
	//	At a zoom scale of 1.0, it would be the size of the scrollView's bounds.
	//	As the zoom scale decreases, so more content is visible, the size of the rect grows.
	zoomRect.size.height = [scrollView frame].size.height / scale;
	zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
	// Choose an origin so as to get the right center.
    zoomRect.origin.x = center.x / scale;
    zoomRect.origin.y = center.y / scale;
    
	return zoomRect;
}

-(void)handleZoomWith:(float)newScale andZoomType:(BOOL)isZoomIn {
    CGPoint newOrigin = [zoomHandler getNewOriginFromViewLocation: [scrollView contentOffset]
														 viewSize: screenSize andZoomType: isZoomIn];
	CGRect zoomRect = [self zoomRectForScale:newScale withCenter:newOrigin];
    [scrollView zoomToRect:zoomRect animated:YES];
}


# pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    popover = [(UIStoryboardPopoverSegue *)segue popoverController];
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (popover) {
        [popover dismissPopoverAnimated:YES];
        return NO;
    } else {
        return YES;
    }
}

# pragma mark - Button Callbacks

/**
 * Manages ScrollView zooming out.
 */
-(IBAction)zoomOutButtonPress:(id)sender {
    lineDrawView.transform = CGAffineTransformMakeScale(MIN_ZOOM_SCALE, MIN_ZOOM_SCALE);
    
    if([scrollView zoomScale] > [scrollView minimumZoomScale]) {
        float newScale = [scrollView zoomScale] / ZOOM_STEP;
        [self handleZoomWith:newScale andZoomType: FALSE];
    }
}

/**
 * Manages ScrollView zooming in.
 */
-(IBAction)zoomInButtonPress:(id)sender {
    //    [scrollView addSubview:lineDrawView]; // We want to scroll/zoom the note-taking view as well
    //    [self.view addSubview:scrollView];
    lineDrawView.transform = CGAffineTransformMakeScale(1.25, 1.25);
    
	float newScale = [scrollView zoomScale] * ZOOM_STEP;
    if(newScale <= [scrollView maximumZoomScale]){
        [self handleZoomWith:newScale andZoomType: TRUE];
    }
}

- (IBAction)backButtonPress:(id)sender {
    if (popover) {
        [popover dismissPopoverAnimated:YES];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveButtonPress:(id)sender {
    // Take the screenshot
    UIImage *saveImage = [self imageByCropping:scrollView toRect:imageView.frame];
    
    // Adds a photo to the saved photos album.  The optional completionSelector should have the form:
    UIImageWriteToSavedPhotosAlbum(saveImage, nil, nil, nil);
    
    // Tell the user that notes are saved
	UIAlertView* alert = [[UILargeAlertView alloc] initWithText:NSLocalizedString(@"Notes Saved!", nil) fontSize:48];
	[alert show];
}

- (IBAction)startNotesButtonPress:(id)sender {
    self.clearNotesButton.hidden = NO;
    self.zoomInButton.hidden = YES;
    self.zoomOutButton.hidden = YES;
    self.startNotesButton.hidden = YES;
    
    // Zoom the user all the way out when they enter note-taking mode
    oldZoomScale = scrollView.zoomScale;
    [self resetImageZoom:nil];

    [scrollView setMaximumZoomScale:MIN_ZOOM_SCALE];     // Disable zooming back in
    
    // Force the ScrollView to require 2 fingers to scroll while in note-taking mode
    [scrollViewPanGesture setMinimumNumberOfTouches:2];
    [scrollViewPanGesture setMaximumNumberOfTouches:2];
    
    [self initColorSegmentedControl];
    
    [self.view addSubview:lineDrawView];
    
    UITapGestureRecognizer* tapToZoom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn:)];
    tapToZoom.numberOfTapsRequired = 2;
    [tapToZoom setEnabled:YES];
    [self.view addGestureRecognizer:tapToZoom];
}

- (IBAction)clearNotesButtonPress:(id)sender {
    // Tell the user that notes are cleared.
	UIAlertView* alert = [[UILargeAlertView alloc] initWithText:NSLocalizedString(@"Exit Drawing!", nil) fontSize:48];
	[alert show];
    
    [colorSegmentedControl removeFromSuperview];
    
    self.clearNotesButton.hidden = YES;
    self.zoomInButton.hidden = NO;
    self.zoomOutButton.hidden = NO;
    self.startNotesButton.hidden = NO;
    
    [scrollView setMaximumZoomScale:MAX_ZOOM_SCALE];
    [scrollView setZoomScale:oldZoomScale animated:YES];
    [scrollViewPanGesture setMinimumNumberOfTouches:1];
    [scrollViewPanGesture setMaximumNumberOfTouches:1];
}

# pragma mark - ColorSegmentedControl

- (void)initColorSegmentedControl {
    NSArray *segments = [[NSArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"Eraser", nil];
    colorSegmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
    [colorSegmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [colorSegmentedControl setTintColor:[UIColor lightGrayColor]];
    
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait){
        [colorSegmentedControl setFrame:CGRectMake(0, 927, 768, 80)];
    } else {
        [colorSegmentedControl setFrame:CGRectMake(0, 670, 1024, 80)];
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
-(void)segmentChanged:(id)sender {
    lineDrawView.currentPath = [colorSegmentedControl selectedSegmentIndex];
}

@end