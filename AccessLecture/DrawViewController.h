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

@interface DrawViewController : UIViewController

@property NSInteger selectedColor;
@property DrawView *drawView;
@property UISegmentedControl *colorSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;

// Gestures
@property UIPanGestureRecognizer *panGestureRecognzier;
- (IBAction)togglePan:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *togglePanSwitch;

@end
