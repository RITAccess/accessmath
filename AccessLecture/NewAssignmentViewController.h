//
//  NewAssignmentViewController.h
//  AccessLecture
//
//  Created by Kimberly Sookoo on 6/7/16.
//
//
@protocol NewAssignmentDelegate <NSObject>

-(void) didDismissView;

@end

@interface NewAssignmentViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) id <NewAssignmentDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *assignmentName;

@property (weak, nonatomic) IBOutlet UIDatePicker *assignmentDueDate;

@property (strong, nonatomic) IBOutlet UIButton *selectClass;



- (IBAction)selectClass:(UIButton *)sender;


- (IBAction)saveButton:(id)sender;

@end
