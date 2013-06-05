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

- (void)updateImageView;
- (void)settingsChange;
- (void)handleZoomWith: (float) newScale andZoomType: (BOOL) zoomType;
- (void)resetImageZoom: (UIGestureRecognizer *)gestureRecognizer;

- (IBAction)backButtonPress:(id)sender;
- (IBAction)displaySettings:(id)sender;
- (IBAction)saveButtonPress:(id)sender;
- (IBAction)startNotesButtonPress:(id)sender;
- (IBAction)clearNotesButtonPress:(id)sender;
- (IBAction)zoomOutButtonPress:(id)sender;
- (IBAction)zoomInButtonPress:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *colorSelectionSegment;
@property (weak, nonatomic) IBOutlet UIButton *zoomOutButton;
@property (weak, nonatomic) IBOutlet UIButton *zoomInButton;
@property (weak, nonatomic) IBOutlet UIButton *clearNotesButton;
@property (nonatomic) IASKAppSettingsViewController* appSettingsViewController;
@property (nonatomic, strong)UIPopoverController* popover;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

@end

