//
//  NewNotesViewController.h
//  LandScapeV2
//
//  Created by Student on 7/31/15.
//  Copyright (c) 2015 Student. All rights reserved.
//
#import "NoteShuffleViewController.h"
#import "AMLecture.h"
#import "NoteTakingNote.h"

@interface NewNotesViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>

@property UIPopoverController *popOverController;
@property UIPopoverController *textPopOverController;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;
@property (strong, nonatomic) IBOutlet UIImageView *imageView3;
@property (strong, nonatomic) IBOutlet UIImageView *imageView4;



- (IBAction)changeFontSize:(UIStepper *)sender;
- (IBAction)changeFontStyle:(UISegmentedControl *)sender;
- (IBAction)changeHighlighterColor:(UIBarButtonItem *)sender;
- (IBAction)changeTextColor:(UIBarButtonItem *)sender;

@property (nonatomic, assign) NSNumber *noteID;
@property NSMutableDictionary *noteData;
//@property NoteTakingNote *newNoteN;
@property NoteShuffleViewController *nsv;
@property AMLecture *selectedLecture;


@end
