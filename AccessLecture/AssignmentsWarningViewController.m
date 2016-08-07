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
    UILabel *selectedLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:NO];
    self.preferredContentSize = CGSizeMake(250, 300);
    self.reminderPickerView.delegate = self;
    self.reminderPickerView.showsSelectionIndicator = YES;
    
    selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 90, 30, 30)];
    selectedLabel.backgroundColor = [UIColor blueColor];
    selectedLabel.layer.masksToBounds = YES;
    selectedLabel.layer.cornerRadius = 15.0f;
    selectedLabel.textAlignment = NSTextAlignmentCenter;
    selectedLabel.textColor = [UIColor whiteColor];
    selectedLabel.text = [NSString stringWithFormat:@"%d",0];
    selectedLabel.font = [selectedLabel.font fontWithSize:25];
    [self.view addSubview:selectedLabel];
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
    selectedLabel.text = [NSString stringWithFormat:@"%d",row];
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
