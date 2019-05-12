//
//  NewNotesViewController.m
//  LandScapeV2
//
//  Created by Kimberly Sookoo on 7/31/15.
//  Copyright (c) 2015 Kimberly Sookoo. All rights reserved.
//

#import "NewNotesViewController.h"
#import "HighlighterViewController.h"
#import "saveColor.h"
#import "SaveImage.h"
#import "SaveTextSize.h"

#import "NewNotesSideViewController.h"

#import "ALView+PureLayout.h"
#import "NSArray+PureLayout.h"
#import "NavBackButton.h"

#import "MoreShuffle.h"
#import "Note.h"
#import "NoteTopImageViewController.h"

@interface NewNotesViewController () <NewNotesSideViewControllerDelegate>

@property (nonatomic, strong) NewNotesSideViewController *sideViewController;
@property (nonatomic, assign) BOOL showingSideView;

@property IBOutlet UITextField *currentDate;
@property (strong, nonatomic) IBOutlet UIButton *addImageButton;
@property (strong, nonatomic) IBOutlet UIButton *addImageButton2;
@property (strong, nonatomic) IBOutlet UIButton *addImageButton3;
@property (strong, nonatomic) IBOutlet UIButton *addImageButton4;


@end

@implementation NewNotesViewController
{
    NSMutableArray *highlighterColorChoices;
    NSMutableArray *textColorChoices;
    
    //PopOverViewController for highlighter color
    UIPopoverController *popover;
    //PopOverViewController for text color
    UIPopoverController *textPopover;
    
    NSArray *_navigationItems;
    
    NSString *noteTitle;
    CGPoint currentNoteLocation;
    NSMutableDictionary *currentNoteDetails;
    
    BOOL isAddingImage1;
    BOOL isAddingImage2;
    BOOL isAddingImage3;
    BOOL isAddingImage4;
    BOOL isViewingImage1;
    BOOL isViewingImage2;
    BOOL isViewingImage3;
    BOOL isViewingImage4;
}

//x and y values
CGFloat x = 5;
CGFloat y = 15;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //date things
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [[NSDate alloc]init];
    NSString *theDate = [dateFormat stringFromDate:now];
    _currentDate.text = theDate;
    _currentDate.userInteractionEnabled = NO;
    
    highlighterColorChoices = [[NSMutableArray alloc] initWithObjects:[UIColor colorWithRed:127.0f/255.0f green:226.0f/255.0f blue:255.0f/255.0f alpha:1.0], [UIColor colorWithRed:245.0f/255.0f green:255.0f/255.0f blue:0.0f/255.0f alpha:1.0], [UIColor colorWithRed:208.0f/255.0f green:164.0f/255.0f blue:237.0f/255.0f alpha:1.0], [UIColor colorWithRed:108.0f/255.0f green:255.0f/255.0f blue:95.0f/255.0f alpha:1.0], [UIColor colorWithRed:253.0f/255.0f green:153.0f/255.0f blue:176.0f/255.0f alpha:1.0], [UIColor colorWithRed:233.0f/255.0f green:215.0f/255.0f blue:255.0f/255.0f alpha:1.0], [UIColor colorWithRed:154.0f/255.0f green:159.0f/255.0f blue:91.0f/255.0f alpha:1.0], [UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:226.0f/255.0f alpha:1.0], [UIColor colorWithRed:107.0f/255.0f green:191.0f/255.0f blue:211.0f/255.0f alpha:1.0], [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:236.0f/255.0f alpha:1.0], [UIColor colorWithRed:255.0f/255.0f green:62.0f/255.0f blue:62.0f/255.0f alpha:1.0], [UIColor colorWithRed:132.0f/255.0f green:100.0f/255.0f blue:174.0f/255.0f alpha:1.0], [UIColor colorWithRed:255.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1.0], [UIColor colorWithRed:212.0f/255.0f green:255.0f/255.0f blue:170.0f/255.0f alpha:1.0], [UIColor colorWithRed:101.0f/255.0f green:188.0f/255.0f blue:255.0f/255.0f alpha:1.0], nil];
    
    textColorChoices = [[NSMutableArray alloc] initWithObjects:[UIColor blackColor], [UIColor blueColor], nil];
    
    [_textView sizeThatFits:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
    //creates the additional option to highlight the selected text
    UIMenuItem *highlightText = [[UIMenuItem alloc] initWithTitle:@"Highlight" action:@selector(highlightText)];
    
    [[UIMenuController sharedMenuController] setMenuItems:@[highlightText]];
    
    if ([SaveColor sharedData].highlighted != nil) {
        for (NSMutableAttributedString *string in [SaveColor sharedData].highlighted) {
            _textView.attributedText = string;
        }
    }
    
    [self setupGestures];
    [self setUpNavigation];
    
    noteTitle = [self noteData][@"title"];
    NSValue *currentNoteLocationNSValue = [self noteData][@"noteLocation"];
    currentNoteLocation = currentNoteLocationNSValue.CGPointValue;
    self.textView.text = [self noteData][@"content"];
    self.imageView.image = [self noteData][@"topImage"];
    self.imageView2.image = [self noteData][@"image2"];
    self.imageView3.image = [self noteData][@"image3"];
    self.imageView4.image = [self noteData][@"image4"];
}

