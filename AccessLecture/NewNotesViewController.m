//
//  NewNotesViewController.m
//  LandScapeV2
//
//  A few updates have been made; camera roll to be fixed as it only works with portrait view
//  Created by Student on 7/31/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "NewNotesViewController.h"
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
    
    //PopOverViewController for text color
    UIPopoverController *popoverText;
    
    NSArray *_navigationItems;
}

@synthesize textView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //date things
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [[NSDate alloc]init];
    NSString *theDate = [dateFormat stringFromDate:now];
    _currentDate.text = theDate;
    _currentDate.userInteractionEnabled = NO;
    
    [textView sizeThatFits:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
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
    
    if ([SaveColor sharedData].textColor != nil) {
        textView.textColor = [SaveColor sharedData].textColor;
    }
    
    if ([SaveColor sharedData].attributed != nil) {
        textView.attributedText = [SaveColor sharedData].attributed;
    }
    
    [self setUpNavigation];
}

//sends out notification that orientation has been changed
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(sideViewRemoved:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
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

//Uses NSMutableAttributedString to highlight the text selected by the user.
-(void)highlightText
{
    
    NSRange selectedRange = textView.selectedRange;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
    
    if ([SaveColor sharedData].hightlightColor != nil) {
        [attributedString addAttribute:NSBackgroundColorAttributeName value:[SaveColor sharedData].hightlightColor range:selectedRange];
    } else {
        [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:selectedRange];
    }
    
    textView.attributedText = attributedString;
    [SaveColor sharedData].attributed = attributedString;
    [[SaveColor sharedData] save];
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

#pragma mark - Text Size

- (IBAction)decreaseTextSize:(UIBarButtonItem*)sender {
    
    CGFloat value = textView.font.pointSize;
    
    if (sender == self.decreaseTextSize) {
        value -= 1;
        [textView setFont:[UIFont systemFontOfSize:value]];
        [textView sizeToFit];
    }
}

- (IBAction)increaseTextSize:(UIBarButtonItem*)sender {
    
    CGFloat value = textView.font.pointSize;
    
    if (sender == self.increaseTextSize) {
        value += 1;
        [textView setFont:[UIFont systemFontOfSize:value]];
        [textView sizeToFit];
    }
}

#pragma mark - Highlight Color

//Changes highlighter color to one of the choices listed below and saves the selection
- (IBAction)highlightColor:(UIBarButtonItem *)sender {
    
    NewNotesViewController *newNote = [[NewNotesViewController alloc] init];
    popover = [[UIPopoverController alloc] initWithContentViewController:newNote];
    popover.delegate = self;
    
    popover.popoverContentSize = CGSizeMake(285, 200);
    
    //color choices
    UIButton *color1 = [[UIButton alloc] initWithFrame:CGRectMake(5, 15, 50, 50)];
    color1.backgroundColor = [UIColor colorWithRed:127.0f/255.0f green:226.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    color1.layer.borderColor = [UIColor blackColor].CGColor;
    color1.layer.borderWidth = 1.0f;
    color1.layer.cornerRadius = 10.0f;
    [color1 addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color2 = [[UIButton alloc] initWithFrame:CGRectMake(60, 15, 50, 50)];
    color2.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:255.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    color2.layer.borderColor = [UIColor blackColor].CGColor;
    color2.layer.borderWidth = 1.0f;
    color2.layer.cornerRadius = 10.0f;
    [color2 addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color3 = [[UIButton alloc] initWithFrame:CGRectMake(115, 15, 50, 50)];
    color3.backgroundColor = [UIColor colorWithRed:208.0f/255.0f green:164.0f/255.0f blue:237.0f/255.0f alpha:1.0];
    color3.layer.borderColor = [UIColor blackColor].CGColor;
    color3.layer.borderWidth = 1.0f;
    color3.layer.cornerRadius = 10.0f;
    [color3 addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color4 = [[UIButton alloc] initWithFrame:CGRectMake(170, 15, 50, 50)];
    color4.backgroundColor = [UIColor colorWithRed:108.0f/255.0f green:255.0f/255.0f blue:95.0f/255.0f alpha:1.0];
    color4.layer.borderColor = [UIColor blackColor].CGColor;
    color4.layer.borderWidth = 1.0f;
    color4.layer.cornerRadius = 10.0f;
    [color4 addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color5 = [[UIButton alloc] initWithFrame:CGRectMake(225, 15, 50, 50)];
    color5.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:153.0f/255.0f blue:176.0f/255.0f alpha:1.0];
    color5.layer.borderColor = [UIColor blackColor].CGColor;
    color5.layer.borderWidth = 1.0f;
    color5.layer.cornerRadius = 10.0f;
    [color5 addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color6 = [[UIButton alloc] initWithFrame:CGRectMake(5, 70, 50, 50)];
    color6.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:215.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    color6.layer.borderColor = [UIColor blackColor].CGColor;
    color6.layer.borderWidth = 1.0f;
    color6.layer.cornerRadius = 10.0f;
    [color6 addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color7 = [[UIButton alloc] initWithFrame:CGRectMake(60, 70, 50, 50)];
    color7.backgroundColor = [UIColor colorWithRed:154.0f/255.0f green:159.0f/255.0f blue:91.0f/255.0f alpha:1.0];
    color7.layer.borderColor = [UIColor blackColor].CGColor;
    color7.layer.borderWidth = 1.0f;
    color7.layer.cornerRadius = 10.0f;
    [color7 addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color8 = [[UIButton alloc] initWithFrame:CGRectMake(115, 70, 50, 50)];
    color8.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:226.0f/255.0f alpha:1.0];
    color8.layer.borderColor = [UIColor blackColor].CGColor;
    color8.layer.borderWidth = 1.0f;
    color8.layer.cornerRadius = 10.0f;
    [color8 addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color9 = [[UIButton alloc] initWithFrame:CGRectMake(170, 70, 50, 50)];
    color9.backgroundColor = [UIColor colorWithRed:107.0f/255.0f green:191.0f/255.0f blue:211.0f/255.0f alpha:1.0];
    color9.layer.borderColor = [UIColor blackColor].CGColor;
    color9.layer.borderWidth = 1.0f;
    color9.layer.cornerRadius = 10.0f;
    [color9 addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color10 = [[UIButton alloc] initWithFrame:CGRectMake(225, 70, 50, 50)];
    color10.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:236.0f/255.0f alpha:1.0];
    color10.layer.borderColor = [UIColor blackColor].CGColor;
    color10.layer.borderWidth = 1.0f;
    color10.layer.cornerRadius = 10.0f;
    [color10 addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color11 = [[UIButton alloc] initWithFrame:CGRectMake(5, 125, 50, 50)];
    color11.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:62.0f/255.0f blue:62.0f/255.0f alpha:1.0];
    color11.layer.borderColor = [UIColor blackColor].CGColor;
    color11.layer.borderWidth = 1.0f;
    color11.layer.cornerRadius = 10.0f;
    [color11 addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color12 = [[UIButton alloc] initWithFrame:CGRectMake(60, 125, 50, 50)];
    color12.backgroundColor = [UIColor colorWithRed:132.0f/255.0f green:100.0f/255.0f blue:174.0f/255.0f alpha:1.0];
    color12.layer.borderColor = [UIColor blackColor].CGColor;
    color12.layer.borderWidth = 1.0f;
    color12.layer.cornerRadius = 10.0f;
    [color12 addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color13 = [[UIButton alloc] initWithFrame:CGRectMake(115, 125, 50, 50)];
    color13.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1.0];
    color13.layer.borderColor = [UIColor blackColor].CGColor;
    color13.layer.borderWidth = 1.0f;
    color13.layer.cornerRadius = 10.0f;
    [color13 addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color14 = [[UIButton alloc] initWithFrame:CGRectMake(170, 125, 50, 50)];
    color14.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:255.0f/255.0f blue:170.0f/255.0f alpha:1.0];
    color14.layer.borderColor = [UIColor blackColor].CGColor;
    color14.layer.borderWidth = 1.0f;
    color14.layer.cornerRadius = 10.0f;
    [color14 addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color15 = [[UIButton alloc] initWithFrame:CGRectMake(225, 125, 50, 50)];
    color15.backgroundColor = [UIColor colorWithRed:101.0f/255.0f green:188.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    color15.layer.borderColor = [UIColor blackColor].CGColor;
    color15.layer.borderWidth = 1.0f;
    color15.layer.cornerRadius = 10.0f;
    [color15 addTarget:self action:@selector(changeHighlightColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [popover.contentViewController.view addSubview:color1];
    [popover.contentViewController.view addSubview:color2];
    [popover.contentViewController.view addSubview:color3];
    [popover.contentViewController.view addSubview:color4];
    [popover.contentViewController.view addSubview:color5];
    [popover.contentViewController.view addSubview:color6];
    [popover.contentViewController.view addSubview:color7];
    [popover.contentViewController.view addSubview:color8];
    [popover.contentViewController.view addSubview:color9];
    [popover.contentViewController.view addSubview:color10];
    [popover.contentViewController.view addSubview:color11];
    [popover.contentViewController.view addSubview:color12];
    [popover.contentViewController.view addSubview:color13];
    [popover.contentViewController.view addSubview:color14];
    [popover.contentViewController.view addSubview:color15];
    
    self.popOverController = popover;
    
    
    [self.popOverController presentPopoverFromBarButtonItem:sender
                                   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

-(void)changeHighlightColor:(UIButton*)sender{
    [SaveColor sharedData].hightlightColor = sender.backgroundColor;
    [self.popOverController dismissPopoverAnimated:true];
    [[SaveColor sharedData] save];
}

- (IBAction)changeTextColor:(UIBarButtonItem *)sender {
    
    NewNotesViewController *newNote = [[NewNotesViewController alloc] init];
    popoverText = [[UIPopoverController alloc] initWithContentViewController:newNote];
    popoverText.delegate = self;
    
    popoverText.popoverContentSize = CGSizeMake(285, 200);
    
    self.popOverControllerText = popoverText;
    
    //color choices
    UIButton *color1 = [[UIButton alloc] initWithFrame:CGRectMake(5, 15, 50, 50)];
    color1.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    color1.layer.borderColor = [UIColor blackColor].CGColor;
    color1.layer.borderWidth = 1.0f;
    color1.layer.cornerRadius = 10.0f;
    [color1 addTarget:self action:@selector(textColorChanger:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color2 = [[UIButton alloc] initWithFrame:CGRectMake(60, 15, 50, 50)];
    color2.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    color2.layer.borderColor = [UIColor blackColor].CGColor;
    color2.layer.borderWidth = 1.0f;
    color2.layer.cornerRadius = 10.0f;
    [color2 addTarget:self action:@selector(textColorChanger:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *color3 = [[UIButton alloc] initWithFrame:CGRectMake(115, 15, 50, 50)];
    color3.backgroundColor = [UIColor colorWithRed:166.0f/255.0f green:28.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    color3.layer.borderColor = [UIColor blackColor].CGColor;
    color3.layer.borderWidth = 1.0f;
    color3.layer.cornerRadius = 10.0f;
    [color3 addTarget:self action:@selector(textColorChanger:) forControlEvents:UIControlEventTouchUpInside];
    
    [popoverText.contentViewController.view addSubview:color1];
    [popoverText.contentViewController.view addSubview:color2];
    [popoverText.contentViewController.view addSubview:color3];
    
    
    [self.popOverControllerText presentPopoverFromBarButtonItem:sender
                                       permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)textColorChanger:(UIButton*)sender{
    [SaveColor sharedData].textColor = sender.backgroundColor;
    [self.popOverControllerText dismissPopoverAnimated:true];
    textView.textColor = [SaveColor sharedData].textColor;
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
