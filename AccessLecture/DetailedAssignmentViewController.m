//
//  DetailedAssignmentViewController.m
//  AccessLecture
//
//  Created by Student on 7/6/16.
//
//

#import "DetailedAssignmentViewController.h"
#import "SaveAssignments.h"
#import "AssignmentItem.h"

@interface DetailedAssignmentViewController () <UITextFieldDelegate>

@end

@implementation DetailedAssignmentViewController {
    NSMutableArray *savedArray;
    AssignmentItem *selectedAssignment;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setToolbarHidden:NO];
    self.assignmentName.text = self.name;
    self.datePicker.date = self.assignmentDate;
    self.assignmentName.delegate = self;
    self.detailTextView.text = self.notes;
    self.segmentedButton = [[UIBarButtonItem alloc] initWithCustomView:(UIView*)[self createSegmentedControl]];
    self.stepperButton = [[UIBarButtonItem alloc] initWithCustomView:(UIView*)[self createStepper]];
    self.fixedSpace = [self createFixedSpace];
    
    NSArray *barArray = [NSArray arrayWithObjects: self.stepperButton, self.fixedSpace, self.segmentedButton, nil];
    
    [self setToolbarItems:barArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create Buttons

-(UISegmentedControl*)createSegmentedControl {
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Normal", @"Bold", @"Italic", nil]];
    segmentedControl.frame = CGRectMake(130, 0, 200, 30);
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(changeFontStyle:) forControlEvents:UIControlEventValueChanged];
    
    return segmentedControl;
}

-(UIStepper*)createStepper {
    UIStepper *stepper = [[UIStepper alloc] init];
    stepper.frame = CGRectMake(0, 0, 100, 30);
    [stepper addTarget:self action:@selector(changeFontSize:) forControlEvents:UIControlEventValueChanged];
    
    return stepper;
}

-(UIBarButtonItem*)createFixedSpace {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 42;
    
    return fixedSpace;
}

#pragma mark - Button Actions

-(void)changeFontStyle:(UISegmentedControl*)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.detailTextView setFont:[UIFont systemFontOfSize:self.detailTextView.font.pointSize]];
            break;
        case 1:
            [self.detailTextView setFont:[UIFont boldSystemFontOfSize:self.detailTextView.font.pointSize]];
            break;
        case 2:
            [self.detailTextView setFont:[UIFont italicSystemFontOfSize:self.detailTextView.font.pointSize]];
            break;
        default:
            break;
    }
}

-(void)changeFontSize:(UIStepper*)sender {
    [sender setMinimumValue:18.0];
    [sender setMaximumValue:50.0];
    self.detailTextView.font = [self.detailTextView.font fontWithSize:[sender value]];
}

#pragma mark - Text Fields Editing

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.name = textField.text;
    return YES;
}

/*(-(BOOL)textFieldShouldReturn:(UITextField *)textField {
 [textField resignFirstResponder];
 NSUInteger index = [[SaveAssignments sharedData].savedArray indexOfObject:self.name];
 for (NSString *name in [SaveAssignments sharedData].savedArray) {
 if ([name isEqualToString:self.name]) {
 NSDate *dateToSave = [[SaveAssignments sharedData].savedAssignments objectForKey:self.name];
 [[SaveAssignments sharedData].savedAssignments setObject:dateToSave forKey:textField.text];
 [[SaveAssignments sharedData].savedAssignments removeObjectForKey:name];
 [[SaveAssignments sharedData].savedArray replaceObjectAtIndex:index withObject:textField.text];
 [[SaveAssignments sharedData] save];
 self.name = textField.text;
 break;
 }
 }
 return YES;
 }*/

- (IBAction)doneButton:(UIBarButtonItem *)sender {
    [self.delegate dismissView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)updateDueDate:(UIDatePicker *)sender {
}

@end