//sends out notification that orientation has been changed
-(void)viewWillAppear:(BOOL)animated
{
    if ([SaveImage sharedData].notesImage != nil) {
        _imageView.image = [SaveImage sharedData].notesImage;
    }
    
    [self removeSideView];
    
    if ([SaveColor sharedData].textColor != nil) {
        _textView.textColor = [SaveColor sharedData].textColor;
    }
    
    if ([SaveTextSize sharedData].textFont != nil) {
        _textView.font = [SaveTextSize sharedData].textFont;
    }
}

#pragma mark - Navbar Setup

- (void)setUpNavigation
{
    UIButton *back = ({
        UIButton *b = [NavBackButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(dismissNewNoteViewController) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - Set Up Sidebar view

-(UIView *)getSideView
{
    // init view if it doesn't already exist
    if (_sideViewController == nil)
    {
        // this is where you define the view for the right panel
        _sideViewController = [[NewNotesSideViewController alloc] init];
        _sideViewController.delegate = self;
        _sideViewController.view.backgroundColor = [UIColor grayColor];
        
        [self.view addSubview:_sideViewController.view];
        
        [self addChildViewController:_sideViewController];
        [_sideViewController didMoveToParentViewController:self];
        
        _sideViewController.view.frame = CGRectMake(500, 0, 300, self.view.frame.size.height);
    }
    
    _showingSideView = YES;
    
    
    UIView *view = _sideViewController.view;
    return view;
}

-(void)removeSideView
{
    if (_sideViewController != nil) {
        [_sideViewController.view removeFromSuperview];
        _sideViewController = nil;
    }
    _showingSideView = NO;
}

#pragma mark Swipe Gesture Setup/Actions

- (void)setupGestures
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(getSideView)];
    [swipeLeft setNumberOfTouchesRequired:2];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(removeSideView)];
    [swipeRight setNumberOfTouchesRequired:2];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
}

#pragma mark: Text View Section

- (IBAction)changeFontSize:(UIStepper*)sender
{
    
    _textView.font = [_textView.font fontWithSize:[sender value]];
    [SaveTextSize sharedData].textFont = _textView.font;
    [[SaveTextSize sharedData] save];
}

- (IBAction)changeFontStyle:(UISegmentedControl *)sender
{
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            [_textView setFont:[UIFont systemFontOfSize:_textView.font.pointSize]];
            break;
        case 1:
            [_textView setFont:[UIFont boldSystemFontOfSize:_textView.font.pointSize]];
            break;
        case 2:
            [_textView setFont:[UIFont italicSystemFontOfSize:_textView.font.pointSize]];
            break;
        default:
            break;
    }
}

- (IBAction)changeTextColor:(UIBarButtonItem *)sender
{
    
    UIViewController *newNote = [[UIViewController alloc] init];
    textPopover = [[UIPopoverController alloc] initWithContentViewController:newNote];
    textPopover.delegate = self;
    
    textPopover.popoverContentSize = CGSizeMake(285, 200);
    
    for (UIColor *currentColor in textColorChoices) {
        
        UIButton *color = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 50, 50)];
        color.backgroundColor = currentColor;
        color.layer.borderColor = [UIColor blackColor].CGColor;
        color.layer.borderWidth = 1.0f;
        color.layer.cornerRadius = 10.0f;
        [color addTarget:self action:@selector(changeColorText:) forControlEvents:UIControlEventTouchUpInside];
        
        [textPopover.contentViewController.view addSubview:color];
        
        if (x < 225) {
            x += 55;
        } else {
            x = 5;
            y += 55;
        }
    }
    
    x = 5;
    y = 15;
    
    self.textPopOverController = textPopover;
    
    [self.textPopOverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)changeColorText: (UIButton*)sender{
    [SaveColor sharedData].textColor = sender.backgroundColor;
    [self.popOverController dismissPopoverAnimated:true];
    [[SaveColor sharedData] save];
    
    _textView.textColor = sender.backgroundColor;
}

