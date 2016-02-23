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

@interface TextNoteViewController : UIViewController <TextNoteViewDelegate>

- (instancetype)initWithPoint:(CGPoint)point __deprecated;
- (instancetype)initWithNote:(Note *)note;

@end
