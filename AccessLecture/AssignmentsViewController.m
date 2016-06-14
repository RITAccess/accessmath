
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

@interface AssignmentsViewController () <NewAssignmentDelegate, UITextFieldDelegate>
{
    NSMutableArray *SelectedRows;
}

@property (weak, nonatomic) IBOutlet UITextField *currDate;

@end

@implementation AssignmentsViewController{
    NewAssignmentViewController *navc;
    UIPopoverController *popover;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //date things
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [[NSDate alloc]init];
    NSString *theDate = [dateFormat stringFromDate:now];
    _currDate.text = theDate;
    _currDate.userInteractionEnabled = NO;
    
    //initialize the arrays here
    self.toDoItems = [[NSMutableArray alloc] init];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    SelectedRows = [NSMutableArray arrayWithArray:[userDef objectForKey:@"SelectedRows"]];
    
    [self loadInitialData];
}

/*
 * Loads everything statically for the intial information that goes into the array
 */
-(void) loadInitialData
{
    for (NSString *name in [SaveAssignments sharedData].savedArray) {
        AssignmentItem *newItem = [[AssignmentItem alloc] init];
        newItem.itemName = name;
        newItem.creationDate = [[SaveAssignments sharedData].savedAssignments objectForKey:name];
        [self.toDoItems addObject:newItem];
    }
}

#pragma mark - New Assignment

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toNewAssignmentViewController"]) {
        navc = segue.destinationViewController;
        [navc setDelegate:self];
    }
}

-(void) didDismissView {
    [self.toDoItems removeAllObjects];
    [self loadInitialData];
    [self.tableView reloadData];
}

- (IBAction)editButton:(UIBarButtonItem*)sender {
    //Permits editing of rows
    if ([sender.title isEqualToString:@"Edit"]) {
        self.editing = YES;
        [sender setTitle:@"Done"];
    } else {
        self.editing = NO;
        [self.tableView reloadData];
        [sender setTitle:@"Edit"];
    }
}

#pragma mark - Edit Names of Assignments

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [SaveAssignments sharedData].initialName = textField.text;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
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
    [self.toDoItems removeAllObjects];
    
    [self loadInitialData];
    
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
    
    if (indexPath.row % 2) {
        [cell setBackgroundColor:[UIColor whiteColor]];
    } else {
        [cell setBackgroundColor:[UIColor lightGrayColor]];
    }
    
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
        AssignmentItem *removedItem = [self.toDoItems objectAtIndex:indexPath.row];
        [self.toDoItems removeObjectAtIndex:indexPath.row];
        [[SaveAssignments sharedData].savedAssignments removeObjectForKey:removedItem.itemName];
        [[SaveAssignments sharedData].savedArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[SaveAssignments sharedData] save];
        [self.tableView reloadData];
    }
}

// Rows can be reordered
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}

// Allows for rows to be reordered
- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSString *stringToMove = self.toDoItems[sourceIndexPath.row];
    AssignmentItem *movedItem = [self.toDoItems objectAtIndex:sourceIndexPath.row];
    [self.toDoItems removeObjectAtIndex:sourceIndexPath.row];
    [self.toDoItems insertObject:stringToMove atIndex:destinationIndexPath.row];
    [[SaveAssignments sharedData].savedArray removeObject:movedItem.itemName];
    [[SaveAssignments sharedData].savedArray insertObject:movedItem.itemName atIndex:destinationIndexPath.row];
    [[SaveAssignments sharedData] save];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end