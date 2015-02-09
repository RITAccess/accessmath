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

@interface OpenLectureController ()

@end

@implementation OpenLectureController
{
    NSArray *_navigationItems;
    NSInteger _lectureCount;
    NSArray *_documentTitles;
    
    // Selected Lecture
    AMLecture *_selectedLecture;
}

static NSString * const reuseIdentifier = @"lecture";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpNavigation];
    
    [self loadDocumentPreviews];
    
}

- (void)loadDocumentPreviews
{
    _documentTitles = [FileManager listContentsOfDirectory:[FileManager localDocumentsDirectoryPath]];
    _lectureCount = _documentTitles.count;
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
    NSLog(@"DEBUG: Memory Pressure");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newLecture"]) {
        ((NewLectureController *)segue.destinationViewController).delegate = self;
    }
    if ([segue.identifier isEqualToString:@"showPreview"]) {
        NSLog(@"DEBUG: %@", sender);
    }
}

- (void)newLectureViewController:(NewLectureController *)controller didCreateNewLecture:(AMLecture *)lecture
{
    // Go straight to lecture
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

#pragma mark <UIViewControllerContextTransitioning>

// The view in which the animated transition should take place.
- (UIView *)containerView
{
    return self.view;
}

// Most of the time this is YES. For custom transitions that use the new UIModalPresentationCustom
// presentation type we will invoke the animateTransition: even though the transition should not be
// animated. This allows the custom transition to add or remove subviews to the container view.
- (BOOL)isAnimated
{
    return YES;
}

// This indicates whether the transition is currently interactive.
-(BOOL)isInteractive
{
    return NO;
}

- (BOOL)transitionWasCancelled
{
    return NO;
}

- (UIModalPresentationStyle)presentationStyle
{
    return UIModalPresentationCustom;
}

// It only makes sense to call these from an interaction controller that
// conforms to the UIViewControllerInteractiveTransitioning protocol and was
// vended to the system by a container view controller's delegate or, in the case
// of a present or dismiss, the transitioningDelegate.
- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    
}

- (void)finishInteractiveTransition
{
    
}

- (void)cancelInteractiveTransition
{
    
}

// This must be called whenever a transition completes (or is cancelled.)
// Typically this is called by the object conforming to the
// UIViewControllerAnimatedTransitioning protocol that was vended by the transitioning
// delegate.  For purely interactive transitions it should be called by the
// interaction controller. This method effectively updates internal view
// controller state at the end of the transition.
- (void)completeTransition:(BOOL)didComplete
{
    
}


// Currently only two keys are defined by the
// system - UITransitionContextToViewControllerKey, and
// UITransitionContextFromViewControllerKey.
// Animators should not directly manipulate a view controller's views and should
// use viewForKey: to get views instead.
- (UIViewController *)viewControllerForKey:(NSString *)key;
{
    return self;
}

// Currently only two keys are defined by the system -
// UITransitionContextFromViewKey, and UITransitionContextToViewKey
// viewForKey: may return nil which would indicate that the animator should not
// manipulate the associated view controller's view.
- (UIView *)viewForKey:(NSString *)key
{
    return self.view;
}

- (CGAffineTransform)targetTransform
{
    return CGAffineTransformIdentity;
}

// The frame's are set to CGRectZero when they are not known or
// otherwise undefined.  For example the finalFrame of the
// fromViewController will be CGRectZero if and only if the fromView will be
// removed from the window at the end of the transition. On the other
// hand, if the finalFrame is not CGRectZero then it must be respected
// at the end of the transition.
- (CGRect)initialFrameForViewController:(UIViewController *)vc
{
    return CGRectZero;
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc
{
    return CGRectZero;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedLecture = [FileManager findDocumentWithName:_documentTitles[indexPath.row]];
}

- (void)cellDidTap:(UITapGestureRecognizer *)reg
{
    /**
     * Did select isn't garenteed to get called before cellDidTap, and even if it does
     * it's not garenteed that the lecture will have been loaded fully. Remember, the
     * root of all evil is shared mutable state. :/
     */
    #warning Potential Race condition when selecting lecture
    assert(_selectedLecture);
    NSLog(@"DEBUG: %@", _selectedLecture);
    switch (reg.numberOfTapsRequired) {
        case 1:
            NSLog(@"DEBUG: Single Tap");
            [self performSegueWithIdentifier:@"showPreview" sender:_selectedLecture];
            break;
        case 2:
            NSLog(@"DEBUG: Double Tap");
        default:
            break;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _lectureCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingLectureCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *name = _documentTitles[indexPath.row];
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
