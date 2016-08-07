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
#import "AMIndex.h"
#import "AssignmentItem.h"

@interface NewAssignmentViewController ()

@end

@implementation NewAssignmentViewController {
    UIPickerView *pickerView;
    UIButton *choose;
    
    //Gets the names of lectures
    AMIndex *_fsIndex;
    NSString *_currectPath;
    NSArray *lectureNames;
    NSString *chosenLecture;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //To get names of lectures
    _currectPath = @"~/Documents";
    _fsIndex = [AMIndex sharedIndex];
    lectureNames = _fsIndex[_currectPath];
    
    // Do any additional setup after loading the view.
    self.preferredContentSize = CGSizeMake(500,550);
    [self.assignmentDueDate setMinimumDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectClass:(UIButton *)sender {
    sender.hidden = YES;
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(39, 348, 404, 100)];
    pickerView.delegate = self;
    
    choose = [[UIButton alloc] initWithFrame:CGRectMake(120, 348, 30, 30)];
    choose.backgroundColor = [UIColor greenColor];
    [choose addTarget:self action:@selector(chooseLecture:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:pickerView];
    [self.view addSubview:choose];
}

- (IBAction)saveButton:(id)sender {
    AssignmentItem *assignment = [[AssignmentItem alloc] initWithName:self.assignmentName.text Date:self.assignmentDueDate.date Lecture:self.selectClass.currentTitle];
    [AssignmentItem saveAssignment:assignment];
    [self willDismissView];
}

- (void) chooseLecture:(UIButton*)sender {
    [sender removeFromSuperview];
    [pickerView removeFromSuperview];
    self.selectClass.hidden = NO;
    if (chosenLecture != nil) {
        [self.selectClass setTitle:chosenLecture forState:UIControlStateNormal];
    }
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

-(void) willDismissView {
    [self.delegate didDismissView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
