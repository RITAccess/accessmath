// Copyright 2011 Access Lecture. All rights reserved.

#import <UIKit/UIKit.h>
#import "NotesViewController.h"
#import "InlineNotesViewController.h"
#import "IASKAppSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Zoomhandler.H"

@interface LectureViewController : UIViewController<UIScrollViewDelegate, IASKSettingsDelegate> {
    
    // UI
	IBOutlet UIScrollView* scrollView;
    IBOutlet UIView* bottomToolbar;
    IBOutlet UIView* topToolbar;
    IBOutlet UILabel* toolbarLabel;
    IBOutlet UIView* notesTopToolbar;
    IBOutlet UILabel* notesTopToolbarLabel;
	UIImageView* imageView;
    
    // ScrollView Gestures
    UIPanGestureRecognizer* scrollViewPanGesture;
    
    // Image grabbing
    NSMutableData* receivedData;
    NSTimer* t;
    UIImage* img;
    
    // Zooming
    CGPoint scrSize;
    BOOL shouldSnapToZoom;
    ZoomHandler *zoomHandler;
    
    // Connection
    BOOL loading;
    
    // Notes
    NotesViewController* notesViewController;
    
    // Settings
    IASKAppSettingsViewController* appSettingsViewController;
    NSUserDefaults* defaults;
    
}
- (IBAction)clear:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *clearNotesButton;

-(IBAction)zoomOut;
-(IBAction)zoomIn;

-(IBAction)openSettings:(id)sender;

-(void)updateImageView;
-(void)settingsChange;
-(void)handleZoomWith: (float) newScale andZoomType: (BOOL) zoomType;
-(void)resetImageZoom: (UIGestureRecognizer *)gestureRecognizer;

@property (nonatomic) IASKAppSettingsViewController* appSettingsViewController;
@property (nonatomic, strong)UIPopoverController* popover;

- (IBAction)backButtonPress:(id)sender;
- (IBAction)displaySettings:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)notes:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *colorSelectionSegment;
@property (weak, nonatomic) IBOutlet UIButton *zoomOutButton;
@property (weak, nonatomic) IBOutlet UIButton *zoomInButton;

@end

