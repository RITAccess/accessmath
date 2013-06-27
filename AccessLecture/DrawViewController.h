//
//  DrawViewController.h
//  AccessLecture
//
//  Created by Piper Chester on 6/26/13.
//
//

#import <UIKit/UIKit.h>
#import "UISegmentedControlExtension.h"
#import "LectureViewContainer.h"
#import "DrawView.h"

static NSString* const DrawViewControllerXIB = @"DrawViewController";

@interface DrawViewController : UIViewController <LectureViewChild>

@property NSInteger selectedColor;
@property DrawView *drawView;
@property UISegmentedControl *colorSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;

// Gestures
@property UIPanGestureRecognizer *panGestureRecognzier;

@end
