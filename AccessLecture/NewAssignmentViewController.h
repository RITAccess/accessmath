//
//  NewAssignmentViewController.h
//  AccessLecture
//
//  Created by Kimberly Sookoo on 6/7/16.
//
//

#import <UIKit/UIKit.h>

@interface NewAssignmentViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *assignmentName;

@property (weak, nonatomic) IBOutlet UIDatePicker *assignmentDueDate;


- (IBAction)saveButton:(id)sender;

@end
