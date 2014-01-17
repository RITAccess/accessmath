//
//  ImageNoteView.h
//  AccessLecture
//
//  Created by Michael on 1/15/14.
//
//

#import <UIKit/UIKit.h>
#import "ImageNoteViewController.h"

@interface ImageNoteView : UIView

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (readonly) CGRect moveArea;

- (void)resizingViewWithTranslation:(CGPoint)translation withCorner:(CornerIdenifier)cornerID ofFrame:(CGRect)originalFrame;

@end
