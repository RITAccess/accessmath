//  Copyright 2011 Access Lecture. All rights reserved.
#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController<UIScrollViewDelegate> {
    UIScrollView* scrollView;
    IBOutlet UIView *mainView;
}
- (IBAction)returnToHome:(id)sender;

@end
