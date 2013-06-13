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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    defaults = [NSUserDefaults standardUserDefaults];
    
    // Zoom setup
    ZOOM_STEP = [defaults floatForKey:@"userZoomIncrement"];
	zoomHandler = [[ZoomHandler alloc] initWithZoomLevel: ZOOM_STEP];
	
	// Set up the imageview
    img = [[UIImage alloc] initWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    imageView = [[UIImageView alloc]initWithImage:img];
	imageView.userInteractionEnabled = YES;
    [imageView setTag:ZOOM_VIEW_TAG]; 
    
    // Set up the scrollview
//	scrollView.clipsToBounds = YES;	// default is NO, but we want to restrict drawing within our scrollview
//	[scrollView addSubview:notesViewController.view]; // We want to scroll/zoom the note-taking view as well
//    [scrollView setDelegate:self];
//    [scrollView setContentMode:UIViewContentModeScaleAspectFit]; // If this is not set, the image will be distorted
//    [scrollView setContentSize:CGSizeMake(notesViewController.view.frame.size.width,notesViewController.view.frame.size.width)];
//	[scrollView setScrollEnabled:YES];
//    [scrollView setMinimumZoomScale:MIN_ZOOM_SCALE];
//    [scrollView setZoomScale:MIN_ZOOM_SCALE];
//    [scrollView setMaximumZoomScale:MAX_ZOOM_SCALE];
//	scrollView.bounces = FALSE;
//	scrollView.bouncesZoom = FALSE;
    
    // img = [UIImage imageWithData:[AccessLectureRuntime defaultRuntime].currentDocument.lecture.image];
    imageView = [[UIImageView alloc]initWithImage:img];
	imageView.userInteractionEnabled = YES;
    [imageView setTag:ZOOM_VIEW_TAG];
    /*********/

    self.navigationController.navigationBarHidden = YES;

    /* 
     * Timer Setup.
     * Update the imageView with a screenshot of the Mac
     */
    shouldSnapToZoom = YES;
    /* REAL CODE
    t = [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(updateImageView)
                                       userInfo:nil
                                        repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:t forMode: NSDefaultRunLoopMode];
     */

    // Get the scrollView's pan gesture and store it for later use

    for (UIGestureRecognizer* rec in scrollView.gestureRecognizers) {
        if ([rec isKindOfClass:[UIPanGestureRecognizer class]]) {
            scrollViewPanGesture = (UIPanGestureRecognizer*)rec;
        }
    }
	
	// Get the screen resolution of the iPad and subtract the height of the toolbars (2* 74)
    // This is the actual screen size we have to work with when displaying content
	scrSize = CGPointMake(scrollView.frame.size.width,scrollView.frame.size.height - (TOOLBAR_HEIGHT * 2) );
    
    // Observe NSUserDefaults for setting changes
    // Will automatically call settingsChanged: when approproiate
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChange) name:NSUserDefaultsDidChangeNotification object:nil];
    
    // Completely zoom out when user double taps with two fingers
    UITapGestureRecognizer *fullZoomOutRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetImageZoom:)];
    [fullZoomOutRecognizer setNumberOfTapsRequired:2];
    [fullZoomOutRecognizer setNumberOfTouchesRequired:2];
    [scrollView addGestureRecognizer:fullZoomOutRecognizer];
    
    // Apply the stored settings
    [self settingsChange];
    
    [super viewDidLoad];
    
    self.clearNotesButton.hidden = YES; // Hide Clear Button on Start
}

/**
 * Gets called at launch & every time the settings are updated.
 */
-(void)settingsChange {

    
    if ([defaults floatForKey:@"toolbarAlpha"] != 0.0) {
        // Toolbars are partially transparent
        scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    } else {
        // Toolbars are completely solid
        scrollView.frame = CGRectMake(0, TOOLBAR_HEIGHT, SCREEN_WIDTH, self.view.frame.size.height-(TOOLBAR_HEIGHT * 2));
    }
    
    // Scrolling speed
    scrollView.decelerationRate = [defaults floatForKey:@"userScrollSpeed"];
    
    // Zoom increment 
    ZOOM_STEP = ([defaults floatForKey:@"userZoomIncrement"] * 100);
    [zoomHandler setZoomLevel:ZOOM_STEP];
    
    // Active usability testing image
    img = [UIImage imageNamed:[defaults valueForKey:@"testImage"]];
    [imageView setImage:img];
}

