//
//  NewNotesViewController.h
//  LandScapeV2
//
//  Created by Student on 7/31/15.
//  Copyright (c) 2015 Student. All rights reserved.
//


@interface NewNotesViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>

@property UIPopoverController *popOverController;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)changeFontSize:(UIStepper *)sender;
- (IBAction)changeFontStyle:(UISegmentedControl *)sender;
- (IBAction)changeHighlighterColor:(UIBarButtonItem *)sender;


@end
