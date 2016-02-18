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
#import "NewNotesSideViewController.h"

#import "ALView+PureLayout.h"
#import "NSArray+PureLayout.h"
#import "NavBackButton.h"

#define RIGHT_PANEL_TAG 1

@interface NewNotesViewController () <NewNotesSideViewControllerDelegate>

@property (nonatomic, strong) NewNotesSideViewController *sideViewController;
@property (nonatomic, assign) BOOL showingSideView;

@property (nonatomic, assign) CGPoint preVelocity;

@property IBOutlet UITextField *currentDate;

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
    
    if ([SaveColor sharedData].textColor != nil) {
        _textView.textColor = [SaveColor sharedData].textColor;
    }
    
    highlighterColorChoices = [[NSMutableArray alloc] initWithObjects:[UIColor colorWithRed:127.0f/255.0f green:226.0f/255.0f blue:255.0f/255.0f alpha:1.0], [UIColor colorWithRed:245.0f/255.0f green:255.0f/255.0f blue:0.0f/255.0f alpha:1.0], [UIColor colorWithRed:208.0f/255.0f green:164.0f/255.0f blue:237.0f/255.0f alpha:1.0], [UIColor colorWithRed:108.0f/255.0f green:255.0f/255.0f blue:95.0f/255.0f alpha:1.0], [UIColor colorWithRed:253.0f/255.0f green:153.0f/255.0f blue:176.0f/255.0f alpha:1.0], [UIColor colorWithRed:233.0f/255.0f green:215.0f/255.0f blue:255.0f/255.0f alpha:1.0], [UIColor colorWithRed:154.0f/255.0f green:159.0f/255.0f blue:91.0f/255.0f alpha:1.0], [UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:226.0f/255.0f alpha:1.0], [UIColor colorWithRed:107.0f/255.0f green:191.0f/255.0f blue:211.0f/255.0f alpha:1.0], [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:236.0f/255.0f alpha:1.0], [UIColor colorWithRed:255.0f/255.0f green:62.0f/255.0f blue:62.0f/255.0f alpha:1.0], [UIColor colorWithRed:132.0f/255.0f green:100.0f/255.0f blue:174.0f/255.0f alpha:1.0], [UIColor colorWithRed:255.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1.0], [UIColor colorWithRed:212.0f/255.0f green:255.0f/255.0f blue:170.0f/255.0f alpha:1.0], [UIColor colorWithRed:101.0f/255.0f green:188.0f/255.0f blue:255.0f/255.0f alpha:1.0], nil];
    
    textColorChoices = [[NSMutableArray alloc] initWithObjects:[UIColor blackColor], [UIColor blueColor], nil];
    
    [_textView sizeThatFits:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
    //creates the additional option to highlight the selected text
    UIMenuItem *highlightText = [[UIMenuItem alloc] initWithTitle:@"Highlight" action:@selector(highlightText)];
    
    [[UIMenuController sharedMenuController] setMenuItems:@[highlightText]];
    
    [self setupGestures];
    [self setUpNavigation];
}

//sends out notification that orientation has been changed
-(void)viewWillAppear:(BOOL)animated
{
}

- (void)viewWillDisappear:(BOOL)animated
{
}

//removes notification
-(void)viewDidDisappear:(BOOL)animated
{
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

-(UIView *)getSideView {
    // init view if it doesn't already exist
    if (_sideViewController == nil)
    {
        // this is where you define the view for the right panel
        _sideViewController = [[NewNotesSideViewController alloc] init];
        _sideViewController.view.tag = RIGHT_PANEL_TAG;
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

-(void)removeSideView {
    if (_sideViewController != nil) {
        [_sideViewController.view removeFromSuperview];
        _sideViewController = nil;
        _showingSideView = NO;
    }
}

#pragma mark -
#pragma mark Swipe Gesture Setup/Actions

#pragma mark - setup

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

#pragma mark: Text View

- (IBAction)changeFontSize:(UIStepper*)sender {
    
    _textView.font = [_textView.font fontWithSize:[sender value]];
}

- (IBAction)changeFontStyle:(UISegmentedControl *)sender {
    
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

- (IBAction)changeTextColor:(UIBarButtonItem *)sender {
    
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

#pragma mark Highlighter

- (IBAction)changeHighlighterColor:(UIBarButtonItem *)sender {
    
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
}

#pragma mark - Highlight Color

-(void)changeHighlightColor:(UIButton*)sender{
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end