//
//  NewNotesViewController.m
//  LandScapeV2
//
//  A few updates have been made; camera roll to be fixed as it only works with portrait view
//  Created by Student on 7/31/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "NewNotesViewController.h"
#import "HighlighterViewController.h"
#import "saveColor.h"

#import "ALView+PureLayout.h"
#import "NSArray+PureLayout.h"
#import "NavBackButton.h"

@interface NewNotesViewController ()

@property IBOutlet UITextField *currentDate;

@end

@implementation NewNotesViewController
{
    //open side view
    UISwipeGestureRecognizer *leftSwipe;
    
    //close side view
    UISwipeGestureRecognizer *rightSwipe;
    
    //portrait and landscape views of side view
    UIView *portraitView;
    UIView *landscapeView;
    
    //determines if device is in portrait or landscape orientation
    BOOL portrait;
    BOOL landscape;
    
    //user options to add image, text, or video
    UIButton *addImage;
    UIButton *addText;
    UIButton *addVideo;
    
    //PopOverViewController for highlighter color
    UIPopoverController *popover;
    
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
    
    [_textView sizeThatFits:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
    //leftSwipe
    leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action: @selector(orientationChanged:)];
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [leftSwipe setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:leftSwipe];
    
    //rightSwipe
    rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sideViewRemoved:)];
    [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [rightSwipe setNumberOfTouchesRequired:2];
    
    addImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addImage.backgroundColor = [UIColor grayColor];
    [addImage setTitle:@"Add Image" forState:UIControlStateNormal];
    [addImage addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    
    addText = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addText.backgroundColor = [UIColor grayColor];
    [addText setTitle:@"Add Text" forState:UIControlStateNormal];
    
    addVideo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addVideo.backgroundColor = [UIColor grayColor];
    [addVideo setTitle:@"Add Video" forState:UIControlStateNormal];
    
    //creates the additional option to highlight the selected text
    UIMenuItem *highlightText = [[UIMenuItem alloc] initWithTitle:@"Highlight" action:@selector(highlightText)];
    
    [[UIMenuController sharedMenuController] setMenuItems:@[highlightText]];
    
    
    [self setUpNavigation];
}

//sends out notification that orientation has been changed
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(sideViewRemoved:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    //[self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[self.navigationController setToolbarHidden:YES animated:YES];
}

//removes notification
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
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

//updates view based on changes
- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

//removes side view
- (void)sideViewRemoved:(NSNotification *)notification{
    [self removeSideView:[[UIApplication sharedApplication] statusBarOrientation]];
}

//actual code for updating in this method
- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    [self.view addGestureRecognizer:rightSwipe];
    [self.view removeGestureRecognizer:leftSwipe];
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            if (landscape == YES) {
                [landscapeView removeFromSuperview];
                landscape = NO;
            }
            
            portraitView = [[UIView alloc] initWithFrame:CGRectMake(600, 0, 200, self.view.frame.size.height)];
            portraitView.backgroundColor = [UIColor lightGrayColor];
            
            addImage.frame = CGRectMake(20, 300, 120, 30);
            addText.frame = CGRectMake(20, 350, 120, 30);
            addVideo.frame = CGRectMake(20, 400, 120, 30);
            
            [self.view addSubview:portraitView];
            [portraitView addSubview:addImage];
            [portraitView addSubview:addText];
            [portraitView addSubview:addVideo];
            portrait = YES;

        }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            if (portrait == YES) {
                [portraitView removeFromSuperview];
                portrait = NO;
            }
            
            landscapeView = [[UIView alloc] initWithFrame:CGRectMake(725, 0, 300, self.view.frame.size.height)];
            landscapeView.backgroundColor = [UIColor lightGrayColor];
            
            addImage.frame = CGRectMake(100, 300, 120, 30);
            addText.frame = CGRectMake(100, 350, 120, 30);
            addVideo.frame = CGRectMake(100, 400, 120, 30);
            
            [self.view addSubview:landscapeView];
            [landscapeView addSubview:addImage];
            [landscapeView addSubview:addText];
            [landscapeView addSubview:addVideo];
            landscape = YES;
            
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}

- (void) removeSideView:(UIInterfaceOrientation) orientation {
    
    [self.view removeGestureRecognizer:rightSwipe];
    [self.view addGestureRecognizer:leftSwipe];
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            [portraitView removeFromSuperview];
            [addImage removeFromSuperview];
            [addText removeFromSuperview];
            [addVideo removeFromSuperview];
            
        }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            
            [landscapeView removeFromSuperview];
            [addImage removeFromSuperview];
            [addText removeFromSuperview];
            [addVideo removeFromSuperview];
            
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }

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

- (IBAction)changeHighlighterColor:(UIBarButtonItem *)sender {
    
    HighlighterViewController *newNote = [[HighlighterViewController alloc] init];
    popover = [[UIPopoverController alloc] initWithContentViewController:newNote];
    popover.delegate = self;
    
    popover.popoverContentSize = CGSizeMake(285, 200);
    
    NSMutableArray *highlighterColorChoices = [[NSMutableArray alloc] initWithObjects:[UIColor colorWithRed:127.0f/255.0f green:226.0f/255.0f blue:255.0f/255.0f alpha:1.0], [UIColor colorWithRed:245.0f/255.0f green:255.0f/255.0f blue:0.0f/255.0f alpha:1.0], [UIColor colorWithRed:208.0f/255.0f green:164.0f/255.0f blue:237.0f/255.0f alpha:1.0], [UIColor colorWithRed:108.0f/255.0f green:255.0f/255.0f blue:95.0f/255.0f alpha:1.0], [UIColor colorWithRed:253.0f/255.0f green:153.0f/255.0f blue:176.0f/255.0f alpha:1.0], [UIColor colorWithRed:233.0f/255.0f green:215.0f/255.0f blue:255.0f/255.0f alpha:1.0], [UIColor colorWithRed:154.0f/255.0f green:159.0f/255.0f blue:91.0f/255.0f alpha:1.0], [UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:226.0f/255.0f alpha:1.0], [UIColor colorWithRed:107.0f/255.0f green:191.0f/255.0f blue:211.0f/255.0f alpha:1.0], [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:236.0f/255.0f alpha:1.0], [UIColor colorWithRed:255.0f/255.0f green:62.0f/255.0f blue:62.0f/255.0f alpha:1.0], [UIColor colorWithRed:132.0f/255.0f green:100.0f/255.0f blue:174.0f/255.0f alpha:1.0], [UIColor colorWithRed:255.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1.0], [UIColor colorWithRed:212.0f/255.0f green:255.0f/255.0f blue:170.0f/255.0f alpha:1.0], [UIColor colorWithRed:101.0f/255.0f green:188.0f/255.0f blue:255.0f/255.0f alpha:1.0], nil];
    
    //color choices
    
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

//allows the user to add images to their notes
- (IBAction)addImage:(UIButton *)sender
{
    if ([[UIApplication sharedApplication] statusBarOrientation] != UIInterfaceOrientationPortrait) {
        // TODO: implement or remove
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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
