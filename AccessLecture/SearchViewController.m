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
#import "FileManager.h"
#import "ALView+PureLayout.h"
#import "NSArray+PureLayout.h"
#import "NavBackButton.h"
#import "Note.h"
#import "AccessLectureKit.h"

@implementation SearchViewController
{
    @private
    UITableViewController *_sidePanelController;
    UIViewController *_mainController;
    NSArray *_lectures;
    NSArray *_notes;
    NSArray *_navigationItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Get references
    UINavigationController *sideNav = self.childViewControllers[0];
    _sidePanelController = sideNav.childViewControllers[0];
    _mainController = self.childViewControllers[1];
    _sidePanelController.tableView.delegate = self;
    _sidePanelController.tableView.dataSource = self;
    [_sidePanelController.tableView reloadData];

    [self loadLectures];
    
    [self setUpNavigation];
}

# pragma mark - Navbar

- (void)setUpNavigation
{
    UIButton *back = ({
        UIButton *b = [NavBackButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        b.accessibilityValue = @"back";
        b;
    });
    
    _navigationItems = @[back];
    
    [_navigationItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.splitViewController.navigationController.navigationBar addSubview:obj];
    }];
        [self.splitViewController.navigationController.navigationBar setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [_navigationItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view autoSetDimensionsToSize:CGSizeMake(120, 100)];
        [view autoAlignAxis:ALAxisLastBaseline toSameAxisOfView:view.superview];
        [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0 relation:NSLayoutRelationEqual];
    }];
    
    [_navigationItems.firstObject autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    UIView *previous = nil;
    for (UIView *view in _navigationItems) {
        if (previous) {
            [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:previous];
        }
        previous = view;
    }
    
    [super updateViewConstraints];
}

// TODO: clean up -- shouldn't have to pass lecture directly from LVC
- (void)loadLectures
{
    NSString *path = [FileManager localDocumentsDirectoryPath];
    NSArray *contents = [FileManager listContentsOfDirectory:path];
    NSString *lectureName;
    NSMutableArray *lec = [NSMutableArray new];
    for (NSString *file in contents) {
        lectureName = file;
        NSString *title = [file componentsSeparatedByString:@"."][0];
        [lec addObject:title];
    }
    _lectures = lec;
    
    // Update side panel controller with lecture title
    _sidePanelController.title = [_lectures objectAtIndex:0];
    
    // TODO: get lecture timestamp too
    _notes = [[NSArray alloc]initWithArray:_selectedLecture.lecture.notes];
}

#pragma mark - Side Panel TableView DataSouce

- (void)tableViewCell:(UITableViewCell *)cell becameActivePanel:(BOOL)active
{
    // TODO: anything
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _notes.count;
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [AccessLectureKit accessBlue];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* searchViewControllerIdentifier = @"noteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchViewControllerIdentifier forIndexPath:indexPath];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchViewControllerIdentifier];
    // Set the title
    cell.textLabel.text = ((Note*)[_notes objectAtIndex:indexPath.row]).title;
    return cell;
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
