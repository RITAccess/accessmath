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
 * modes, saving, handling zoom, and handling panning. DO NOT implement this 
 * yourself. API's are subject to change.
 */
@protocol LectureViewChild <NSObject>
@required

/* The view that will have pan/zoom */
- (UIView *)contentView;

/* Updated your code to handle the different sized content area, DO NOT update your content size */
- (void)contentSizeChanging:(CGSize)size;

@optional

/**
 * Will save state gets called during the save process. Prepare the view here.
 */
- (void)willSaveState;
- (void)didSaveState;

/* Will/Did LeaveActiveState is called when your mode is about to lose primary. Remove any toolbars here. */
- (void)willLeaveActiveState;
- (void)didLeaveActiveState;

@end

@interface LectureViewContainer : UIViewController

- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *sideMenu;
@property (weak, nonatomic) IBOutlet TopNav *navBar;

@end
