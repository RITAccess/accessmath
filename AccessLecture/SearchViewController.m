//
//  SearchViewController.m
//  AccessLecture
//
//  Created by Michael on 4/15/14.
//
//

@import ObjectiveC;

#import "SearchViewController.h"
#import "Promise.h"
#import "AMLecture.h"
#import "FileManager.h"

#define TRANSFORM_OFFSCREEN 2000

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

    [self loadLectures];
}

- (void)viewWillAppear:(BOOL)animated
{
    // TODO: necessary?
    mainController.view.transform = CGAffineTransformMakeScale(0.6, 0.6);
}

#pragma mark Method replacement

/**
 *  Gets the prepareForSegue:sender: from the TableViewController that is the side
 *  controller.
 */
- (void)interceptSegue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method localCall = class_getInstanceMethod([self class], @selector(am_prepareForSegue:sender:));
        class_replaceMethod([sidePanelController class], @selector(prepareForSegue:sender:), method_getImplementation(localCall), method_getTypeEncoding(localCall));
    });
}

/**
 *  Notifies the view controller that a segue is about to be performed.
 *
 *  @param segue  invoked seguew
 *  @param sender invoker
 */
- (void)am_prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    SearchViewController *controller = (SearchViewController *)self.parentViewController.parentViewController;
    [controller tableViewCell:sender becameActivePanel:YES];
//    LectureListViewController *vc = segue.destinationViewController;
//    vc.lectureName = sender.textLabel.text;

}

- (void)tableViewCell:(UITableViewCell *)cell becameActivePanel:(BOOL)active
{
    UIView *mainView = mainController.view;
    mainView.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.2 delay:1.0 options:UIViewAnimationCurveEaseInOut animations:^{
        mainView.transform = CGAffineTransformIdentity;
    } completion:nil];
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
    return section == 0 ? @"All Notes" : @"";
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
