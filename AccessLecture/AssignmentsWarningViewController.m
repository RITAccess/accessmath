//
//  AssignmentsWarningViewController.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 7/18/16.
//
//

#import "AssignmentsWarningViewController.h"
#import "SaveAssignments.h"

@interface AssignmentsWarningViewController ()

@end

@implementation AssignmentsWarningViewController {
    NSInteger *chosenNumberOfDays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(250, 300);
    self.reminderPickerView.delegate = self;
    self.reminderPickerView.showsSelectionIndicator = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerView Datasource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 15;
}

#pragma mark - UIPickerView Delegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d",row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    chosenNumberOfDays = row;
}

- (IBAction)done:(id)sender {
    if (chosenNumberOfDays != NULL) {
        [SaveAssignments sharedData].reminder = [NSString stringWithFormat:@"%d",chosenNumberOfDays];
        [[SaveAssignments sharedData] save];
    }
    [self assignmentWarningDismissed];
}

-(void)assignmentWarningDismissed {
    [self.delegate dismissAssignmentWarning];
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
