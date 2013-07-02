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

@interface DrawViewController : UIViewController <LectureViewChild>

// Gestures
@property UIPanGestureRecognizer *panGestureRecognzier;

// UI Elements
@property DrawView *drawView;
@property (weak, nonatomic) IBOutlet UISlider *penSizeSlider;
@property UISegmentedControl *colorSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;
@property int selectedColor;


// Interactions
- (IBAction)clearNotesButtonPress:(id)sender;
- (IBAction)penSizeSlide:(id)sender;
- (IBAction)undoButtonPress:(id)sender;
- (IBAction)shapeButtonPress:(id)sender;

@end
