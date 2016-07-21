
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
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
    [self fiveDayWarning];
    for (NSString *name in [SaveAssignments sharedData].savedArray) {
        AssignmentItem *newItem = [[AssignmentItem alloc] init];
        newItem.itemName = name;
        newItem.creationDate = [[SaveAssignments sharedData].savedAssignments objectForKey:name];
        [self.toDoItems addObject:newItem];
    }
}

#pragma mark - Sort closest due to the top

-(void)fiveDayWarning {
    NSMutableArray *copyArray = [[NSMutableArray alloc] init];
    for (NSString *str in [SaveAssignments sharedData].savedArray) {
        [copyArray addObject:str];
    }
    NSMutableArray *closestDue = [self mergeSort:copyArray];
    
    NSMutableArray *sortedClosestDue = [[NSMutableArray alloc] init];
    for (NSString *name in closestDue) {
        NSDate *today = [NSDate date];
        NSDate *fiveDayWarning;
        if ([SaveAssignments sharedData].reminder != nil) {
            int integer = [[SaveAssignments sharedData].reminder intValue];
            fiveDayWarning = [[[SaveAssignments sharedData].savedAssignments objectForKey:name] dateByAddingTimeInterval:-integer*24*60*60];
        } else {
            fiveDayWarning = [[[SaveAssignments sharedData].savedAssignments objectForKey:name] dateByAddingTimeInterval:-5*24*60*60];
        }
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"EEE yyyy-MM-dd"];
        //NSString *theDate = [dateFormat stringFromDate:fiveDayWarning];
        if (([today compare:fiveDayWarning] == NSOrderedDescending) && ([today compare:[[SaveAssignments sharedData].savedAssignments objectForKey:name]] == NSOrderedAscending)) {
            NSString *temp = name;
            [sortedClosestDue addObject:temp];
        }
    };
    
    for (NSString *str in sortedClosestDue.reverseObjectEnumerator) {
        [[SaveAssignments sharedData].savedArray removeObject:str];
        [[SaveAssignments sharedData].savedArray insertObject:str atIndex:0];
    }
}

#pragma mark - Merge Sort Algorithm for Date

-(NSMutableArray*) mergeSort:(NSMutableArray*)list {
    //Base case, only 1 element
    if (list.count <= 1) {
        return list;
    }
    
    NSUInteger mid = [list count]/2;
    NSMutableArray *left = [[NSMutableArray alloc] init];
    NSMutableArray *right = [[NSMutableArray alloc] init];
    
    //Recursive case: divide list into equal-sized sublists
    for (NSUInteger i = 0; i < mid; i++) {
        [left addObject:[list objectAtIndex:i]];
    }
    
    for (NSUInteger i = mid; i < [list count]; i++) {
        [right addObject:[list objectAtIndex:i]];
        
    }
    
    return [self merge:[self mergeSort:left] with:[self mergeSort:right]];
}

-(NSMutableArray*) merge: (NSMutableArray*)left with: (NSMutableArray*)right {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    int leftIndex = 0;
    int rightIndex = 0;
    while ((leftIndex < [left count]) && (rightIndex < [right count])) {
        if ([[[SaveAssignments sharedData].savedAssignments objectForKey:[left objectAtIndex:leftIndex]] compare:[[SaveAssignments sharedData].savedAssignments objectForKey:[right objectAtIndex:rightIndex]]] == NSOrderedAscending) {
            [result addObject:[left objectAtIndex:leftIndex]];
            leftIndex++;
        }
        else {
            [result addObject:[right objectAtIndex:rightIndex]];
            rightIndex++;
        }
    }
    
    while(leftIndex < [left count]) {
        [result addObject:[left objectAtIndex:leftIndex]];
        leftIndex++;
    }
    
    while(rightIndex < [right count]) {
        [result addObject:[right objectAtIndex:rightIndex]];
        rightIndex++;
    }
    
    return result;
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
            [SaveAssignments sharedData].savedArray = [self mergeSort:[SaveAssignments sharedData].savedArray];
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
    [[SaveAssignments sharedData] save];
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
    if (!([textField.text isEqualToString:[SaveAssignments sharedData].initialName])) {
        [self changeText];
    }
    self.editing = NO;
    [_editButton setTitle:@"Edit"];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [SaveAssignments sharedData].changedName = textField.text;
    [textField resignFirstResponder];
    if (!([textField.text isEqualToString:[SaveAssignments sharedData].initialName])) {
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
    NSLog(@"In numberOfRows");
    return [self.toDoItems count];
}

/* Strikes through the selected rows */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Am I here?");
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
    } else {
        if (indexPath.row % 2) {
            [cell setBackgroundColor:[UIColor whiteColor]];
        } else {
            [cell setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0]];
        }
        [cell.assignmentName setTextColor:[UIColor blackColor]];
        [cell.assignmentDueDate setTextColor:[UIColor blackColor]];
        [cell.assignmentTime setTextColor:[UIColor blackColor]];
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
    davc.assignmentDate = [[SaveAssignments sharedData].savedAssignments objectForKey:cell.assignmentName.text];
    davc.notes = [[SaveAssignments sharedData].savedNotes valueForKey:cell.assignmentName.text];
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