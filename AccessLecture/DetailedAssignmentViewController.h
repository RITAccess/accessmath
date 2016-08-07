//
//  DetailedAssignmentViewController.h
//  AccessLecture
//
//  Created by Student on 7/6/16.
//
//

#import <UIKit/UIKit.h>

@protocol DetailedAssignmentDelegate <NSObject>

-(void) dismissView;

@end

@interface DetailedAssignmentViewController : UIViewController

@property (nonatomic, assign) id <DetailedAssignmentDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *assignmentName;
@property NSString *name;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSDate *assignmentDate;

@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property NSString *notes;

@property NSString *lecture;
@property BOOL completed;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *stepperButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *segmentedButton;
@property (strong, nonatomic) UIBarButtonItem *fixedSpace;

- (IBAction)doneButton:(UIBarButtonItem *)sender;
- (IBAction)updateDueDate:(UIDatePicker *)sender;


@end
