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

@interface NoteTakingViewController : UIViewController <LectureViewChild>

@property (strong, readonly) AMLecture *document;

@end
