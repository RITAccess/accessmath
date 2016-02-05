//
//  SettingsTableViewController.m
//  AccessLecture
//
//  Created by Piper on 2/3/16.
//
//

#import "SettingsTableViewController.h"
#import "ALView+PureLayout.h"
#import "NSArray+PureLayout.h"
#import "NavBackButton.h"

@interface SettingsTableViewController ()
{
    @private
    NSArray *_navigationItems;
    NSUserDefaults *_userDefaults;
    IBOutlet UISlider *_textSizeSlider;
}

@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // preserves selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    [_textSizeSlider setValue:[_userDefaults floatForKey:@"AMTextSize"]];
  
    [self setUpNavigation];
}

#pragma mark - Navbar Setup

- (void)setUpNavigation
{
    UIButton *back = ({
        UIButton *b = [NavBackButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(returnToHome) forControlEvents:UIControlEventTouchUpInside];
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

- (void)returnToHome
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


#pragma mark - Changing Defaults

- (IBAction)setTextSize:(UISlider*)sender
{
    [_userDefaults setFloat:sender.value forKey:@"AMTextSize"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end















