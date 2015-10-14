//
//  SearchViewController.m
//  AccessLecture
//
//  Created by Michael on 4/15/14.
//
//

#import "SearchViewController.h"
#import "Promise.h"
#import "FileManager.h"
#import "ALView+PureLayout.h"
#import "NSArray+PureLayout.h"
#import "NavBackButton.h"
#import "Note.h"
#import "NoteSearchTableViewController.h"

@implementation SearchViewController
{
    @private
    NoteSearchTableViewController *_sidePanelController;
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
    _sidePanelController = (NoteSearchTableViewController *)sideNav.childViewControllers[0];
    [_sidePanelController.tableView reloadData];
    _mainController = self.childViewControllers[1];

    [self populateWithLectureNotes];
    [self setUpNavigation];
}

# pragma mark - Navbar

- (void)setUpNavigation
{
    UIButton *back = ({
        UIButton *b = [NavBackButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(dismissSearch) forControlEvents:UIControlEventTouchUpInside];
        b.accessibilityValue = @"back";
        b;
    });
    
    _navigationItems = @[back];
    
    [_navigationItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [self.navigationController.navigationBar addSubview:obj];
    }];
    
    [self.navigationController.navigationBar setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [_navigationItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view autoSetDimensionsToSize:CGSizeMake(120, 100)];
        [view autoAlignAxis:ALAxisLastBaseline toSameAxisOfView:view.superview];
        [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0 relation:NSLayoutRelationEqual];
    }];
    
    // Pin the back button to the left side of the nav controller
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

- (void)dismissSearch
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"DEBUG: Dismissed Search View Controller.");
    }];
}

// TODO: clean up -- shouldn't have to pass lecture directly from LVC
- (void)populateWithLectureNotes
{
    // Update side panel controller with lecture title
    _sidePanelController.title = _selectedLecture.metadata.title;
    
    // TODO: get lecture timestamp too
    _notes = [[NSArray alloc]initWithArray:_selectedLecture.lecture.notes];
    
    // TODO: pass notes to note search view controller
    NSMutableArray *lectureNoteTitles = [NSMutableArray new];
    for (Note* note in _notes) {
        [lectureNoteTitles addObject:note.title];
    }
    
    // Pass the notes into the searchedNotes array in the NoteSearchViewController
    _sidePanelController.noteTitlesFromCurrentLecture = [NSArray arrayWithArray:lectureNoteTitles];
    _sidePanelController.notesFromCurrentLecture = [NSArray arrayWithArray:_notes];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