/**
 Get a screenshot of a scrollviews content
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

#pragma mark - Note-Taking


/**
 * Close the note-taking feature.
 */
-(IBAction)closeNotes:(id)sender
{    
    [scrollView setMaximumZoomScale:MAX_ZOOM_SCALE];
    [scrollView setZoomScale:oldZoomScale animated:YES];
    [scrollViewPanGesture setMinimumNumberOfTouches:1];
    [scrollViewPanGesture setMaximumNumberOfTouches:1];
    
    if ([defaults floatForKey:@"toolbarAlpha"] != 0.0) {
        // Toolbars are partially transparent
        scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    } else {
        // Toolbars are completely solid
        scrollView.frame = CGRectMake(0, TOOLBAR_HEIGHT, SCREEN_WIDTH, self.view.frame.size.height-(TOOLBAR_HEIGHT * 2));
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    if (lineDrawView != NULL){
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
            lineDrawView.frame = CGRectMake(0, 180, 1024, 468);
        }
    }
    
    if (colors != NULL){
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
            [colors setFrame:CGRectMake(0, 670, 1024, 80)];
        } else if (self.interfaceOrientation == UIInterfaceOrientationPortrait){
            [colors setFrame:CGRectMake(0, 927, 768, 80)];
        }
        
    }
}

/**
 * Returns to the previous screen by popping the top of the controller stack
 */
-(IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 Save a screenshot of the current notes to the iPad Photo Album
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
    // [AccessLectureRuntime defaultRuntime].currentDocument.lecture.image =UIImagePNGRepresentation(saveImage);
//    [[AccessLectureRuntime defaultRuntime].currentDocument saveToURL:document
//              forSaveOperation:UIDocumentSaveForCreating
//             completionHandler:^(BOOL success) {
//                 if (success){
//                     NSLog(@"Saved for overwriting");
//                 } else {
//                     NSLog(@"Not saved for overwriting");
//                 }
//             }];
    // Tell the user that notes are saved
	UIAlertView* alert = [[UILargeAlertView alloc]
                          initWithText:NSLocalizedString(@"Notes Saved!", nil)
                          fontSize:48];
	[alert show];
 
}

/**
 Do we want the application to be rotateable? Return YES or NO
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Only support portrait
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

/**
 * In case there's a memory warning.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [t invalidate];
    [self setClearNotesButton:nil];
    [self setZoomOutButton:nil];
    [self setZoomInButton:nil];
    [super viewDidUnload];
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
    
    // Release the connection, and the data object
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
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
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

/**
 * Manages ScrollView zooming out.
 */
-(IBAction)zoomOutButtonPress:(id)sender
{
    if([scrollView zoomScale] > [scrollView minimumZoomScale]) {
        float newScale = [scrollView zoomScale] / ZOOM_STEP;
        [self handleZoomWith:newScale andZoomType: FALSE];
    }
}

/**
 * Manages ScrollView zooming in.
 */
-(IBAction)zoomInButtonPress:(id)sender
{
    lineDrawView.transform = CGAffineTransformMakeScale(1.05, 1.05);
    
	float newScale = [scrollView zoomScale] * ZOOM_STEP;
    if(newScale <= [scrollView maximumZoomScale]){
        [self handleZoomWith:newScale andZoomType: TRUE];
    }
}

-(void)handleZoomWith:(float)newScale andZoomType:(BOOL)isZoomIn
{
    CGPoint newOrigin = [zoomHandler getNewOriginFromViewLocation: [scrollView contentOffset]
														 viewSize: scrSize andZoomType: isZoomIn];
	CGRect zoomRect = [self zoomRectForScale:newScale withCenter:newOrigin];
    [scrollView zoomToRect:zoomRect animated:YES];
}

