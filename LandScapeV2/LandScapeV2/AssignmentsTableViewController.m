//
//  AssignmentsTableViewController.m
//  LandScapeV2
//
//  Created by Kimberly Sookoo on 9/1/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "AssignmentsTableViewController.h"
#import "AssignmentItem.h"

@interface AssignmentsTableViewController ()
{
    NSMutableArray *SelectedRows;
}

@property (nonatomic) int selectedRow;
@property NSMutableArray *toDoItems;
@property NSMutableArray *completedAssignments;

@end

@implementation AssignmentsTableViewController{
    UITextField *currDate;
    UILabel *assignment;
    UILabel *dueDate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadLabels];
    
    //allots the needed space at the top to insert date and other labels
    self.tableView.contentInset = UIEdgeInsetsMake(250, 0, 0, 0);
    
    //initialize the arrays here
    self.toDoItems = [[NSMutableArray alloc] init];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    SelectedRows = [NSMutableArray arrayWithArray:[userDef objectForKey:@"SelectedRows"]];
    
    [self loadInitialData];
}

- (void) loadLabels{
    
    //date
    currDate = [[UITextField alloc] initWithFrame:CGRectMake(10, -250, 200, 30)];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [[NSDate alloc]init];
    NSString *theDate = [dateFormat stringFromDate:now];
    currDate.text = theDate;
    currDate.textColor = [UIColor blueColor];
    currDate.userInteractionEnabled = NO;
    [self.view addSubview:currDate];
    
    //assignments section
    assignment = [[UILabel alloc] initWithFrame:CGRectMake(50, -75, 200, 30)];
    assignment.text = @"Assignment";
    [self.view addSubview:assignment];
    
    //due date section
    dueDate = [[UILabel alloc] initWithFrame:CGRectMake(825, -75, 200, 30)];
    dueDate.text = @"Due Date";
    [self.view addSubview:dueDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    
}

/*
 loadInitialData loads everything statically for the intial information that goes into the array
 */
-(void) loadInitialData
{
    AssignmentItem *item1 = [[AssignmentItem alloc] init];
    item1.itemName = @"Chapter 10, section 3                                                                                                                                        4/23/15";
    [self.toDoItems addObject:item1];
    AssignmentItem *item2 = [[AssignmentItem alloc] init];
    item2.itemName = @"Chapter 10, section 5                                                                                                                                        4/25/15";
    [self.toDoItems addObject:item2];
    AssignmentItem *item3 = [[AssignmentItem alloc] init];
    item3.itemName = @"Chapter 10, section 7                                                                                                                                        4/30/15";
    [self.toDoItems addObject:item3];
    AssignmentItem *item4 = [[AssignmentItem alloc]init];
    item4.itemName = @"Chapter 10, section 9                                                                                                                                        5/2/15";
    [self.toDoItems addObject:item4];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.toDoItems count];
}

/*
 This method handles the selection and strikethrough of cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    AssignmentItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = toDoItem.itemName;
    
    NSNumber *obj = [NSNumber numberWithInteger:indexPath.row];
    if ([SelectedRows containsObject:obj])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:toDoItem.itemName attributes:attributes];
        
        cell.textLabel.attributedText = attributedString;
        
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:0]};
        NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:toDoItem.itemName attributes:attributes];
        
        cell.textLabel.attributedText = attributedString;
    }
    
    return cell;
}

#pragma mark - Table view delegate

/*
 Handles the saving of the cells.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self.toDoItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
