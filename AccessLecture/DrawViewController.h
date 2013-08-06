//
//  DrawViewController.h
//  AccessLecture
//
//  Created by Piper Chester on 6/26/13.
//
//

#import <UIKit/UIKit.h>
#import "UISegmentedControlExtension.h"
#import "DrawView.h"
#import "LectureViewContainer.h"

static NSString* const DrawViewControllerXIB = @"DrawViewController";
static int const SHAPE_MAX = 4;

@interface DrawViewController : UIViewController <LectureViewChild>

// Gestures
@property UIPanGestureRecognizer *panGestureRecognzier;

// UI Elements
@property DrawView *drawView;
@property (weak, nonatomic) IBOutlet UISlider *penSizeSlider;
@property UISegmentedControl *colorSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;
@property int selectedColor, shapeButtonIndex;
@property (weak, nonatomic) IBOutlet UIButton *shapeButton;
@property NSMutableArray *buttonStrings;


// Interactions
- (IBAction)clearNotesButtonPress:(id)sender;
- (IBAction)penSizeSlide:(id)sender;
- (IBAction)undoButtonPress:(id)sender;
- (IBAction)shapeButtonPress:(id)sender;
- (void)segmentChanged:(id)sender;

@end
