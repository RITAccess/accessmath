//
//  NoteShuffleViewController.m
//  LandScapeV2
//
//  Created by Student on 6/16/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "Note.h"

#import "NoteShuffleViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "MoreShuffle.h"
#import "WeeksNotesViewController.h"
#import "NewNotesViewController.h"

#import "Promise.h"
#import "ALView+PureLayout.h"
#import "NSArray+PureLayout.h"
#import "NavBackButton.h"

@interface NoteShuffleViewController ()
{
    @private
    NSArray *_navigationItems;
}
@end

@implementation NoteShuffleViewController : UIViewController

#pragma mark - Views

-(void) viewWillAppear:(BOOL)animated
{
    NSArray* notes = [[NSArray alloc]initWithArray:_selectedLecture.lecture.notes];
    
    // Pass notes to MoreShuffle
    // TODO: fix propogation issue
    MoreShuffle *shuffleSKScene = [[MoreShuffle alloc] initWithSize:CGSizeMake(2000, 1768)];
    shuffleSKScene.notesFromSelectedLecture = notes;
    
    SKView *view = (SKView *)self.view;
    [view presentScene:shuffleSKScene];
}

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

#pragma mark - Segues

- (void)dismissNoteShuffleViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"DEBUG: Dismissed NoteShuffleViewController.");
    }];
}

-(void) presentWeeksNotesViewController
{
    [self performSegueWithIdentifier:@"toNoteSelectViewController" sender:nil];
}

-(void) presentNewNotesViewController
{
    [self performSegueWithIdentifier:@"toNewNote" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
