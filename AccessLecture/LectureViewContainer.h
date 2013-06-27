//
//  LectureViewContainer.h
//  AccessLecture
//
//  Created by Michael Timbrook on 6/26/13.
//
//

#import <UIKit/UIKit.h>
#import "TopNav.h"

@protocol LectureViewChild <NSObject>

- (void)willSaveState;

@end

@interface LectureViewContainer : UIViewController

- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *sideMenu;
@property (weak, nonatomic) IBOutlet TopNav *navBar;

@end
