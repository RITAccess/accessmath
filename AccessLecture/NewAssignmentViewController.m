//
//  NewAssignmentViewController.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 6/7/16.
//
//

#import "NewAssignmentViewController.h"
#import "AssignmentItem.h"
#import "SaveAssignments.h"

@interface NewAssignmentViewController ()

@end

@implementation NewAssignmentViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButton:(id)sender {
    NSString *itemName = _assignmentName.text;
    [[SaveAssignments sharedData].savedAssignments setObject:_assignmentDueDate.date forKey:itemName];
    [SaveAssignments sharedData].savedItem = itemName;
    [[SaveAssignments sharedData] save];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
