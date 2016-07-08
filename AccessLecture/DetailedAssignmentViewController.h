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

@property (strong, nonatomic) IBOutlet UITextField *assignmentDueDate;
@property NSString *date;

@property (strong, nonatomic) IBOutlet UITextField *assignmentTime;
@property NSString *time;

- (IBAction)doneButton:(UIBarButtonItem *)sender;

@end
