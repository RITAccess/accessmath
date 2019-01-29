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
#import "SearchTextField.h"
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
#import "AMIndex.h"
#import "DirectoryCVC.h"
#import "Stack.h"


@interface OpenLectureController ()

@end

@implementation OpenLectureController
{
    NSArray *_navigationItems;

    AMIndex *_fsIndex;
    NSString *_currectPath;
    
    // Selected Lecture
    __strong Promise *_selectedLecture;
    
    // Dir nav stack
    Stack *_dirNavStack;
    
    //Search text - used while searching a lecture
    NSString *_searchText;
    NSString *_currectPathWithSearchText;
}

static NSString * const lectureCellReuseID = @"lecture";
static NSString * const directoryCellReuseID = @"directory";

- (void)viewDidLoad
{
    _currectPath = @"~/Documents";

    _dirNavStack = [Stack new];
    [_dirNavStack push:_currectPath];
    
    //setting searchText to nil
    _searchText = nil;
    [[self buttonClearSearch] setEnabled:false];
    [[self buttonClearSearch] setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _currectPathWithSearchText = nil;
    
    [super viewDidLoad];
    
    [self setUpNavigation];
    
    [self loadDocumentPreviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadDocumentPreviews];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //_searchText = nil;
    //_currectPathWithSearchText = nil;
    _currectPath = @"~/Documents";
    _selectedLecture = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FSFileChangeNotification object:nil];
}

- (void)goToNewLecture:(AMLecture *)lecture
{
    [self performSegueWithIdentifier:@"toLecture" sender:lecture];
}

- (void)loadDocumentPreviews
{
    _fsIndex = [AMIndex sharedIndex];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fsChange) name:FSFileChangeNotification object:nil];
    [self.collectionView reloadData];
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
        [b addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
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
- (void)search
{
    NSLog(@"Clicked search");
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Alert"
                                 message:@"Search Lectures"
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"Enter search criteria";
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
                                   //Handle your ok button action here
                                   _searchText = alert.textFields.firstObject.text;
                                   _currectPathWithSearchText = nil;
                                   if(_searchText != nil && (![_searchText isEqualToString:@""])) {
                                       [[self buttonClearSearch] setEnabled:true];
                                       [[self buttonClearSearch] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                       _currectPathWithSearchText = [[_currectPath stringByAppendingString:@","] stringByAppendingString:_searchText];
                                   }
                                   [self loadDocumentPreviews];
                               }];
    [alert addAction:cancelButton];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)clearSearch:(id)sender {
    _searchText = nil;
    [[self buttonClearSearch] setEnabled:false];
    [[self buttonClearSearch] setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _currectPathWithSearchText = nil;
    [self loadDocumentPreviews];
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
            NSString *name;
            if(_currectPathWithSearchText == nil) {
                name = _fsIndex[_currectPath][indexPath.row];
            }
            else {
                name = _fsIndex[_currectPathWithSearchText][indexPath.row];
            }
            NSString *fpath = [_currectPath stringByAppendingPathComponent:name];
            NSURL *path = [NSURL fileURLWithPath:[fpath stringByExpandingTildeInPath] isDirectory:NO];
            
            
            AMLecture *lecture = [[AMLecture alloc] initWithFileURL:path];
             [lecture openWithCompletionHandler:^(BOOL success) {
                 [promise resolve:lecture];
             }];
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
            if(_currectPathWithSearchText == nil) {
                return _fsIndex[_currectPath].count;
            }
            else {
                return _fsIndex[_currectPathWithSearchText].count;
            }
            break;
    }
    return nil;
}

- (UICollectionViewCell *)lectureViewCellWithCell:(LoadingLectureCVC *)cell indexPath:(NSIndexPath *)indexPath
{
    NSString *name;
    NSString *pathPlusSearchText = _currectPath;
    if(_searchText != nil && (![_searchText isEqualToString:@""]))
    {
        pathPlusSearchText = [pathPlusSearchText stringByAppendingString:@","];
        pathPlusSearchText = [pathPlusSearchText stringByAppendingString:_searchText];
    }
    name = _fsIndex[pathPlusSearchText][indexPath.row];
    
    cell.title.text = name;
        [cell loadLecturePreview:[_currectPath stringByAppendingPathComponent:name]];
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
