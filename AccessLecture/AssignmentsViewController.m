
//
//  AssignmentsViewController.m
//  LandScapeV2
//
//  Created by Student on 6/24/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "AssignmentsViewController.h"
#import "AssignmentItem.h"

@interface AssignmentsViewController ()
{
    NSMutableArray *SelectedRows;
}

@property (weak, nonatomic) IBOutlet UITextField *currDate;
@property NSMutableArray *toDoItems;

@end

@implementation AssignmentsViewController

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

/*- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
 AddToDoItemViewController *source = [segue sourceViewController];
 ToDoItem *item = source.toDoItem;
 if (item != nil) {
 [self.toDoItems addObject:item];
 [self.tableView reloadData];
 }
 
 }*/

-(IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    /*UITabBarController *tc = [self.storyboard instantiateViewControllerWithIdentifier:@"tabViews"];
    [self.navigationController pushViewController:tc animated:YES];*/
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.toDoItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    AssignmentItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = toDoItem.itemName;
    //NSLog(cell.textLabel.text);
    
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

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

