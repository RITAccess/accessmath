
//
//  AssignmentsViewController.m
//  LandScapeV2
//
//  Created by Kimberly Sookoo on 6/24/15.
//  Copyright (c) 2015 Kimberly Sookoo. All rights reserved.
//

#import "AssignmentsViewController.h"
#import "AssignmentItem.h"
#import "SaveAssignments.h"
#import "AssignmentTableViewCell.h"
#import "NewAssignmentViewController.h"
#import "DetailedAssignmentViewController.h"
#import "AssignmentsWarningViewController.h"
#import "SortingMethods.h"
#import "AMIndex.h"

@interface AssignmentsViewController () <NewAssignmentDelegate, UITextFieldDelegate, DetailedAssignmentDelegate, AssignmentWarningDelegate>
{
    NSMutableArray *SelectedRows;
}

@property (weak, nonatomic) IBOutlet UITextField *currDate;

@end

@implementation AssignmentsViewController{
    AssignmentsWarningViewController *awvc;
    NewAssignmentViewController *navc;
    UIPopoverController *popover;
    
    NSMutableArray *savedArray;
    
    //Deals with changing assignment name
    NSString *initialName;
    NSString *changedName;
    
    //Gets the names of lectures
    AMIndex *_fsIndex;
    NSString *_currectPath;
    NSArray *lectureNames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*//date things
     NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
     [dateFormat setDateFormat:@"yyyy-MM-dd"];
     NSDate *now = [[NSDate alloc]init];
     NSString *theDate = [dateFormat stringFromDate:now];
     _currDate.text = theDate;
     _currDate.userInteractionEnabled = NO;*/
    
    //To get names of lectures
    _currectPath = @"~/Documents";
    _fsIndex = [AMIndex sharedIndex];
    lectureNames = _fsIndex[_currectPath];
    
    //initialize the arrays here
    self.toDoItems = [[NSMutableArray alloc] init];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    SelectedRows = [NSMutableArray arrayWithArray:[userDef objectForKey:@"SelectedRows"]];
    
    //check to see if sorting algorithm for assignments was selected
    if ([SaveAssignments sharedData].segmentSelected) {
        self.segmentChoice.selectedSegmentIndex = [SaveAssignments sharedData].segment;
    }
    
    savedArray = [AssignmentItem loadAssignments];
    [self loadInitialData];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.toDoItems removeAllObjects];
    [self loadInitialData];
}

/*
 * Loads everything statically for the intial information that goes into the array
 */
-(void) loadInitialData
{
    if (savedArray != nil) {
        for (AssignmentItem *newItem in savedArray) {
            [self.toDoItems addObject:newItem];
        }
    }
}

- (IBAction)sortingChoice:(UISegmentedControl *)sender {
    [SaveAssignments sharedData].segment = sender.selectedSegmentIndex;
    [SaveAssignments sharedData].segmentSelected = YES;
    [[SaveAssignments sharedData] save];
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            savedArray = [SortingMethods mergeSort:savedArray];
            [AssignmentItem replaceArrayOfAssignmentsWith:savedArray];
            break;
        case 1:
            [SortingMethods alphabetSort];
            break;
        case 2:
            [SortingMethods reverseAlphabetSort];
            break;
        default:
            break;
    }
    [self.toDoItems removeAllObjects];
    [self loadInitialData];
    [self.tableView reloadData];
}

#pragma mark - Details

-(void)dismissView {
    [self.toDoItems removeAllObjects];
    [self loadInitialData];
    [self.tableView reloadData];
}

#pragma mark - New Assignment

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toNewAssignmentViewController"]) {
        navc = segue.destinationViewController;
        [navc setDelegate:self];
    } else if ([segue.identifier isEqualToString:@"toReminder"]) {
        awvc = segue.destinationViewController;
        [awvc setDelegate:self];
    }
}

-(void) didDismissView {
    [self.toDoItems removeAllObjects];
    [self loadInitialData];
    [self.tableView reloadData];
}

#pragma mark - Assignment Warning

-(void)dismissAssignmentWarning {
    [self.tableView reloadData];
}

- (IBAction)editButton:(UIBarButtonItem*)sender {
    //Permits editing of rows
    if ([sender.title isEqualToString:@"Edit"]) {
        self.editing = YES;
        [sender setTitle:@"Done"];
        self.segmentChoice.hidden = YES;
    } else {
        self.editing = NO;
        [self.tableView reloadData];
        [sender setTitle:@"Edit"];
        self.segmentChoice.hidden = NO;
    }
}

