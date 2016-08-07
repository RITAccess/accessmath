//
//  AssignmentTableViewCell.h
//  AccessLecture
//
//  Created by Kimberly Sookoo on 6/14/16.
//
//

#import <UIKit/UIKit.h>

@interface AssignmentTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *assignmentName;

@property (strong, nonatomic) IBOutlet UILabel *assignmentDueDate;

@property (strong, nonatomic) IBOutlet UILabel *assignmentTime;

@property (strong, nonatomic) IBOutlet UIButton *infoButton;


@end
