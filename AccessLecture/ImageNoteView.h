//
//  ImageNoteView.h
//  AccessLecture
//
//  Created by Michael on 1/15/14.
//
//

#import <UIKit/UIKit.h>

typedef enum CornerIdenifier : NSUInteger {
    CITopLeft = 1 << 0,
    CITopRight = 1 << 1,
    CIBottomLeft = 1 << 2,
    CIBottonRight = 1 << 3
} CornerIdenifier;

@class ImageNoteView;

@protocol ImageViewDelegate <NSObject>

- (void)imageView:(ImageNoteView *)imageView didFinishResizing:(BOOL)finish;

@end

@interface ImageNoteView : UIView

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (readonly, nonatomic) CGRect moveArea;
@property (readonly, nonatomic) CGRect imageArea;
@property (assign, nonatomic) BOOL resize;
@property (strong, nonatomic) id<ImageViewDelegate> delegate;

- (void)resizingViewWithTranslation:(CGPoint)translation withCorner:(CornerIdenifier)cornerID ofFrame:(CGRect)originalFrame;
- (void)translateView:(CGPoint)translations fromPoint:(CGPoint)center;

@end
