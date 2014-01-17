//
//  ImageNoteViewController.h
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

@interface ImageNoteViewController : UIViewController <NSSecureCoding>

@property (strong) NSString *noteTitle;
@property (strong) NSString *noteContent;

- (id)initWithPoint:(CGPoint)point;

@end