#pragma mark Highlighter Section

- (IBAction)changeHighlighterColor:(UIBarButtonItem *)sender
{
    
    HighlighterViewController *newNote = [[HighlighterViewController alloc] init];
    popover = [[UIPopoverController alloc] initWithContentViewController:newNote];
    popover.delegate = self;
    
    popover.popoverContentSize = CGSizeMake(285, 200);
    
    for (UIColor *currentColor in highlighterColorChoices) {
        
        UIButton *color = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 50, 50)];
        color.backgroundColor = currentColor;
        color.layer.borderColor = [UIColor blackColor].CGColor;
        color.layer.borderWidth = 1.0f;
        color.layer.cornerRadius = 10.0f;
        [color addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
        
        [popover.contentViewController.view addSubview:color];
        
        if (x < 225) {
            x += 55;
        } else {
            x = 5;
            y += 55;
        }
    }
    
    x = 5;
    y = 15;
    
    self.popOverController = popover;
    
    [self.popOverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

//Uses NSMutableAttributedString to highlight the text selected by the user.
-(void)highlightText
{
    NSRange selectedRange = _textView.selectedRange;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
    
    if ([SaveColor sharedData].hightlightColor != nil) {
        [attributedString addAttribute:NSBackgroundColorAttributeName value:[SaveColor sharedData].hightlightColor range:selectedRange];
    } else {
        [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:selectedRange];
    }
    
    _textView.attributedText = attributedString;
    [[SaveColor sharedData].highlighted addObject:attributedString];
    [[SaveColor sharedData] save];
}

-(void)changeHighlightColor:(UIButton*)sender
{
    [SaveColor sharedData].hightlightColor = sender.backgroundColor;
    [self.popOverController dismissPopoverAnimated:true];
    [[SaveColor sharedData] save];
}

//Added by Mohammad Rafique - Issue #197
- (IBAction)addImage:(id)sender {
    isAddingImage1 = YES;
    isAddingImage2 = NO;
    isAddingImage3 = NO;
    isAddingImage4 = NO;
    
    [self displayAddImageAlertOnButton:[self addImageButton]];
}

- (IBAction)addImage2:(id)sender {
    isAddingImage1 = NO;
    isAddingImage2 = YES;
    isAddingImage3 = NO;
    isAddingImage4 = NO;
    
    [self displayAddImageAlertOnButton:[self addImageButton2]];
}

- (IBAction)addImage3:(id)sender {
    isAddingImage1 = NO;
    isAddingImage2 = NO;
    isAddingImage3 = YES;
    isAddingImage4 = NO;
    
    [self displayAddImageAlertOnButton:[self addImageButton3]];
}

- (IBAction)addImage4:(id)sender {
    isAddingImage1 = NO;
    isAddingImage2 = NO;
    isAddingImage3 = NO;
    isAddingImage4 = YES;
    
    [self displayAddImageAlertOnButton:[self addImageButton4]];
}

-(void)displayAddImageAlertOnButton:(UIButton*)imageButton
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Add an Image"
                                 message:@"Take a photo or choose one from existing"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* takePhotoButton = [UIAlertAction
                                      actionWithTitle:@"Take Photo"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action) {
                                          [self takePhoto];
                                      }];
    [alert addAction:takePhotoButton];
    UIAlertAction* choosePhotoButton = [UIAlertAction
                                        actionWithTitle:@"Choose Photo"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            [self choosePhoto];
                                        }];
    [alert addAction:choosePhotoButton];
    alert.popoverPresentationController.sourceView = imageButton;
    alert.popoverPresentationController.sourceRect = [imageButton bounds];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)takePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)choosePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    if (isAddingImage1) {
        self.imageView.image = chosenImage;
    }
    else if (isAddingImage2) {
        self.imageView2.image = chosenImage;
    }
    else if (isAddingImage3) {
        self.imageView3.image = chosenImage;
    }
    else if (isAddingImage4) {
        self.imageView4.image = chosenImage;
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)viewImage:(id)sender {
    isViewingImage1 = YES;
    isViewingImage2 = NO;
    isViewingImage3 = NO;
    isViewingImage4 = NO;
    
    [self performSegueWithIdentifier:@"noteTopImageScreen" sender:nil];
}

