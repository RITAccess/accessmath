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
    self.assignmentName.delegate = self;
    self.assignmentDueDate.text = self.date;
    self.assignmentDueDate.delegate = self;
    self.assignmentTime.text = self.time;
    self.assignmentTime.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Fields Editing

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [SaveAssignments sharedData].initialName = textField.text;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [SaveAssignments sharedData].changedName = textField.text;
    [textField resignFirstResponder];
    NSUInteger index = [[SaveAssignments sharedData].savedArray indexOfObject:[SaveAssignments sharedData].initialName];
    for (NSString *name in [SaveAssignments sharedData].savedArray) {
        if ([name isEqualToString:[SaveAssignments sharedData].initialName]) {
            NSDate *dateToSave = [[SaveAssignments sharedData].savedAssignments objectForKey:[SaveAssignments sharedData].initialName];
            [[SaveAssignments sharedData].savedAssignments setObject:dateToSave forKey:[SaveAssignments sharedData].changedName];
            [[SaveAssignments sharedData].savedAssignments removeObjectForKey:name];
            [[SaveAssignments sharedData].savedArray replaceObjectAtIndex:index withObject:[SaveAssignments sharedData].changedName];
            [SaveAssignments sharedData].initialName = nil;
            [SaveAssignments sharedData].changedName = nil;
            [[SaveAssignments sharedData] save];
            break;
        }
    }
    return YES;
}

- (IBAction)doneButton:(UIBarButtonItem *)sender {
    [self.delegate dismissView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