# pragma mark - Buttons

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    popover = [(UIStoryboardPopoverSegue *)segue popoverController];
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (popover) {
        [popover dismissPopoverAnimated:YES];
        return NO;
    } else {
        return YES;
    }
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
    // Take the screenshot
    UIImage *saveImage = [self imageByCropping:scrollView toRect:imageView.frame];
    
    // Adds a photo to the saved photos album.  The optional completionSelector should have the form:
    UIImageWriteToSavedPhotosAlbum(saveImage, nil, nil, nil);
    
    // Tell the user that notes are saved
	UIAlertView* alert = [[UILargeAlertView alloc] initWithText:NSLocalizedString(@"Notes Saved!", nil) fontSize:48];
	[alert show];
}

- (IBAction)startNotesButtonPress:(id)sender
{
    self.clearNotesButton.hidden = NO;
    self.zoomInButton.hidden = YES;
    self.zoomOutButton.hidden = YES;
    [sender setHidden:YES];
    
    // Zoom the user all the way out when they enter note-taking mode
    oldZoomScale = scrollView.zoomScale;
    [self resetImageZoom:nil];
    // Disable zooming back in
    [scrollView setMaximumZoomScale:MIN_ZOOM_SCALE];
    
    // Force the ScrollView to require 2 fingers to scroll
    // while in note-taking mode
    [scrollViewPanGesture setMinimumNumberOfTouches:2];
    [scrollViewPanGesture setMaximumNumberOfTouches:2];
    
    // Maintain an appropriate content size
    if ([defaults floatForKey:@"toolbarAlpha"] != 0.0) {
        // Toolbars are partially transparent
        scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-TOOLBAR_HEIGHT);
    } else {
        // Toolbars are completely solid
        scrollView.frame = CGRectMake(0, TOOLBAR_HEIGHT, SCREEN_WIDTH, self.view.frame.size.height-(TOOLBAR_HEIGHT * 2));
    }
    
    lineDrawView=[[LineDrawView alloc]initWithFrame:CGRectMake(0, 180, 1024, 468)];
    
    [self.view addSubview:lineDrawView];
    
    
    NSArray *segments = [[NSArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"Eraser", nil];
    colors = [[UISegmentedControl alloc] initWithItems:segments];
    [colors setSegmentedControlStyle:UISegmentedControlStyleBar];
    [colors setTintColor:[UIColor lightGrayColor]];
    
    
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait){
        [colors setFrame:CGRectMake(0, 927, 768, 80)];
    } else {
        [colors setFrame:CGRectMake(0, 670, 1024, 80)];
    }

    [colors addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:colors];
    
    
    // at some point later, the segment indexes change, so
    // must set tags on the segments before they render
    [colors setTag:RED_TAG forSegmentAtIndex:0];
    [colors setTag:GREEN_TAG forSegmentAtIndex:1];
    [colors setTag:BLUE_TAG forSegmentAtIndex:2];
    [colors setTag:BLACK_TAG forSegmentAtIndex:3];
    [colors setTag:HILIGHT_TAG forSegmentAtIndex:4];
    [colors setTag:ERASER_TAG forSegmentAtIndex:5];
    
    [colors setTintColor:[UIColor redColor] forTag:RED_TAG];
    [colors setTintColor:[UIColor greenColor] forTag:GREEN_TAG];
    [colors setTintColor:[UIColor blueColor] forTag:BLUE_TAG];
    [colors setTintColor:[UIColor blackColor] forTag:BLACK_TAG];
    [colors setTintColor:[UIColor yellowColor] forTag:HILIGHT_TAG];
    [colors setTintColor:[UIColor whiteColor] forTag:ERASER_TAG];
}


- (IBAction)clearNotesButtonPress:(id)sender
{
    [lineDrawView.bezierPath removeAllPoints];
    [lineDrawView.bezierPath2 removeAllPoints];
    [lineDrawView.bezierPath3 removeAllPoints];
    [lineDrawView.bezierPath4 removeAllPoints];
    [lineDrawView.bezierPath5 removeAllPoints];
    
    // Tell the user that notes are cleared.
	UIAlertView* alert = [[UILargeAlertView alloc] initWithText:NSLocalizedString(@"Notes Cleared!", nil) fontSize:48];
	[alert show];
}

/**
 * Called when the SegmentedControl is changed to a new color.
 */
-(void)segmentChanged:(id)sender
{
    lineDrawView.currentPath = [colors selectedSegmentIndex];
}

@end