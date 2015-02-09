//
//  PreviewViewController.m
//  AccessLecture
//
//  Created by Michael Timbrook on 2/6/15.
//
//

#import "PreviewViewController.h"
#import "AccessLectureKit.h"
#import "PureLayout.h"
#import "NavBackButton.h"
#import "ContinueButton.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController
{
    NSArray *_navigationItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [AccessLectureKit accessBlue];
    [self setUpNavigation];
}

- (void)setUpNavigation
{
    // Navigation
    UIButton *back = ({
        UIButton *b = [NavBackButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(dismissModalViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        b.accessibilityValue = @"back";
        b;
    });
    
    UILabel *title = ({
        UILabel *l = [[UILabel alloc] initForAutoLayout];
        l.textAlignment = NSTextAlignmentCenter;
        l.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        l.font = [UIFont systemFontOfSize:48];
        l.text = _selectedLecture.metadata.title ?: @"Untitled";
        l;
    });
    
    UIButton *cont = ({
        UIButton *b = [ContinueButton buttonWithType:UIButtonTypeRoundedRect];
//        [b addTarget:self action:@selector(new) forControlEvents:UIControlEventTouchUpInside];
        b.accessibilityValue = @"continue";
        b;
    });
    
    _navigationItems = @[back, title, cont];
    
    [_navigationItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.navigationController.navigationBar addSubview:obj];
    }];
    
    [self.navigationController.navigationBar setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [_navigationItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (idx != 1) {
            [view autoSetDimensionsToSize:CGSizeMake(120, 100)];
        }
        [view autoAlignAxis:ALAxisLastBaseline toSameAxisOfView:view.superview];
        [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0 relation:NSLayoutRelationEqual];
    }];
    
    [_navigationItems[0] autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_navigationItems[1] autoCenterInSuperview];
    [_navigationItems[2] autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource, UIBarPositioningDelegate>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"blankCell" forIndexPath:indexPath];

    return cell;
}


@end
