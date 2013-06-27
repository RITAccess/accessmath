// Copyright 2011 Access Lecture. All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DrawView.h"
#import "SettingsViewController.h"
#import "AccessLectureRuntime.h"
#import "AccessLectureRuntime.h"
#import "Lecture.h"
#import "UISegmentedControlExtension.h"


@interface LectureViewController : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate>
{    
    // UI
	UIImageView *imageView;
    
    // Gestures
    UIPanGestureRecognizer *panToMove;
    UITapGestureRecognizer *tapToZoom;
    
    // Image grabbing
    NSMutableData* receivedData;
    UIImage* img;
    
    // Zooming
    CGPoint screenSize;
    BOOL isZoomedIn;
    float ZOOM_STEP;
    float oldZoomScale;
    
    // Connection
    BOOL loading;
    
    // Notes
    DrawView *lineDrawView;
    
    // Settings
    NSUserDefaults* defaults;
    
    //Current Document Settings
    AccessDocument *currentDocument;
    AccessLectureRuntime *currentRuntime;
    Lecture *currentLecture;
    
    // Color Selection
    UISegmentedControl *colorSegmentedControl;
    
    // New ScrollView
    UIScrollView *scrollView;
}

- (void)updateImageView;
- (void)settingsChange;

- (IBAction)backButtonPress:(id)sender;
- (IBAction)saveButtonPress:(id)sender;
- (IBAction)startNotesButtonPress:(id)sender;
- (IBAction)clearNotesButtonPress:(id)sender;
- (IBAction)zoomOutButtonPress:(id)sender;
- (IBAction)zoomInButtonPress:(id)sender;
- (IBAction)exitNotesButtonPress:(id)sender;
- (IBAction)toggleNoteButtonPress:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *zoomOutButton;
@property (weak, nonatomic) IBOutlet UIButton *zoomInButton;
@property (weak, nonatomic) IBOutlet UIButton *clearNotesButton;
@property (weak, nonatomic) IBOutlet UIButton *startNotesButton;
@property (weak, nonatomic) IBOutlet UIButton *exitNotesButton;
@property (weak, nonatomic) IBOutlet UIButton *saveNotesButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigationBarBackButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigationBarSettingsButton;
@property (weak, nonatomic) IBOutlet UIButton *createNoteButton;

@end

