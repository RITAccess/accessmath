// Copyright 2011 Access Lecture. All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ZoomHandler.H"
#import "LineDrawView.h"
#import "SettingsViewController.h"
#import "AccessLectureRuntime.h"
#import "AccessLectureRuntime.h"
#import "Lecture.h"

@interface LectureViewController : UIViewController<UIScrollViewDelegate> {
    
    // UI
	IBOutlet UIScrollView* scrollView;
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
    LineDrawView *lineDrawView;    
    
    // Settings
    NSUserDefaults* defaults;
    
    //Current Document Settings
    AccessDocument *currentDocument;
    AccessLectureRuntime *currentRuntime;
    Lecture *currentLecture;
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

@property (weak, nonatomic) IBOutlet UISegmentedControl *colorSelectionSegment;
@property (weak, nonatomic) IBOutlet UIButton *zoomOutButton;
@property (weak, nonatomic) IBOutlet UIButton *zoomInButton;
@property (weak, nonatomic) IBOutlet UIButton *clearNotesButton;

@end

