//
//  ImageNoteViewController.h
//  AccessLecture
//
//  Created by Michael on 1/15/14.
//
//

#import <UIKit/UIKit.h>
#import "ImageNoteView.h"

@interface ImageNoteViewController : UIViewController <NSSecureCoding, ImageViewDelegate>

@property (strong) NSString *noteTitle;
@property (strong) NSString *noteContent;

- (id)initWithPoint:(CGPoint)point;

@end
