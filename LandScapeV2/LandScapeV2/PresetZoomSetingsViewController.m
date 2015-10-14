//
//  PresetZoomSetingsViewController.m
//  LandScapeV2
//
//  Created by Student on 7/8/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "PresetZoomSetingsViewController.h"
#import "PresetZoomItem.h"

// remove these imports later for a settings only version of this
//#import "AssignmentsViewController.h"
//#import "AssignmentItem.h"

@interface PresetZoomSetingsViewController ()

@property NSMutableArray *toDoItems;

@end

@implementation PresetZoomSetingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.toDoItems = [[NSMutableArray alloc] init];
    [self loadInitialData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) loadInitialData
{
    PresetZoomItem *item1 = [[PresetZoomItem alloc] init];
    item1.itemName = @"x2";
    [self.toDoItems addObject:item1];
    PresetZoomItem *item2 = [[PresetZoomItem alloc] init];
    item2.itemName = @"x3";
    [self.toDoItems addObject:item2];
    PresetZoomItem *item3 = [[PresetZoomItem alloc] init];
    item3.itemName = @"x4";
    [self.toDoItems addObject:item3];
    PresetZoomItem *item4 = [[PresetZoomItem alloc]init];
    item4.itemName = @"x5";
    [self.toDoItems addObject:item4];
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
    PresetZoomItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = toDoItem.itemName;
    if (toDoItem.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

// the following two functions allow for only one row to be selected at a time
// gets rid of multiple selection issue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark - Table view delegate

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PresetZoomItem *tappedItem = [self.toDoItems objectAtIndex:indexPath.row];
    tappedItem.completed = !tappedItem.completed;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
