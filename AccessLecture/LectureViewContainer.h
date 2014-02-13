//
//  LectureViewContainer.h
//  AccessLecture
//
//  Created by Michael Timbrook on 6/26/13.
//
//

#import <UIKit/UIKit.h>
#import <MTRadialMenu/MTRadialMenu.h>

static NSString *const LectureViewContainerSBID = @"lectureVC";

typedef struct {
    CGPoint root;
    CGPoint end;
} Vector;
extern Vector VectorMake(CGPoint root, CGPoint end);
extern void VectorApplyScale(CGFloat scale, Vector *vector);

/**
 * The LectureViewChild protocol is required to be a valid subview controller of
 * the LectureViewContainer. If you do not implement theses methods your controller
 * will not fuction properly. LectureViewContainer is responsible for switching
 * modes, saving, handling zoom, and handling panning. DO NOT implement this 
 * yourself. API's are subject to change.
 */
@protocol LectureViewChild <NSObject>
@required

/**
 * The view that will have pan/zoom. This will be your content area. 
 * NOTE bounds are the full size of the area. For example 2000 x 2000. The frame
 * is the size of the view on the screen. So if we are zoomed out, the frame may
 * only be 300 x 300.
 */
- (UIView *)contentView;

@optional

/**
 * Add the radial menu items you'd like to have accessible for your controller
 * Return the array of items
 */
- (NSArray *)menuItemsForRadialMenu:(MTRadialMenu *)menu;

/**
 * Updated your code to handle the different sized content area, DO NOT update your content size 
 * Not implemented yet, doesn't get called.
 */
- (void)contentSizeChanging:(CGSize)size;

/**
 * Will save state gets called during the save process. Prepare the view here.
 */
- (void)willSaveState;
- (void)didSaveState;

/** 
 * Will/Did LeaveActiveState is called when your mode is about to lose primary. Remove any toolbars here. 
 */
- (void)willLeaveActiveState;
- (void)didLeaveActiveState;

@end

@interface LectureViewContainer : UIViewController

@end
