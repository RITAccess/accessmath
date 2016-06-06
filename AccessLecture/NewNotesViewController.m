//
//  NewNotesViewController.m
//  LandScapeV2
//
//  Created by Kimberly Sookoo on 7/31/15.
//  Copyright (c) 2015 Kimberly Sookoo. All rights reserved.
//

#import "NewNotesViewController.h"
#import "HighlighterViewController.h"
#import "TextColorViewController.h"
#import "saveColor.h"
#import "SaveImage.h"
#import "SaveTextSize.h"
#import "DraggableView.h"
#import "NewNotesSideViewController.h"
#import "ALView+PureLayout.h"
#import "NSArray+PureLayout.h"
#import "NavBackButton.h"

@interface NewNotesViewController () <NewNotesSideViewControllerDelegate>

@property (nonatomic, strong) NewNotesSideViewController *sideViewController;
@property (nonatomic, assign) BOOL showingSideView;

@property IBOutlet UITextField *currentDate;

@end

@implementation NewNotesViewController
{
    //PopOverViewController for highlighter color
    UIPopoverController *popover;
    //PopOverViewController for text color
    UIPopoverController *textPopover;
    
    NSArray *_navigationItems;
}

CGFloat x = 50;
CGFloat y = 600;

- (void)viewDidLoad {
    [super viewDidLoad];
    //date things
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [[NSDate alloc]init];
    NSString *theDate = [dateFormat stringFromDate:now];
    _currentDate.text = theDate;
    _currentDate.userInteractionEnabled = NO;
    
    [_textView sizeThatFits:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    _textView.backgroundColor = [UIColor grayColor];
    
    //creates the additional option to highlight the selected text
    UIMenuItem *highlightText = [[UIMenuItem alloc] initWithTitle:@"Highlight" action:@selector(highlightText)];
    
    [[UIMenuController sharedMenuController] setMenuItems:@[highlightText]];
    
    if ([SaveColor sharedData].highlighted != nil) {
        for (NSMutableAttributedString *string in [SaveColor sharedData].highlighted) {
            _textView.attributedText = string;
        }
    }
    
    //[SaveImage sharedData].selectedImagesArray = nil;
    //[[SaveImage sharedData] save];
    if ([SaveImage sharedData].selectedImagesArray != nil) {
        for (DraggableView *imageView in [SaveImage sharedData].selectedImagesArray) {
            UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDected:)];
            [imageView addGestureRecognizer:panGest];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            imageView.userInteractionEnabled = YES;
            [self.view addSubview:imageView];
        }
    }
    
    [self setupGestures];
    [self setUpNavigation];
}

//sends out notification that orientation has been changed
-(void)viewWillAppear:(BOOL)animated
{
    //Adds additional images that user selects
    if ([SaveImage sharedData].notesImage != nil) {
        DraggableView *imageView = [[DraggableView alloc] initWithImage:[SaveImage sharedData].notesImage];
        UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDected:)];
        [imageView addGestureRecognizer:panGest];
        imageView.frame = CGRectMake(x, y, 100, 100);
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];
        [SaveImage sharedData].notesImage = nil;
        [[SaveImage sharedData] save];
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

#pragma mark Panning

-(void)panGestureDected:(UIPanGestureRecognizer*)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint center = recognizer.view.center;
    
    if ((center.y >= _textView.frame.origin.y-50) && (center.y <= _textView.center.y+300)) {
        //Temporary fix until better solution can be implemented
        //Set fixed coordinates to return to upon entering the text view from above
        //[UIView animateWithDuration:0.25 animations:^{recognizer.view.center = CGPointMake(200, 300);}];
        recognizer.view.center = CGPointMake(200, 300);
    } else {
        recognizer.view.center = CGPointMake((recognizer.view.center.x+translation.x), (recognizer.view.center.y+translation.y));
        [recognizer setTranslation:CGPointZero inView:self.view];
    }
    
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

#pragma mark Text Color Section

- (IBAction)changeTextColor:(UIBarButtonItem *)sender
{
    TextColorViewController *tcvc = [[TextColorViewController alloc] init];
    textPopover = [[UIPopoverController alloc] initWithContentViewController:tcvc];
    textPopover.delegate = self;
    
    textPopover.popoverContentSize = CGSizeMake(285, 200);
    
    for (UIButton *textColor in tcvc.view.subviews) {
        [textColor addTarget:self action:@selector(changeColorText:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.textPopOverController = textPopover;
    
    [self.textPopOverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)changeColorText: (UIButton*)sender{
    [SaveColor sharedData].textColor = sender.backgroundColor;
    _textView.textColor = sender.backgroundColor;
    [self.textPopOverController dismissPopoverAnimated:true];
    [[SaveColor sharedData] save];
}

#pragma mark Highlighter Section

- (IBAction)changeHighlighterColor:(UIBarButtonItem *)sender
{
    HighlighterViewController *hvc = [[HighlighterViewController alloc] init];
    popover = [[UIPopoverController alloc] initWithContentViewController:hvc];
    popover.delegate = self;
    
    popover.popoverContentSize = CGSizeMake(285, 200);
    
    for (UIButton *colour in hvc.view.subviews) {
        [colour addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    }
    
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

#pragma mark - Segue

- (void)dismissNewNoteViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"DEBUG: Dismissed NewNotesViewController.");
    }];
    [[SaveImage sharedData] save];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end