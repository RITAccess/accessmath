//
//  DetailedAssignmentViewController.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 7/6/16.
//
//

#import "DetailedAssignmentViewController.h"
#import "SaveAssignments.h"
#import "AssignmentItem.h"
#import "AMIndex.h"

@interface DetailedAssignmentViewController () <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate>

@end

@implementation DetailedAssignmentViewController {
    NSMutableArray *savedArray;
    AssignmentItem *selectedAssignment;
    NSString *initialName;
    NSString *changedName;
    NSDate *updatedDate;
    NSString *associatedNotes;
    
    //Gets the names of lectures
    AMIndex *_fsIndex;
    NSString *_currectPath;
    NSArray *lectureNames;
    NSString *chosenLecture;
    
    UIPickerView *pickerView;
    UIButton *choose;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    savedArray = [AssignmentItem loadAssignments];
    
    [self.navigationController setToolbarHidden:NO];
    //assignment name
    self.assignmentName.text = self.name;
    self.assignmentName.delegate = self;
    
    //assignment date
    self.datePicker.date = self.assignmentDate;
    
    //assignment notes
    self.detailTextView.text = self.notes;
    self.detailTextView.delegate = self;
    
    //assignment lecture
    [self.associatedLecture setTitle:self.lecture forState:UIControlStateNormal];
    
    //stepper buttons and space(s) for tool bar
    self.segmentedButton = [[UIBarButtonItem alloc] initWithCustomView:(UIView*)[self createSegmentedControl]];
    self.stepperButton = [[UIBarButtonItem alloc] initWithCustomView:(UIView*)[self createStepper]];
    self.fixedSpace = [self createFixedSpace];
    
    NSArray *barArray = [NSArray arrayWithObjects: self.stepperButton, self.fixedSpace, self.segmentedButton, nil];
    
    [self setToolbarItems:barArray];
    
    //To get names of lectures
    _currectPath = @"~/Documents";
    _fsIndex = [AMIndex sharedIndex];
    lectureNames = _fsIndex[_currectPath];
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

- (IBAction)changeLecture:(UIButton *)sender {
    sender.hidden = YES;
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(39, 348, 404, 100)];
    pickerView.delegate = self;
    
    choose = [[UIButton alloc] initWithFrame:CGRectMake(420, 381, 120, 30)];
    choose.backgroundColor = [UIColor colorWithRed:0.24 green:0.69 blue:0.00 alpha:1.0];
    [choose setTitle:@"Select Lecture" forState:UIControlStateNormal];
    [choose addTarget:self action:@selector(chooseLecture:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:pickerView];
    [self.view addSubview:choose];
}

- (void) chooseLecture:(UIButton*)sender {
    [sender removeFromSuperview];
    [pickerView removeFromSuperview];
    self.associatedLecture.hidden = NO;
    if (chosenLecture != nil) {
        [self.associatedLecture setTitle:chosenLecture forState:UIControlStateNormal];
    }
}

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

#pragma mark - Updating Date

-(void)updateDate {
    for (AssignmentItem *assignment in savedArray) {
        if ([assignment.itemName isEqualToString:self.name]) {
            NSUInteger index = [savedArray indexOfObject:assignment];
            NSDate *dateToSave = updatedDate;
            NSString *notesToSave = assignment.notes;
            NSString *associatedLecture = assignment.associatedLecture;
            BOOL isCompleted = assignment.completed;
            AssignmentItem *updatedItem = [[AssignmentItem alloc] initWithName:assignment.itemName Date:dateToSave Lecture:associatedLecture];
            updatedItem.notes = notesToSave;
            updatedItem.completed = isCompleted;
            [savedArray replaceObjectAtIndex:index withObject:updatedItem];
            break;
        }
    }
    [AssignmentItem replaceArrayOfAssignmentsWith:savedArray];
}

#pragma mark - Updating Notes

-(void)textViewDidChange:(UITextView *)textView {
    NSLog(@"In here?");
    associatedNotes = textView.text;
    [self updateNotes];
}

-(void)updateNotes {
    for (AssignmentItem *assignment in savedArray) {
        if ([assignment.itemName isEqualToString:self.name]) {
            NSUInteger index = [savedArray indexOfObject:assignment];
            NSDate *dateToSave = assignment.creationDate;
            NSString *notesToSave = associatedNotes;
            NSString *associatedLecture = assignment.associatedLecture;
            BOOL isCompleted = assignment.completed;
            AssignmentItem *updatedItem = [[AssignmentItem alloc] initWithName:assignment.itemName Date:dateToSave Lecture:associatedLecture];
            updatedItem.notes = notesToSave;
            updatedItem.completed = isCompleted;
            [savedArray replaceObjectAtIndex:index withObject:updatedItem];
            break;
        }
    }
    [AssignmentItem replaceArrayOfAssignmentsWith:savedArray];
}


#pragma mark - Text Fields Editing

-(void)changeText {
    for (AssignmentItem *assignment in savedArray) {
        if ([assignment.itemName isEqualToString:initialName]) {
            NSUInteger index = [savedArray indexOfObject:assignment];
            NSDate *dateToSave = assignment.creationDate;
            NSString *notesToSave = assignment.notes;
            NSString *associatedLecture = assignment.associatedLecture;
            BOOL isCompleted = assignment.completed;
            AssignmentItem *updatedItem = [[AssignmentItem alloc] initWithName:changedName Date:dateToSave Lecture:associatedLecture];
            updatedItem.notes = notesToSave;
            updatedItem.completed = isCompleted;
            [savedArray replaceObjectAtIndex:index withObject:updatedItem];
            self.name = changedName;
            initialName = nil;
            changedName = nil;
            break;
        }
    }
    [AssignmentItem replaceArrayOfAssignmentsWith:savedArray];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    initialName = textField.text;
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    changedName = textField.text;
    [textField resignFirstResponder];
    if (!([textField.text isEqualToString:initialName])) {
        [self changeText];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    changedName = textField.text;
    [textField resignFirstResponder];
    if (!([textField.text isEqualToString:initialName])) {
        [self changeText];
    }
    return YES;
 }

- (IBAction)doneButton:(UIBarButtonItem *)sender {
    if (changedName != nil) {
        [self changeText];
    }
    if (updatedDate != nil) {
        [self updateDate];
    }
    [self.delegate dismissView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)updateDueDate:(UIDatePicker *)sender {
    updatedDate = sender.date;
}

#pragma mark - UIPickerView Datasource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [lectureNames count];
}

#pragma mark - UIPickerView Delegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    chosenLecture = [lectureNames objectAtIndex:row];
    return [NSString stringWithFormat:@"%@",[lectureNames objectAtIndex:row]];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    chosenLecture = [lectureNames objectAtIndex:row];
}

@end