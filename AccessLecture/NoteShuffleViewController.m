//
//  NoteShuffleViewController.m
//  LandScapeV2
//
//  Created by Student on 6/16/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "NoteTakingNote.h"

#import "NoteShuffleViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "WeeksNotesViewController.h"
#import "NewNotesViewController.h"

#import "Promise.h"
#import "ALView+PureLayout.h"
#import "NSArray+PureLayout.h"
#import "NavBackButton.h"
#import "NewLectureButton.h"
#import "NoteResetButton.h"
#import "StackPapersButton.h"

@interface NoteShuffleViewController ()
{
    @private
    NSArray *_navigationItems;
    
    UIButton *new;
}

//@property (strong) MoreShuffle *shuffleSKScene;

@end

@implementation NoteShuffleViewController : UIViewController

#pragma mark - Views

-(void) viewWillAppear:(BOOL)animated
{
    NSArray* notes = [[NSArray alloc]initWithArray:_selectedLecture.notes];
    // Pass notes to MoreShuffle
    self.shuffleSKScene = [[MoreShuffle alloc] initWithSize:CGSizeMake(2000, 1768)];
    self.shuffleSKScene.notesFromSelectedLecture = notes;
    
    SKView *view = (SKView *)self.view;
    [view presentScene:self.shuffleSKScene];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentWeeksNotesViewController) name:@"gotoNotes" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentNewNotesViewController) name:@"gotoNewNotes" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(duplicateNewNote)
                                                 name:@"DuplicateNewNoteNotification"
                                               object:nil];
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
    
    new = ({
        UIButton *b = [NewLectureButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(newPaperFromMoreShuffleClass) forControlEvents:UIControlEventTouchUpInside];
        b.accessibilityValue = @"new note";
        b;
    });
    
    UIButton *reset = ({
        UIButton *b = [NoteResetButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(newPaperFromMoreShuffleClass) forControlEvents:UIControlEventTouchUpInside];
        b.accessibilityValue = @"new lecture";
        b;
    });
    
    UIButton *stackPapers = ({
        UIButton *b = [StackPapersButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(newPaperFromMoreShuffleClass) forControlEvents:UIControlEventTouchUpInside];
        b.accessibilityValue = @"new lecture";
        b;
    });
    
    _navigationItems = @[back,new,reset,stackPapers];
    
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
            if(!([view isKindOfClass:[NewLectureButton class]]))
            {
                [view autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:previous];
            }
            else
            {
                [view autoPinEdgeToSuperviewEdge:ALEdgeRight];
                //continue;
            }
        }
        previous = view;
    }
    
    [super updateViewConstraints];
}

-(void)newPaperFromMoreShuffleClass
{
    NSLog(@"DEBUG: Clicked Add New Note Icon");
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    NSMutableAttributedString *alertTitle = [[NSMutableAttributedString alloc] initWithString:@"\nSelect note type\n"];
    [alertTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50.0] range:NSMakeRange(0, [alertTitle length])];
    NSMutableAttributedString *alertMessage = [[NSMutableAttributedString alloc] initWithString:@"\nPlease select the type of note you want to create."];
    [alertMessage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.0] range:NSMakeRange(0, [alertMessage length])];
    [alert setValue:alertTitle forKey:@"attributedTitle"];
    [alert setValue:alertMessage forKey:@"attributedMessage"];
    UIAlertAction* selectNoteButton = [UIAlertAction
                                       actionWithTitle:@"Note"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           [self.shuffleSKScene newPaper];
                                       }];
    [alert addAction:selectNoteButton];
    UIAlertAction* selectNoteTakingNoteButton = [UIAlertAction
                                                 actionWithTitle:@"NoteTakingNote"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //[self.shuffleSKScene newPaper]; //commented for now
                                                 }];
    [alert addAction:selectNoteTakingNoteButton];
    alert.popoverPresentationController.sourceView = new;
    alert.popoverPresentationController.sourceRect = [new bounds];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Segues

- (void)dismissNoteShuffleViewController
{
    /*
     * Used to adjust the lecture content view to reflect any changes in SKScene.
     */
    NSArray* notes;
    NSSet *setOfNotes;
    
    if (self.shuffleSKScene.sceneReset) {
        [_selectedLecture.lecture zeroNotes];
    }
    
    if ([self.shuffleSKScene.notesToBeRemoved count] > 0) {
        notes = [[NSArray alloc] initWithArray:self.shuffleSKScene.notesToBeRemoved];
        setOfNotes = [[NSSet alloc] initWithArray:notes];
        [_selectedLecture.lecture removeNotes:setOfNotes];
    }
    
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

-(void) duplicateNewNote
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertTitle = [[NSMutableAttributedString alloc] initWithString:@"\nAlert! Duplicate New Note!\n"];
    [alertTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50.0] range:NSMakeRange(0, [alertTitle length])];
    NSMutableAttributedString *alertMessage = [[NSMutableAttributedString alloc] initWithString:@"\nThere is already a new note created which is not saved yet"];
    [alertMessage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.0] range:NSMakeRange(0, [alertMessage length])];
    [alert setValue:alertTitle forKey:@"attributedTitle"];
    [alert setValue:alertMessage forKey:@"attributedMessage"];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your ok button action here
                               }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"toNewNote"]){
        NewNotesViewController *newNotesViewController = (NewNotesViewController*)[[[segue destinationViewController] childViewControllers] firstObject];
        NSMutableDictionary *noteData = self.shuffleSKScene.getNoteData;
        NSNumber *selectedNoteID = noteData[@"id"];
        newNotesViewController.noteID = selectedNoteID;
        newNotesViewController.noteData = noteData;
        newNotesViewController.nsv = self;
        newNotesViewController.selectedLecture = self.selectedLecture;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
