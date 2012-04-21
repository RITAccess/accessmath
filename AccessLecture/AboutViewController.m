//  Copyright 2011 Access Lecture. All rights reserved.

#import "AboutViewController.h"

#define ZOOM_STEP 1.5
#define MINIMUM_ZOOM_SCALE 1.5

@implementation AboutViewController

/**
 Init with a specific xib file
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

/**
 Deallocate memory
 */

/**
 Memory management problem
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 * Returns to the previous screen by popping the top of the controller stack
 */
-(IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle
/**
 When view is loaded
 */
- (void)viewDidLoad {
    
    // Scrollview set up
    scrollView = (UIScrollView*)self.view;
    [scrollView setContentMode:UIViewContentModeScaleAspectFit];
    [scrollView setScrollEnabled:YES];
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:10.0];
	scrollView.bounces = FALSE;
	scrollView.bouncesZoom = FALSE;
    
    // Completely zoom out when user double taps
    UITapGestureRecognizer *fullZoomOutRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetImageZoom:)];
    [fullZoomOutRecognizer setNumberOfTapsRequired:2];
    [fullZoomOutRecognizer setNumberOfTouchesRequired:2];
    [scrollView addGestureRecognizer:fullZoomOutRecognizer];
    
    [super viewDidLoad];
}

/**
 Resetting the scrollView to be completely zoomed out
 */
-(void)resetImageZoom: (UIGestureRecognizer *)gestureRecognizer {
    [scrollView setZoomScale:1.0 animated:YES];
}

/**
 When view is unloaded
 */
- (void)viewDidUnload {
    scrollView = nil;
    mainView = nil;
    [super viewDidUnload];
}

/**
 Should the application be rotatable?
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
    // Only support portrait
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);

}

#pragma mark -
#pragma mark UIScrollViewDelegate protocol

/**
 Required scrollview delegate method
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sv {
	return mainView;
}

/**
 Required scrollview delegate method
 */
- (void)scrollViewDidEndZooming:(UIScrollView *)sv withView:(UIView *)view atScale:(float)scale {
    [sv setZoomScale:scale+0.01 animated:NO];
    [sv setZoomScale:scale animated:NO];
}

@end
