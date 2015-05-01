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
#import "DirectoryCVC.h"
#import "Stack.h"


@interface OpenLectureController ()

@end

@implementation OpenLectureController
{
    NSArray *_navigationItems;

    FSIndex *_fsIndex;
    NSString *_currectPath;
    
    // Selected Lecture
    __strong Promise *_selectedLecture;
    
    // Dir nav stack
    Stack *_dirNavStack;
}

static NSString * const lectureCellReuseID = @"lecture";
static NSString * const directoryCellReuseID = @"directory";

- (void)viewDidLoad
{
    _currectPath = @"~/Documents";

    _dirNavStack = [Stack new];
    [_dirNavStack push:_currectPath];
    
    [super viewDidLoad];
    
    [self setUpNavigation];
    
    [self loadDocumentPreviews];
}

- (void)viewDidDisappear:(BOOL)animated
{
    _selectedLecture = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FSFileChangeNotification object:nil];
}

- (void)goToNewLecture:(AMLecture *)lecture
{
    [self performSegueWithIdentifier:@"toLecture" sender:lecture];
}

- (void)loadDocumentPreviews
{
    NSLog(@"DEBUG: Loading document previews");
    _fsIndex = [FSIndex sharedIndex];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fsChange) name:FSFileChangeNotification object:nil];
    
}

- (void)fsChange
{
    [self.collectionView reloadData];
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
        ((NewLectureController *)((UINavigationController *)segue.destinationViewController).childViewControllers.firstObject).delegate = self;
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
    __weak OpenLectureController *weakSelf = self;
    [_fsIndex addToIndex:lecture.fileURL completion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
        });
    }];
}

#pragma mark Navigation

- (void)back
{
    if (![[_dirNavStack.pop stringByAbbreviatingWithTildeInPath] isEqualToString:@"~/Documents"]) {
        NSLog(@"DEBUG: %@", _dirNavStack.print);
        _currectPath = [_dirNavStack.print stringByStandardizingPath];
        [self.collectionView reloadData];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark <UICollectionViewDataSource>
- (void)new
{
    [self performSegueWithIdentifier:@"newLecture" sender:_navigationItems[1]];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            NSString *sub = _fsIndex[[_currectPath stringByAppendingPathComponent:@"*"]][indexPath.row];
            _currectPath = [_currectPath stringByAppendingPathComponent:sub];
            [self.collectionView reloadData];
            [_dirNavStack push:sub];
        } break;
        case 1: {
            Deferred *promise = [Deferred deferred];
            _selectedLecture = [promise promise];
            NSString *name = _fsIndex[_currectPath][indexPath.row];
            NSString *fpath = [_currectPath stringByAppendingPathComponent:name];
            NSURL *path = [NSURL fileURLWithPath:[fpath stringByExpandingTildeInPath] isDirectory:NO];
            
            
            AMLecture *lecture = [[AMLecture alloc] initWithFileURL:path];
             [lecture openWithCompletionHandler:^(BOOL success) {
                 [promise resolve:lecture];
                 NSLog(@"DEBUG: Opened");
             }];
            NSLog(@"DEBUG: After");
            
            
        } break;
    }
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
    switch (section) {
        case 0:
            return _fsIndex[[_currectPath stringByAppendingPathComponent:@"*"]].count;
            break;
        case 1:
            return _fsIndex[_currectPath].count;
            break;
    }
    return nil;
}

- (UICollectionViewCell *)lectureViewCellWithCell:(LoadingLectureCVC *)cell indexPath:(NSIndexPath *)indexPath
{
    NSString *name = _fsIndex[_currectPath][indexPath.row];
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

- (UICollectionViewCell *)directoryViewCellWithCell:(DirectoryCVC *)cell indexPath:(NSIndexPath *)indexPath
{
    cell.title.text = _fsIndex[[_currectPath stringByAppendingPathComponent:@"*"]][indexPath.row];
    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:directoryCellReuseID forIndexPath:indexPath];
            return [self directoryViewCellWithCell:(DirectoryCVC *)cell indexPath:indexPath];
        } break;
            
        case 1:
        {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lectureCellReuseID forIndexPath:indexPath];
            return [self lectureViewCellWithCell:(LoadingLectureCVC *)cell indexPath:indexPath];
        } break;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return (CGSize) { .width = 180.0, .height = 60.0 };
            break;
            
        case 1:
            return (CGSize) { .width = 180.0, .height = 250.0 };
            break;
    }
    return CGSizeZero;
}

@end
