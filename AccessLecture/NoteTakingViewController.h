//
//  NoteTakingViewController.h
//  AccessLecture
//
//  Created by Michael Timbrook on 9/10/13.
//
//

#import <UIKit/UIKit.h>
#import "LectureViewContainer.h"
#import "AMLecture.h"
#import "Note.h"

@interface NoteTakingViewController : UIViewController <LectureViewChild>

+ (instancetype)loadFromStoryboard;

@property (strong, readonly) AMLecture *document;

- (void)lectureContainer:(LectureViewContainer *)container switchedToDocument:(AMLecture *)document;

- (void)loadNoteAndPresent:(Note *)note;

@end
