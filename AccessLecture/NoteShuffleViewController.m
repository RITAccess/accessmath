//
//  NoteShuffleViewController.m
//  LandScapeV2
//
//  Created by Student on 6/16/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "NoteShuffleViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "MoreShuffle.h"
#import "weeksNotesViewController.h"
#import "NewNotesViewController.h"

#import "Promise.h"
#import "ALView+PureLayout.h"
#import "NSArray+PureLayout.h"
#import "NavBackButton.h"

@interface NoteShuffleViewController () {
    @private
        NSArray *_navigationItems;
}
@end

@implementation NoteShuffleViewController : UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentWeeksNotesViewController) name:@"gotoNotes" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentNewNotesViewController) name:@"gotoNewNotes" object:nil];
    [self setUpNavigation];
}

# pragma mark - Navbar

- (void)setUpNavigation
{
    UIButton *back = ({
        UIButton *b = [NavBackButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(dismissNoteShuffleViewController) forControlEvents:UIControlEventTouchUpInside];
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

- (void)dismissNoteShuffleViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"DEBUG: Dismissed NoteShuffleViewController.");
    }];
}

-(void) viewWillAppear:(BOOL)animated
{
    MoreShuffle *math = [[MoreShuffle alloc] initWithSize:CGSizeMake(2000, 1768)];
    SKView *view = (SKView *) self.view;
    [view presentScene:math];
}

-(void) presentWeeksNotesViewController
{
    // TODO: connect if need be
    [self performSegueWithIdentifier:@"toNoteSelectViewController" sender:nil];
//    weeksNotesViewController *wViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabView"];
//    [self.navigationController pushViewController:wViewController animated:YES];
}

-(void) presentNewNotesViewController
{
    // TODO: connect if need be

    [self performSegueWithIdentifier:@"toNewNote" sender:nil];
//    NewNotesViewController *wViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"newNotes"];
//    [self.navigationController pushViewController:wViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
