//
//  NoteSearchTableViewController.m
//  AccessLecture
//
//  Created by Piper on 9/14/15.
//
//

#import "AccessLectureKit.h"  // for AccessBlue zebra-cells
#import "NoteSearchTableViewController.h"
#import "NoteSearchResultsViewController.h"

@implementation NoteSearchTableViewController
{
    NoteSearchResultsViewController *_resultsViewController;
}


-(void)viewDidLoad
{
    _filteredSearchNotes = [NSMutableArray new];
    
    // Bubble up VC stack to get reference to detail VC
    _resultsViewController = ((NoteSearchResultsViewController*)((UISplitViewController*)self.splitViewController).childViewControllers[1]);
}

#pragma mark - Content Filtering

// Called every time a user types in the search field
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [_filteredSearchNotes removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    _filteredSearchNotes = [NSMutableArray arrayWithArray:[_searchedNotes filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods

// Tells the table data source to reload when text changes
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{

    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;     // Return YES to cause the search result table view to be reloaded.
}

// Tells the table data source to reload when scope bar selection changes
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {

    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;     // Return YES to cause the search result table view to be reloaded.
}

#pragma mark - Side Panel TableView DataSouce

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchedNotes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* searchViewControllerIdentifier = @"noteCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:searchViewControllerIdentifier forIndexPath:indexPath];
    
    // Search results VS. normal results
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (_filteredSearchNotes.count > indexPath.row) {
            cell.textLabel.text = [_filteredSearchNotes objectAtIndex:indexPath.row];
            cell.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor whiteColor] : [AccessLectureKit accessBlue];      // Zebra-stripe alternate cells
        }
      return cell;
    } else {
        if (!cell) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchViewControllerIdentifier];
        }
        cell.textLabel.text = [_searchedNotes objectAtIndex:indexPath.row];
        cell.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor whiteColor] : [AccessLectureKit accessBlue];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"DEBUG: Selected at indexPath: %d", indexPath.row);
    
    // TODO: stubbed for now
    [_resultsViewController presentNote:nil];
}

@end
