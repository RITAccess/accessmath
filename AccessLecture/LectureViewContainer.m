//
//  LectureViewContainer.m
//  AccessLecture
//
//  Created by Michael Timbrook on 6/26/13.
//
//

#import "DrawViewController.h"
#import "LectureViewContainer.h"
#import "NoteTakingViewController.h"
#import "SearchViewController.h"
#import "NoteShuffleViewController.h"
#import "AMLecture.h"
#import "Promise.h"

#import "ALView+PureLayout.h"
#import "NSArray+PureLayout.h"
#import "NavBackButton.h"
#import "SaveButton.h"
#import "SearchButton.h"
#import "BrushButton.h"
#import "NoteShuffleButton.h"

#import "saveData.h"
#import "TextNoteViewController.h"

#pragma mark - Lecture Container Class

@interface LectureViewContainer ()

@property (strong, nonatomic) MTRadialMenu *actionMenu;
@property (strong) DrawViewController *dvc;
@property (strong) NoteTakingViewController *ntvc;
@property (weak) UIViewController<LectureViewChild> *active;

@end

@implementation LectureViewContainer
{
    @private
    dispatch_once_t onceToken;
    NSArray *_navigationItems;
}

#pragma mark - Load and Setup

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Add Controllers
    dispatch_once(&onceToken, ^{
        _dvc = [[DrawViewController alloc] initWithNibName:@"DrawViewController" bundle:nil];
        _ntvc = [NoteTakingViewController loadFromStoryboard];
    });
    [self addChildViewController:_dvc];
    [self addChildViewController:_ntvc];
    [self.view addSubview:_ntvc.view];

    _ntvc.view.backgroundColor = [UIColor clearColor];
    _ntvc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _dvc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self setUpNavigation];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Refresh the view with the currently selected lecture
    [_ntvc lectureContainer:self switchedToDocument:_selectedLecture];
    
    /*
     Attempt to add note to lecture view
     */
    float x = 200;
    float y = 300;
    for (int i = 0; i < [[saveData sharedData].array count]; i++) {
        Note *n = [Note new];
        n.title = @"Test";
        n.content = @"Test";
        n.location = CGPointMake(x, y);
        
        x += 50;
        y += 50;
        
        TextNoteViewController *tnvc = [[TextNoteViewController alloc] initWithNote:n];
        [self.view addSubview:tnvc.view];
    }
}

// TODO: reusable would be nice
#pragma mark - Navbar Setup

- (void)setUpNavigation
{
    UIButton *back = ({
        UIButton *b = [NavBackButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        b.accessibilityValue = @"back";
        b;
    });
    
    UIButton *save = ({
        UIButton *b = [SaveButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(saveLecture) forControlEvents:UIControlEventTouchUpInside];
        b.accessibilityValue = @"save lecture";
        b;
    });
    
    UIButton *search = ({
        UIButton *b = [SearchButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(presentSearch) forControlEvents:UIControlEventTouchUpInside];
        b.accessibilityValue = @"search";
        b;
    });
    
    UIButton *brush = ({
        UIButton *b = [BrushButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(toggleDrawViewController) forControlEvents:UIControlEventTouchUpInside];
        b.accessibilityValue = @"draw";
        b;
    });

    UIButton *shuffle = ({
        UIButton *s = [NoteShuffleButton buttonWithType:UIButtonTypeRoundedRect];
        [s addTarget:self action:@selector(toggleNoteShuffleViewController) forControlEvents:UIControlEventTouchUpInside];
        s.accessibilityValue = @"shuffle notes";
        s;
    });
    
    _navigationItems = @[back, save, search, brush, shuffle];
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


#pragma mark - Navbar Actions

- (void)saveLecture
{
    [self doCapture];
    [_selectedLecture saveWithCompletetion:^(BOOL success) {
        NSAssert(success, @"Lecture did not save.");
    }];
}

- (void)doCapture
{
    UIGraphicsBeginImageContext(self.view.window.bounds.size);
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_selectedLecture setThumb:image];
    [_selectedLecture save];
}

- (void)back
{
    [self saveLecture];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentSearch
{
    [self performSegueWithIdentifier:@"toSearch" sender:_selectedLecture];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Grabbing the SearchViewController through the segue to the navigation controller and setting its selected lecture
    if ([segue.identifier isEqualToString:@"toSearch"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ((SearchViewController *)([navigationController viewControllers][0])).selectedLecture = sender;
    } else if ([segue.identifier isEqualToString:@"toNoteShuffle"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        
        ((NoteShuffleViewController *)([navigationController viewControllers][0])).selectedLecture = sender;
    }
}

- (void)toggleDrawViewController  // backlog: consider parameterizing animation
{
    UIButton *drawButton = [_navigationItems objectAtIndex:3];  // update index

    if (drawButton.selected) {
        [_dvc dismissToolbarWithAnimation:YES];
        [self.view sendSubviewToBack:_dvc.view];
    } else {
        [_dvc displayToolbarWithAnimation:YES];
        [self moveControlTo:_dvc];
    }

    drawButton.selected = ![drawButton isSelected];
}

- (void)toggleNoteShuffleViewController
{
    [self performSegueWithIdentifier:@"toNoteShuffle" sender:nil];
}

- (void)actionFromMenu:(MTRadialMenu *)menu
{
    if ([menu.selectedIdentifier isEqualToString:@"switch"]) {
        if (_active == _dvc) {
            [self moveControlTo:_ntvc];
        } else {
            [self moveControlTo:_dvc];
        }
    }
}

- (void)moveControlTo:(UIViewController<LectureViewChild> *)vc
{
    [self.view addSubview:[vc contentView]];
    _active = vc;
}

@end
