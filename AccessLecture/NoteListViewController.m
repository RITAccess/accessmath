//
//  NoteListViewController.m
//  AccessLecture
//
//  Created by Piper on 1/30/15.
//
//

#import <UIKit/UIKit.h>
#include "NoteListViewController.h"

@implementation NoteListViewController
{
    NSArray *notes;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    notes = [[NSArray alloc]initWithObjects:@"test", @"test",@"test",@"test",@"test",  nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return notes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* noteListViewControllerIdentifier = @"noteCell";
    UITableViewCell*  cell = [tableView dequeueReusableCellWithIdentifier:noteListViewControllerIdentifier];
    
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noteListViewControllerIdentifier];
    cell.textLabel.text = [notes objectAtIndex:indexPath.row];
    return cell;
}


@end