#pragma mark - Edit Names of Assignments

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
            initialName = nil;
            changedName = nil;
            break;
        }
    }
    [AssignmentItem replaceArrayOfAssignmentsWith:savedArray];
    [self.toDoItems removeAllObjects];
    [self loadInitialData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.editing = YES;
    [_editButton setTitle:@"Done"];
    initialName = textField.text;
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    changedName = textField.text;
    [textField resignFirstResponder];
    if (!([textField.text isEqualToString:initialName])) {
        [self changeText];
    }
    self.editing = NO;
    [_editButton setTitle:@"Edit"];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    changedName = textField.text;
    [textField resignFirstResponder];
    if (!([textField.text isEqualToString:initialName])) {
        [self changeText];
    }
    self.editing = NO;
    [_editButton setTitle:@"Edit"];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.toDoItems count];
}

/* Strikes through the selected rows */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssignmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    AssignmentItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    navc.delegate = self;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"EEE yyyy-MM-dd"];
    NSString *theDate = [dateFormat stringFromDate:toDoItem.creationDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *time = [formatter stringFromDate:toDoItem.creationDate];
    
    cell.assignmentName.text = toDoItem.itemName;
    cell.assignmentName.delegate = self;
    cell.assignmentDueDate.text = theDate;
    cell.assignmentTime.text = time;
    
    NSDate *today = [NSDate date];
    NSDate *fiveDayWarning;
    if ([SaveAssignments sharedData].reminder != nil) {
        int integer = [[SaveAssignments sharedData].reminder intValue];
        fiveDayWarning = [toDoItem.creationDate dateByAddingTimeInterval:-integer*24*60*60];
    } else {
        fiveDayWarning = [toDoItem.creationDate dateByAddingTimeInterval:-5*24*60*60];
    }
    
    if (([today compare:fiveDayWarning] == NSOrderedDescending) && ([today compare:toDoItem.creationDate] == NSOrderedAscending)) {
        [cell setBackgroundColor:[UIColor redColor]];
        [cell.assignmentName setTextColor:[UIColor whiteColor]];
        [cell.assignmentDueDate setTextColor:[UIColor whiteColor]];
        [cell.assignmentTime setTextColor:[UIColor whiteColor]];
        cell.infoButton.tintColor = [UIColor whiteColor];
    } else {
        if (indexPath.row % 2) {
            [cell setBackgroundColor:[UIColor whiteColor]];
        } else {
            [cell setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0]];
        }
        [cell.assignmentName setTextColor:[UIColor blackColor]];
        [cell.assignmentDueDate setTextColor:[UIColor blackColor]];
        [cell.assignmentTime setTextColor:[UIColor blackColor]];
        cell.infoButton.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    }
    [cell.infoButton addTarget:self action:@selector(infoButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    NSNumber *obj = [NSNumber numberWithInteger:indexPath.row];
    if ([SelectedRows containsObject:obj])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:toDoItem.itemName attributes:attributes];
        cell.assignmentName.attributedText = attributedString;
        
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:0]};
        NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:toDoItem.itemName attributes:attributes];
        cell.assignmentName.attributedText = attributedString;
    }
    
    return cell;
}

-(void)infoButtonSelected:(UIButton*)sender {
    //Create a new view that contains the assignment's information in that view
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    AssignmentTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailedAssignmentViewController *davc = [storyboard instantiateViewControllerWithIdentifier:@"detailedAssignment"];
    davc.name = cell.assignmentName.text;
    for (AssignmentItem *assignment in savedArray) {
        if ([cell.assignmentName.text isEqualToString:assignment.itemName]) {
            davc.assignmentDate = assignment.creationDate;
            davc.notes = assignment.notes;
            davc.lecture = assignment.associatedLecture;
            davc.completed = assignment.completed;
        }
    }
    [davc setDelegate:self];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:davc];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Table view delegate

/* Adds checkmark to selected rows */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *obj = [NSNumber numberWithInteger:indexPath.row];
    if ([SelectedRows containsObject:obj])
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [SelectedRows removeObject:obj];
        [tableView reloadData];
        
    } else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [SelectedRows addObject:obj];
        [tableView reloadData];
    }
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:SelectedRows forKey:@"SelectedRows"];
    [userDef synchronize];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) { 
        //add code here for when you hit delete
        AssignmentItem *removedItem = [savedArray objectAtIndex:indexPath.row];
        [savedArray removeObject:removedItem];
        [self.toDoItems removeObject:removedItem];
        [AssignmentItem replaceArrayOfAssignmentsWith:savedArray];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
     }
}

// Rows can be reordered
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Allows for rows to be reordered
- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    AssignmentItem *movedItem = [savedArray objectAtIndex:sourceIndexPath.row];
    [savedArray removeObject:movedItem];
    [savedArray insertObject:movedItem atIndex:destinationIndexPath.row];
    [AssignmentItem replaceArrayOfAssignmentsWith:savedArray];
    [self.toDoItems removeAllObjects];
    [self loadInitialData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end