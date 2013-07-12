//
//  LectureViewContainer.h
//  AccessLecture
//
//  Created by Michael Timbrook on 6/26/13.
//
//

#import <UIKit/UIKit.h>
#import "TopNav.h"

/**
 * The LectureViewChild protocol is required to be a valid subview controller of
 * the LectureViewContainer. If you do not implement theses methods your controller
 * will not fuction properly. LectureViewContainer is responsible for switching
 * modes, saveing, handling zoom, and handling panning. DO NOT implement this 
 * yourself. API's are subject to change.
 */
@protocol LectureViewChild <NSObject>
@required

/* Return the view you need to remain synced between multiple modes. */
- (UIView *)willApplyTransformToView;

@optional

/**
 * Will save state gets called during the save process. Prepare the view here.
 */
- (void)willSaveState;
- (void)didSaveState;

/* Will/Did LeaveActiveState is called when your mode is about to lose primary. Remove any toolbars here. */
- (void)willLeaveActiveState;
- (void)didLeaveActiveState;

/* Returns the controller's view. */
- (UIView *)willReturnView;

@end

@interface LectureViewContainer : UIViewController

- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *sideMenu;
@property (weak, nonatomic) IBOutlet TopNav *navBar;
@property (weak, nonatomic) IBOutlet UIView *container;

@end
