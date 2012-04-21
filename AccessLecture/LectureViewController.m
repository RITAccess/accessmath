// Copyright 2011 Access Lecture. All rights reserved.

#import "LectureViewController.h"
#import <QuartzCore/QuartzCore.h> 
#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"
#import "UILargeAlertView.h"



#define ZOOM_VIEW_TAG 100
#define MIN_ZOOM_SCALE 1.0
#define MAX_ZOOM_SCALE 20
#define SCREEN_WIDTH 768
#define TOOLBAR_HEIGHT 74
#define USERNAME @"Student"
#define PASSWORD @"lecture"

//NSString* urlString = @"https://129.21.67.216:5010/common/library/apps/Screen/out.png";
NSString* urlString = @"https://129.21.84.13:5010/common/library/apps/Screen/out.png";
float ZOOM_STEP; // The magnification-increment for the +/- icons
float oldZoomScale;

@interface LectureViewController (UtilityMethods)
/**
 * Helper method to return the new frame for a UIScrollView after zooming
 */
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end

@implementation LectureViewController

@synthesize appSettingsViewController;

/**
 Initialize the view controller by linking it to a specific xib file
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

/**
 Set up after the xib loads
 */
- (void)viewDidLoad {
    defaults = [NSUserDefaults standardUserDefaults]; 
    
    // Zoom setup
    ZOOM_STEP = [defaults floatForKey:@"userZoomIncrement"];
	zoomHandler = [[ZoomHandler alloc] initWithZoomLevel: ZOOM_STEP];
	
    /* REAL CODE 
	// Set up the imageview
    img = [[UIImage alloc] initWithData:
                    [NSData dataWithContentsOfURL:
                     [NSURL URLWithString:urlString]]];
    imageView = [[UIImageView alloc]initWithImage:img];
	imageView.userInteractionEnabled = YES;
    [imageView setTag:ZOOM_VIEW_TAG]; 
     */
    
    /***********
     * USABILITY TESTING CODE
     **********/
    img = [UIImage imageNamed:[defaults valueForKey:@"testImage"]];
    imageView = [[UIImageView alloc]initWithImage:img];
	imageView.userInteractionEnabled = YES;
    [imageView setTag:ZOOM_VIEW_TAG]; 
    /*********/
    
    /**
     * Initialize the note-taking feature
     */
    notesViewController = [[NotesViewController alloc] initWithNibName:@"NotesViewController" bundle:nil];
    [notesViewController.view addSubview:imageView]; // We draw on a copy of the imageView
    [notesViewController.view sendSubviewToBack:imageView]; // Hide it for now, since note-taking isn't active
    [notesTopToolbar setHidden:YES]; // Note-taking specific toolbar
    [notesViewController.view setHidden:NO];
    [notesViewController.segmentedControl setHidden:YES]; // The color picker
    [notesViewController.view setUserInteractionEnabled:NO];
    [self.view addSubview:notesViewController.segmentedControl];
    
    // Set up the scrollview
	scrollView.clipsToBounds = YES;	// default is NO, but we want to restrict drawing within our scrollview
	[scrollView addSubview:notesViewController.view]; // We want to scroll/zoom the note-taking view as well
    [scrollView setDelegate:self];
    [scrollView setContentMode:UIViewContentModeScaleAspectFit]; // If this is not set, the image will be distorted
    [scrollView setContentSize:CGSizeMake(notesViewController.view.frame.size.width,notesViewController.view.frame.size.width)];
	[scrollView setScrollEnabled:YES];
    [scrollView setMinimumZoomScale:MIN_ZOOM_SCALE];
    [scrollView setZoomScale:MIN_ZOOM_SCALE];
    [scrollView setMaximumZoomScale:MAX_ZOOM_SCALE];
	scrollView.bounces = FALSE;
	scrollView.bouncesZoom = FALSE;
    
    /***********
     * USABILITY TESTING CODE
     **********/
    [notesViewController.view setFrame:CGRectMake(0, 0,
                                                  img.size.width * [scrollView zoomScale],img.size.height * [scrollView zoomScale])];
    [notesViewController.imageView setFrame:CGRectMake(0, 0,
                                                       img.size.width * [scrollView zoomScale],img.size.height *[scrollView zoomScale])];
    [imageView sizeToFit];
	[scrollView setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
    /*********/
        
    // Set up the navigation controller
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
} 

/**
 Gets called at launch & every time the settings are updated
 */
-(void)settingsChange {

    // Toolbar transparency
    bottomToolbar.alpha = 1 - [defaults floatForKey:@"toolbarAlpha"];
    topToolbar.alpha = 1 - [defaults floatForKey:@"toolbarAlpha"];
    notesTopToolbar.alpha = 1 - [defaults floatForKey:@"toolbarAlpha"];
    
    if ([defaults floatForKey:@"toolbarAlpha"] != 0.0) {
        // Toolbars are partially transparent
        scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    } else {
        // Toolbars are completely solid
        scrollView.frame = CGRectMake(0, TOOLBAR_HEIGHT, SCREEN_WIDTH, self.view.frame.size.height-(TOOLBAR_HEIGHT * 2));
    }
    
    // Toolbar colors
    float toolRed = [defaults floatForKey:@"tbRed"];
    float toolGreen = [defaults floatForKey:@"tbGreen"];
    float toolBlue = [defaults floatForKey:@"tbBlue"];
    [topToolbar setBackgroundColor:[UIColor colorWithRed:toolRed green:toolGreen blue:toolBlue alpha:1.0]];
    [notesTopToolbar setBackgroundColor:[UIColor colorWithRed:toolRed green:toolGreen blue:toolBlue alpha:1.0]];
    [bottomToolbar setBackgroundColor:[UIColor colorWithRed:toolRed green:toolGreen blue:toolBlue alpha:1.0]];
    
    // Text colors
    float textRed = [defaults floatForKey:@"textRed"];
    float textGreen = [defaults floatForKey:@"textGreen"];
    float textBlue = [defaults floatForKey:@"textBlue"];
    toolbarLabel.textColor = [UIColor colorWithRed:textRed green:textGreen blue:textBlue alpha:1.0];
    notesTopToolbarLabel.textColor = [UIColor colorWithRed:textRed green:textGreen blue:textBlue alpha:1.0];
    
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

/**
 * Open the IASKAppSettingsViewController (settings page)
 */
-(IBAction)openSettings:(id)sender {
    [self.navigationController pushViewController:self.appSettingsViewController animated:YES];
}

#pragma mark -
#pragma mark Note-Taking Methods

/**
 * Opens the note-taking feature
 */
-(IBAction)openNotes:(id)sender {
    // Zoom the user all the way out when they enter note-taking mode
    oldZoomScale = scrollView.zoomScale;
    [self resetImageZoom:nil];
    // Disable zooming back in
    [scrollView setMaximumZoomScale:MIN_ZOOM_SCALE];
    
    // Swap the toolbars
    [topToolbar setHidden:YES];
    [bottomToolbar setHidden:YES];
    [notesViewController.segmentedControl setHidden:NO];
    [notesTopToolbar setHidden:NO];
    
    // Force the ScrollView to require 2 fingers to scroll
    // while in note-taking mode
    [scrollViewPanGesture setMinimumNumberOfTouches:2];
    [scrollViewPanGesture setMaximumNumberOfTouches:2];
    [notesViewController.view setUserInteractionEnabled:YES];
    
    // Maintain an appropriate content size
    if ([defaults floatForKey:@"toolbarAlpha"] != 0.0) {
        // Toolbars are partially transparent
        scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-TOOLBAR_HEIGHT);
    } else {
        // Toolbars are completely solid
        scrollView.frame = CGRectMake(0, TOOLBAR_HEIGHT, SCREEN_WIDTH, self.view.frame.size.height-(TOOLBAR_HEIGHT * 2));
    }
}

/**
 * Close the note-taking feature
 */
-(IBAction)closeNotes:(id)sender {
    
    [scrollView setMaximumZoomScale:MAX_ZOOM_SCALE];
    [scrollView setZoomScale:oldZoomScale animated:YES];
    [notesViewController.segmentedControl setHidden:YES];
    [notesTopToolbar setHidden:YES];
    [topToolbar setHidden:NO];
    [bottomToolbar setHidden:NO];
    [scrollViewPanGesture setMinimumNumberOfTouches:1];
    [scrollViewPanGesture setMaximumNumberOfTouches:1];
    [notesViewController.view setUserInteractionEnabled:NO];
    
    if ([defaults floatForKey:@"toolbarAlpha"] != 0.0) {
        // Toolbars are partially transparent
        scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    } else {
        // Toolbars are completely solid
        scrollView.frame = CGRectMake(0, TOOLBAR_HEIGHT, SCREEN_WIDTH, self.view.frame.size.height-(TOOLBAR_HEIGHT * 2));
    }
}

/**
 Clears the user notes
 */
-(IBAction)clearButton:(id)sender {
    notesViewController.imageView.image = nil;
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
 In case there's a memory warning
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 Release resources from memory
 */

/**
 View is unloaded
 */
- (void)viewDidUnload {
    
    [t invalidate];
    bottomToolbar = nil;
    topToolbar = nil;
    [super viewDidUnload];
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

/**
 When the NSURLConnection is complete
 */
- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    loading = false;
    
    // Put the received data in the imageView
    img = [[UIImage alloc]initWithData:receivedData];
    [imageView setImage:img];
    
    // Set the size of the drawing views
    [notesViewController.view setFrame:CGRectMake(0, 0,
                                img.size.width * [scrollView zoomScale],img.size.height * [scrollView zoomScale])];
    [notesViewController.imageView setFrame:CGRectMake(0, 0,
                                img.size.width * [scrollView zoomScale],img.size.height *[scrollView zoomScale])];
    //NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    [imageView sizeToFit];
	[scrollView setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
    if (shouldSnapToZoom) {
        shouldSnapToZoom = NO;
        [scrollView setZoomScale:MIN_ZOOM_SCALE];
    }
    
    // Release the connection, and the data object
}

/**
 When the NSURLConnection receives and authentication challenge
 */
-(void)connection:(NSURLConnection*)connection didReceiveAuthenticationChallenge:

    (NSURLAuthenticationChallenge*)challenge {
    
    //NSLog(@"Received Challenge");
    if ([[challenge protectionSpace]authenticationMethod] == NSURLAuthenticationMethodServerTrust) {
       
        // Needs certificate confirmation
        [[challenge sender] useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];  
    } else {
       
        // Needs login information
        NSURLCredential *newCredential;
        newCredential = [NSURLCredential credentialWithUser:USERNAME
                                                   password:PASSWORD
                                                persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
    }
}

/**
 When the NSURLConnection fails to load
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*) error {
    
    // release the connection, and the data object
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);

}

/**
 When the NSURLConnection receives a responde
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*) response {
    [receivedData setLength:0];
    //NSLog(@"Got Response");
}

/**
 If data is received from the NSURLConnection being made
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*) data {
    [receivedData appendData:data];
    //NSLog(@"Got Data");
}

/**
 Tells the NSURLConnection that authentication is possible
 */
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return YES;
}

#pragma mark -
#pragma mark Image Refresh Management
/**
 Grabs the new image of the lecture and replaces it in the imageview
 */
- (void)updateImageView {
  
    if(!loading) {
       
        // Create the request.
        NSURLRequest* theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString] 
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:60.0];
        
        // Create the connection with the request and start loading the data
        NSURLConnection *theConnection= [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        if (theConnection) {
            // Create the NSMutableData to hold the received data.
            receivedData = [NSMutableData data];
            loading = true;
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate protocol
/**
 Required scrollview delegate method
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sv {
	return [sv viewWithTag:ZOOM_VIEW_TAG];
    //return notesViewController.view;
}
- (void)scrollViewDidZoom:(UIScrollView *)sv {
    [notesViewController.view setFrame:CGRectMake(0, 0,
                                                  img.size.width * [scrollView zoomScale],img.size.height * [scrollView zoomScale])];
    [notesViewController.imageView setFrame:CGRectMake(0, 0,
                                                       img.size.width * [scrollView zoomScale],img.size.height *[scrollView zoomScale])];
    //int newPenRadius = scrollView.zoomScale * notesViewController.penRadius;
    //[notesViewController setPenRadius:newPenRadius];
}

/**
 Required scrollview delegate method
 */
- (void)scrollViewDidEndZooming:(UIScrollView *)sv withView:(UIView *)view atScale:(float)scale {
    [sv setZoomScale:scale+0.01 animated:NO];
    [sv setZoomScale:scale animated:NO];
}

#pragma mark -
#pragma mark Zooming methods

/**
 Resetting the scrollView to be completely zoomed out
 */
-(void)resetImageZoom: (UIGestureRecognizer *)gestureRecognizer {
    [scrollView setZoomScale:1.0 animated:YES];
}

/**
 A helper function for zooming by tapping
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

/**
 Function for the scrollview to be able to zoom out
 **/
-(IBAction)zoomOut {
    if([scrollView zoomScale] > [scrollView minimumZoomScale]) {
        float newScale = [scrollView zoomScale] / ZOOM_STEP;
        [self handleZoomWith:newScale andZoomType: FALSE];
    }
}

/**
 Function for the scrollview to be able to zoom in
 **/
-(IBAction)zoomIn {
	float newScale = [scrollView zoomScale] * ZOOM_STEP;
    
    if(newScale <= [scrollView maximumZoomScale]){
        [self handleZoomWith:newScale andZoomType: TRUE];
    }
}

-(void)handleZoomWith: (float) newScale andZoomType:(BOOL) isZoomIn {
   
    CGPoint newOrigin = [zoomHandler getNewOriginFromViewLocation: [scrollView contentOffset] 
														 viewSize: scrSize andZoomType: isZoomIn];
	CGRect zoomRect = [self zoomRectForScale:newScale withCenter:newOrigin];
    [scrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol

/**
 Constructor for an appSettingsViewController
 */
- (IASKAppSettingsViewController*)appSettingsViewController {
	
    if (!appSettingsViewController) {
		appSettingsViewController = [[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView" bundle:nil];
		appSettingsViewController.delegate = self;
	}
    
	return appSettingsViewController;
}

/**
 Required inAppSettingsViewController delegate method
 */
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self dismissModalViewControllerAnimated:YES];
	self.navigationController.navigationBarHidden = YES;
}

@end