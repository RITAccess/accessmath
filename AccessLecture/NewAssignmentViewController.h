//
//  NewAssignmentViewController.h
//  AccessLecture
//
//  Created by Kimberly Sookoo on 6/7/16.
//
//

#import <UIKit/UIKit.h>

@protocol NewAssignmentDelegate <NSObject>

-(void) didDismissView;

@end

@interface NewAssignmentViewController : UIViewController

@property (nonatomic, assign) id <NewAssignmentDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *assignmentName;

@property (weak, nonatomic) IBOutlet UIDatePicker *assignmentDueDate;


- (IBAction)saveButton:(id)sender;

@end
