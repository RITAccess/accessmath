//
//  AssignmentsWarningViewController.h
//  AccessLecture
//
//  Created by Kimberly Sookoo on 7/18/16.
//
//

#import <UIKit/UIKit.h>

@protocol AssignmentWarningDelegate <NSObject>

-(void)dismissAssignmentWarning;

@end

@interface AssignmentsWarningViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) id <AssignmentWarningDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIPickerView *reminderPickerView;

- (IBAction)done:(id)sender;

@end
