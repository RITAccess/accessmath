
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

@interface AssignmentsViewController () <NewAssignmentDelegate, UITextFieldDelegate, DetailedAssignmentDelegate>
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
    
    //check to see if sorting algorithm for assignments was selected
    if ([SaveAssignments sharedData].segmentSelected) {
        self.segmentChoice.selectedSegmentIndex = [SaveAssignments sharedData].segment;
    }
    
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
    for (NSString *name in [SaveAssignments sharedData].savedArray) {
        AssignmentItem *newItem = [[AssignmentItem alloc] init];
        newItem.itemName = name;
        newItem.creationDate = [[SaveAssignments sharedData].savedAssignments objectForKey:name];
        [self.toDoItems addObject:newItem];
    }
}

#pragma mark - Bubble Sort Algorithm for Date

-(void) bubbleSortForDate {
    for (int i = 0; i < [[SaveAssignments sharedData].savedArray count]; i++) {
        for (int j = i; j < [[SaveAssignments sharedData].savedArray count]; j++) {
            if ([[[SaveAssignments sharedData].savedAssignments objectForKey:[[SaveAssignments sharedData].savedArray objectAtIndex:i]] compare:[[SaveAssignments sharedData].savedAssignments objectForKey:[[SaveAssignments sharedData].savedArray objectAtIndex:j]]] == NSOrderedDescending) {
                NSString *temp = [[SaveAssignments sharedData].savedArray objectAtIndex:i];
                [[SaveAssignments sharedData].savedArray replaceObjectAtIndex:i withObject:[[SaveAssignments sharedData].savedArray objectAtIndex:j]];
                [[SaveAssignments sharedData].savedArray replaceObjectAtIndex:j withObject:temp];
            }
        }
    }
}

#pragma mark - Alphabetical & Reverse Alphabetical Sort

- (void) alphabetSort {
    NSArray *sortedArray =  [[SaveAssignments sharedData].savedArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [[SaveAssignments sharedData].savedArray removeAllObjects];
    [[SaveAssignments sharedData].savedArray setArray:sortedArray];
}

- (void) reverseAlphabetSort {
    [self alphabetSort];
    NSUInteger start = 0;
    NSUInteger end = [[SaveAssignments sharedData].savedArray count]-1;
    while (start < end) {
        [[SaveAssignments sharedData].savedArray exchangeObjectAtIndex:start withObjectAtIndex:end];
        start++;
        end--;
    }
}

- (IBAction)sortingChoice:(UISegmentedControl *)sender {
    [SaveAssignments sharedData].segment = sender.selectedSegmentIndex;
    [SaveAssignments sharedData].segmentSelected = YES;
    [[SaveAssignments sharedData] save];
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self bubbleSortForDate];
            break;
        case 1:
            [self alphabetSort];
            break;
        case 2:
            [self reverseAlphabetSort];
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

-(void)changeText {
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
    self.editing = NO;
    [_editButton setTitle:@"Edit"];
    [self.toDoItems removeAllObjects];
    [self loadInitialData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.editing = YES;
    [_editButton setTitle:@"Done"];
    [SaveAssignments sharedData].initialName = textField.text;
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [SaveAssignments sharedData].changedName = textField.text;
    [textField resignFirstResponder];
    [self changeText];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [SaveAssignments sharedData].changedName = textField.text;
    [textField resignFirstResponder];
    [self changeText];
    
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
    
    // Configure the view for the selected state
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoButton.frame = CGRectMake(690,8,30, 30);
    [infoButton addTarget:self action:@selector(infoButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:infoButton];
    
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
    davc.date = cell.assignmentDueDate.text;
    davc.time = cell.assignmentTime.text;
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