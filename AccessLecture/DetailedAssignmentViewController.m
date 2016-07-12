//
//  DetailedAssignmentViewController.m
//  AccessLecture
//
//  Created by Student on 7/6/16.
//
//

#import "DetailedAssignmentViewController.h"
#import "SaveAssignments.h"

@interface DetailedAssignmentViewController () <UITextFieldDelegate>

@end

@implementation DetailedAssignmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.assignmentName.text = self.name;
    self.datePicker.date = self.assignmentDate;
    self.assignmentName.delegate = self;
    self.detailTextView.text = self.notes;
    
    NSLog(@"Text view %@",self.detailTextView.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Fields Editing

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.name = textField.text;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
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
}

- (IBAction)doneButton:(UIBarButtonItem *)sender {
    NSLog(@"Text view %@",self.detailTextView.text);
    NSLog(@"Text view %@",self.name);
    NSString *newNotes = self.detailTextView.text;
    for (NSString *key in [SaveAssignments sharedData].savedNotes) {
        if ([key isEqualToString:self.name]) {
            [[SaveAssignments sharedData].savedNotes setObject:newNotes forKey:key];
            [[SaveAssignments sharedData] save];
        }
    }
    [self.delegate dismissView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)updateDueDate:(UIDatePicker *)sender {
    NSDate *dateToReplace = [[SaveAssignments sharedData].savedAssignments objectForKey:self.assignmentName.text];
    dateToReplace = sender.date;
    [[SaveAssignments sharedData].savedAssignments setObject:dateToReplace forKey:self.assignmentName.text];
}

@end
