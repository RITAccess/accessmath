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
#import "ALView+PureLayout.h"
#import "NSArray+PureLayout.h"
#import "NavBackButton.h"

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
    NSArray *notes;
    NSArray *_navigationItems;
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

    // TODO: integrate navbar w/ splitview + navigation controller
    [self setUpNavigation];
}

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
    mainView.backgroundColor = [UIColor blueColor];
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
    NSString *lectureName;
    NSMutableArray *lec = [NSMutableArray new];
    for (NSString *file in contents) {
        lectureName = file;
        NSString *title = [file componentsSeparatedByString:@"."][0];
        [lec addObject:title];
    }
    recents = lec;
    lectures = lec;
    
    // Update side panel controller with lecture title
    sidePanelController.title = [lectures objectAtIndex:0];
    
    // TODO: get lecture timestamp too
    
    // Get notes
    AMLecture* currentLecture = [FileManager findDocumentWithName:lectureName];
    notes = [[NSArray alloc]initWithArray:[currentLecture getNotes]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Side Panel TableView DataSouce

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* searchViewControllerIdentifier = @"noteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchViewControllerIdentifier forIndexPath:indexPath];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchViewControllerIdentifier];
    cell.textLabel.text = [lectures objectAtIndex:0];
    return cell;
}



@end
