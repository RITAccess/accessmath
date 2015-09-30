//
//  NoteSearchResultsViewController.h
//  AccessLecture
//
//  Created by Piper on 9/23/15.
//
//

#import "Note.h"
#import <UIKit/UIKit.h>

@interface NoteSearchResultsViewController : UIViewController

- (void)presentNote:(Note*)note;  // used to present selected note in view

@end
