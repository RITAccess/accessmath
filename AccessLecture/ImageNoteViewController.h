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

/**
 *  The title of the note that displays at the top.
 */
@property (strong) NSString *noteTitle;

/**
 *  The content of the note that appears in the note area.
 */
// TODO -  allow for stylized strings.
@property (strong) NSString *noteContent;

/**
 *  Create a new note centered about the point given
 *
 *  @param point center point of the note
 *
 *  @return ImageNoteViewController
 */
- (id)initWithPoint:(CGPoint)point;

@end
