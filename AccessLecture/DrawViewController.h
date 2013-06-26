//
//  DrawViewController.h
//  AccessLecture
//
//  Created by Piper Chester on 6/26/13.
//
//

#import <UIKit/UIKit.h>
#import "UISegmentedControlExtension.h"

@interface DrawViewController : UIViewController

@property UISegmentedControl *colorSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;

@end
