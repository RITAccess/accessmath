//
//  SearchViewController.m
//  AccessLecture
//
//  Created by Michael on 4/15/14.
//
//

#import "SearchViewController.h"

#import "Promise.h"
#import "AMLecture.h"
#import "FileManager.h"

@interface SearchViewController () <UITableViewDataSource>

@property (strong, nonatomic) Promise *document;

@end

@implementation SearchViewController
{
    @private
    UITableViewController *sidePanelController;
    UIViewController *mainController;
    NSArray *recents;
    NSArray *lectures;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Get references
    UINavigationController *sideNav = self.childViewControllers[0];
    sidePanelController = sideNav.childViewControllers[0];
    mainController = self.childViewControllers[1];

    sidePanelController.tableView.dataSource = self;
    [sidePanelController.tableView reloadData];
    sidePanelController.title = @"Browse Lectures";
    mainController.view.backgroundColor = [UIColor colorWithRed:0.009 green:0.085 blue:0.047 alpha:0.600];

    recents = @[@"April 2", @"April 5", @"April 6"];
    lectures = [@[@"Jan 1", @"Jan 14", @"Feb 18", @"March 19", @"March 20", @"March 24", @"March 30"] arrayByAddingObjectsFromArray:recents];

    [self loadLectures];
}

/**
 *  Loads the lectres into recents and lectures
 */
- (void)loadLectures
{
    NSString *path = [FileManager localDocumentsDirectoryPath];
    NSArray *contents = [FileManager listContentsOfDirectory:path];
    NSMutableArray *lec = [NSMutableArray new];
    for (NSString *file in contents) {
        NSString *title = [file componentsSeparatedByString:@"."][0];
        [lec addObject:title];
    }
    recents = lec;
    lectures = lec;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Side Panel TableView DataSouce

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.textLabel.text = recents[indexPath.row];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = lectures[indexPath.row];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Recent";
    } else if (section == 1) {
        return @"All Document";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return recents.count;
    }
    return lectures.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

@end
