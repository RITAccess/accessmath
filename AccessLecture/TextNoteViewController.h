//
//  TextNoteViewController.h
//  AccessLecture
//
//  Created by Michael on 1/6/14.
//
//

#import <UIKit/UIKit.h>
#import "TextNoteViewDelegate.h"
#import "TextNoteView.h"
@class AMLecture;

@interface TextNoteViewController : UIViewController <TextNoteViewDelegate>

- (instancetype)initWithPoint:(CGPoint)point inLecture:(AMLecture *)lec;
- (instancetype)initWithNote:(NoteTakingNote *)note;

@end
