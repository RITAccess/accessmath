// Copyright 2011 Access Lecture. All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ZoomHandler.H"
#import "LineDrawView.h"
#import "SettingsViewController.h"
#import "AccessLectureRuntime.h"
#import "AccessLectureRuntime.h"
#import "Lecture.h"
#import "UISegmentedControlExtension.h"

@interface LectureViewController : UIViewController<UIScrollViewDelegate>
{
    // UI
	UIScrollView* scrollView;
	UIImageView* imageView;
    
    // ScrollView Gestures
    UIPanGestureRecognizer* scrollViewPanGesture;
    
    // Image grabbing
    NSMutableData* receivedData;
    UIImage* img;
    
    // Zooming
    CGPoint screenSize;
    BOOL shouldSnapToZoom;
    ZoomHandler *zoomHandler;
    BOOL isZoomedIn;
    float ZOOM_STEP;
    float oldZoomScale;
    
    // Connection
    BOOL loading;
    
    // Notes
    LineDrawView *lineDrawView;    
    
    // Settings
    NSUserDefaults* defaults;
    
    //Current Document Settings
    AccessDocument *currentDocument;
    AccessLectureRuntime *currentRuntime;
    Lecture *currentLecture;
    
    // Color Selection
    UISegmentedControl *colorSegmentedControl;
}

- (void)updateImageView;
- (void)settingsChange;
- (void)handleZoomWith: (float) newScale andZoomType: (BOOL) zoomType;
- (void)resetImageZoom: (UIGestureRecognizer *)gestureRecognizer;

- (IBAction)backButtonPress:(id)sender;
- (IBAction)saveButtonPress:(id)sender;
- (IBAction)startNotesButtonPress:(id)sender;
- (IBAction)clearNotesButtonPress:(id)sender;
- (IBAction)zoomOutButtonPress:(id)sender;
- (IBAction)zoomInButtonPress:(id)sender;
- (IBAction)exitNotesButtonPress:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *zoomOutButton;
@property (weak, nonatomic) IBOutlet UIButton *zoomInButton;
@property (weak, nonatomic) IBOutlet UIButton *clearNotesButton;
@property (weak, nonatomic) IBOutlet UIButton *startNotesButton;
@property (weak, nonatomic) IBOutlet UIButton *exitNotesButton;
@property (weak, nonatomic) IBOutlet UIButton *saveNotesButton;

@end

