//
//  NewLectureController.h
//  AccessLecture
//
//  Created by Michael Timbrook on 1/26/15.
//
//

#import <UIKit/UIKit.h>
#import "AMLecture.h"

@class NewLectureController;

@protocol NewLetureVCDelegate <NSObject>

- (void)newLectureViewController:(NewLectureController *)controller didCreateNewLecture:(AMLecture *)lecture;

@end

@interface NewLectureController : UIViewController

@property (weak) id delegate;

@property (weak, nonatomic) IBOutlet UITextField *lectureName;
- (IBAction)goBack;

@end
