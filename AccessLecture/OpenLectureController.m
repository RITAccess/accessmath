//
//  OpenLectureController.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/23/15.
//
//

#import "OpenLectureController.h"
#import "ALView+PureLayout.h"
#import "NSArray+PureLayout.h"
#import "NavBackButton.h"
#import "NewLectureButton.h"
#import "SearchButton.h"
#import "BrushButton.h"
#import "SaveButton.h"
#import "NewLectureController.h"
#import "FileManager.h"
#import "LoadingLectureCVC.h"
#import "PreviewViewController.h"
#import "AMLecture.h"
#import "Promise.h"
#import "Deferred.h"

#import "LectureViewContainer.h"
#import "FSIndex.h"


@interface OpenLectureController ()

@end

@implementation OpenLectureController
{
    NSArray *_navigationItems;
    FSIndex *_fsIndex;
    
    // Selected Lecture
    __strong Promise *_selectedLecture;
}

static NSString * const reuseIdentifier = @"lecture";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpNavigation];
    
    [self loadDocumentPreviews];
}

- (void)viewDidDisappear:(BOOL)animated
{
    _selectedLecture = nil;
}

- (void)goToNewLecture:(AMLecture *)lecture
{
    [self performSegueWithIdentifier:@"toLecture" sender:lecture];
}

- (void)loadDocumentPreviews
{
    NSLog(@"DEBUG: Loading document previews");
    _fsIndex = [FSIndex sharedIndex];
}

- (void)setUpNavigation
{
    // Navigation
    UIButton *back = ({
        UIButton *b = [NavBackButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        b.accessibilityValue = @"back";
        b;
    });
    
    UIButton *new = ({
        UIButton *b = [NewLectureButton buttonWithType:UIButtonTypeRoundedRect];
        [b addTarget:self action:@selector(new) forControlEvents:UIControlEventTouchUpInside];
        b.accessibilityValue = @"new lecture";
        b;
    });
    
    UIButton *search = ({
        UIButton *b = [SearchButton buttonWithType:UIButtonTypeRoundedRect];
        b.accessibilityValue = @"search";
        b;
    });
    
    _navigationItems = @[back, new, search];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newLecture"]) {
        ((NewLectureController *)segue.destinationViewController).delegate = self;
    }
    if ([segue.identifier isEqualToString:@"toLecture"]) {
        UINavigationController *nav = [segue destinationViewController];
        LectureViewContainer *lvc = (LectureViewContainer *)nav.topViewController;
        lvc.selectedLecture = sender;
    }
    if ([segue.identifier isEqualToString:@"showPreview"]) {
        PreviewViewController *pvc = ((PreviewViewController *)((UINavigationController *)segue.destinationViewController).childViewControllers.firstObject);
        pvc.selectedLecture = (AMLecture *)sender;
        pvc.delegate = self;
    }
}

- (void)newLectureViewController:(NewLectureController *)controller didCreateNewLecture:(AMLecture *)lecture
{
    // Go straight to lecture
    // Not called bug...
    NSLog(@"DEBUG: created %@", lecture);
}

#pragma mark Navigation

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>
- (void)new
{
    [self performSegueWithIdentifier:@"newLecture" sender:_navigationItems[1]];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Deferred *promise = [Deferred deferred];
    [FileManager findDocumentWithName:_fsIndex[indexPath.row] completion:^(AMLecture *lecture) {
        [promise resolve:lecture];
    }];
    _selectedLecture = [promise promise];
}

- (void)cellDidTap:(UITapGestureRecognizer *)reg
{
    assert(_selectedLecture);
    [_selectedLecture when:^(AMLecture *lecture) {
        switch (reg.numberOfTapsRequired) {
            default:
            case 1:
                [self performSegueWithIdentifier:@"showPreview" sender:lecture];
                break;
            case 2:
                [self performSegueWithIdentifier:@"toLecture" sender:lecture];
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _fsIndex.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingLectureCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *name = _fsIndex[indexPath.row];
    cell.title.text = name;
    [cell loadLecturePreview:name];
    
    UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellDidTap:)];
    [singletap setNumberOfTapsRequired:1];
    UITapGestureRecognizer *doubletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellDidTap:)];
    [doubletap setNumberOfTapsRequired:2];
    [singletap requireGestureRecognizerToFail:doubletap];
    
    [cell addGestureRecognizer:singletap];
    [cell addGestureRecognizer:doubletap];
    
    return cell;
}

@end