- (IBAction)viewImage2:(id)sender {
    isViewingImage1 = NO;
    isViewingImage2 = YES;
    isViewingImage3 = NO;
    isViewingImage4 = NO;
    
    [self performSegueWithIdentifier:@"noteTopImageScreen" sender:nil];
}

- (IBAction)viewImage3:(id)sender {
    isViewingImage1 = NO;
    isViewingImage2 = NO;
    isViewingImage3 = YES;
    isViewingImage4 = NO;
    
    [self performSegueWithIdentifier:@"noteTopImageScreen" sender:nil];
}

- (IBAction)viewImage4:(id)sender {
    isViewingImage1 = NO;
    isViewingImage2 = NO;
    isViewingImage3 = NO;
    isViewingImage4 = YES;
    
    [self performSegueWithIdentifier:@"noteTopImageScreen" sender:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"noteTopImageScreen"]) {
        NoteTopImageViewController *ntivc = (NoteTopImageViewController*)((UINavigationController *)segue.destinationViewController).childViewControllers.firstObject;
        
        if (isViewingImage1) {
            ntivc.noteTopImage = [[self imageView] image];
        }
        else if (isViewingImage2) {
            ntivc.noteTopImage = [[self imageView2] image];
        }
        else if (isViewingImage3) {
            ntivc.noteTopImage = [[self imageView3] image];
        }
        else if (isViewingImage4) {
            ntivc.noteTopImage = [[self imageView4] image];
        }
    }
}


- (IBAction)saveNotes:(id)sender {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Alert"
                                 message:@"Note Title"
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.text = noteTitle;
        textField.placeholder = @"Enter note title";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle your Cancel button action here
                                       
                                   }];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   noteTitle = alert.textFields.firstObject.text;
                                   [self continueSave];
                               }];
    [alert addAction:cancelButton];
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)continueSave
{
    NSString *content = [[self textView] text];
    UIImage *currentTopImage = [[self imageView] image];
    currentNoteDetails[@"title"] = noteTitle;
    currentNoteDetails[@"content"] = content;
    currentNoteDetails[@"topImage"] = currentTopImage;
    currentNoteDetails[@"image2"] = [[self imageView2] image];
    currentNoteDetails[@"image3"] = [[self imageView3] image];
    currentNoteDetails[@"image4"] = [[self imageView4] image];
    
    NoteTakingNote *newNoteN;
    NSManagedObjectContext *nmoc1 = [self managedObjectContextForLecture:_selectedLecture];
    
    if(!(_nsv.shuffleSKScene.isLastTouchedNodeNew))
    {
        newNoteN = _nsv.shuffleSKScene.getTouchedNote;
        if(!(newNoteN))
        {
            newNoteN = [NoteTakingNote insertInManagedObjectContext:nmoc1];
        }
    }
    else
    {
        newNoteN = [NoteTakingNote insertInManagedObjectContext:nmoc1];
    }
    
    Note *newNoteParent = [Note insertInManagedObjectContext:nmoc1];
    
    [newNoteParent setId:self.noteID];
    [newNoteN setNote:newNoteParent];
    [newNoteN setNoteid:self.noteID];
    [[newNoteN note] setTitle:noteTitle];
    [[newNoteN note] setContent:content];
    [[newNoteN note] setTopImage:currentTopImage];
    [[newNoteN note] setImage2:[[self imageView2] image]];
    [[newNoteN note] setImage3:[[self imageView3] image]];
    [[newNoteN note] setImage4:[[self imageView4] image]];
    [newNoteN setLocation:currentNoteLocation];
    
    [_nsv.shuffleSKScene.notesToSelectedLecture addObject:newNoteN];
    NSArray* notes;
    NSSet *setOfNotes;
    notes = [[NSArray alloc] initWithArray:_nsv.shuffleSKScene.notesToSelectedLecture];
    setOfNotes = [[NSSet alloc] initWithArray:notes];
    [_nsv.selectedLecture.lecture addNotes:setOfNotes];
    [self dismissNewNoteViewController];
}

//Gets the managed object context from AccessLectureAppDelegate
- (NSManagedObjectContext *)managedObjectContextForLecture:(AMLecture*)lecture {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContextForLecture:) withObject:lecture]) {
        context = [delegate managedObjectContextForLecture:lecture];
    }
    return context;
}

#pragma mark - Segue

- (void)dismissNewNoteViewController
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"DEBUG: Dismissed NewNotesViewController.");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
