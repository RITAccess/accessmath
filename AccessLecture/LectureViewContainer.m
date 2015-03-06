//
//  LectureViewContainer.m
//  AccessLecture
//
//  Created by Michael Timbrook on 6/26/13.
//
//

#import "DrawViewController.h"
#import "LectureViewContainer.h"
#import "StreamViewController.h"
#import "NoteTakingViewController.h"
#import "LectureNavbar.h"
#import "FileManager.h"
#import "DrawMode.h"

#import "Promise.h"

#import "ALView+PureLayout.h"
#import "NSArray+PureLayout.h"
#import "NavBackButton.h"
#import "SaveButton.h"
#import "SearchButton.h"
#import "BrushButton.h"
#import "AMLecture.h"

#import "SearchViewController.h"

#pragma mark Lecture Container Class

@interface LectureViewContainer ()

@property (weak) AMLecture *document;

@property (weak, nonatomic) IBOutlet LectureNavbar *navigationbar;
@property (strong, nonatomic) MTRadialMenu *actionMenu;

@property (strong) DrawViewController *dvc;
@property (strong) StreamViewController *svc;
@property (strong) NoteTakingViewController *ntvc;

@property (weak) UIViewController<LectureViewChild> *active;

@end

@implementation LectureViewContainer
{
    @private
    dispatch_once_t onceToken;
    NSArray *_navigationItems;
}

#pragma mark Load and Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Add button outlets
    [_navigationbar.openButton addTarget:self action:@selector(openLectureAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationbar.drawingToggle addTarget:self action:@selector(toggledDrawMode:) forControlEvents:UIControlEventValueChanged];
    [_navigationbar.backButton addTarget:self action:@selector(backNavigation) forControlEvents:UIControlEventTouchUpInside];
    [_navigationbar.searchButton addTarget:self action:@selector(openSearchAction) forControlEvents:UIControlEventTouchUpInside];

    // Add Controllers
    dispatch_once(&onceToken, ^{
        _dvc = [[DrawViewController alloc] initWithNibName:@"DrawViewController" bundle:nil];
        _ntvc = [NoteTakingViewController loadFromStoryboard];
    });
    
    [self addChildViewController:_dvc];
    [self addChildViewController:_ntvc];
    
    _ntvc.view.backgroundColor = [UIColor clearColor];
    _ntvc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_ntvc.view];
    [self.view bringSubviewToFront:_navigationbar];
    
    _dvc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self setUpNavigation];
    
    NSLog(@"Lecture view container lecture: %@", _selectedLecture);
}

- (void)viewWillAppear:(BOOL)animated
{
    [_ntvc lectureContainer:self switchedToDocument:_selectedLecture];
}

- (void)moveControlTo:(UIViewController<LectureViewChild> *)vc
{
    [self.view addSubview:[vc contentView]];
    _active = vc;
    [self.view bringSubviewToFront:_navigationbar];
}


// TODO: reusable would be nice
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
        b.accessibilityValue = @"draw";
        b;
    });
    
    _navigationItems = @[back, save, search, brush];
    
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


#pragma mark Actions

- (void)saveLecture
{
    [_selectedLecture saveWithCompletetion:^(BOOL success) {
        
    }];
}

- (void)back
{
    [self saveLecture];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openSearchAction
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *search = [sb instantiateViewControllerWithIdentifier:@"SearchViewController"];
    
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = search;
    [window makeKeyWindow];
}

- (void)presentSearch
{
    [self performSegueWithIdentifier:@"toSearch" sender:_selectedLecture];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toSearch"]) {
        ((SearchViewController *)[segue destinationViewController]).selectedLecture = sender;
    }
}

// TODO - Switch to stack based with a push and pop controller type maybe?
// TODO - disable if off
- (void)toggledDrawMode:(MKToggleButton *)sender
{
    [_dvc hideToolbar:!sender.selected];
    if (sender.selected) {
        [_dvc displayToolbarWithAnimation:YES];
        [self moveControlTo:_dvc];
    } else {
        [_dvc dismissToolbarWithAnimation:YES];
        [self.view sendSubviewToBack:_dvc.view];
    }
}

- (void)openLectureAction:(id)sender
{
//    [_ntvc lectureContainer:self switchedToDocument:nil];
//    [FileManager.defaultManager forceSave];
//    Promise *closed = [FileManager.defaultManager finishedWithDocument];
//    [closed wait:10]; // Should block till closed doc
//    Promise *lecture = [FileManager.defaultManager currentDocumentPromise];
//    [lecture when:^(AMLecture *newlecture) {
//        [_ntvc lectureContainer:self switchedToDocument:newlecture];
//    }];
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

@end
