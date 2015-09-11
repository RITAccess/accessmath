//
//  RootMenuController.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/23/15.
//
//

#import "RootMenuController.h"
#import "MenuIconCell.h"
#import "MenuData.h"

@interface RootMenuController ()

@end

@implementation RootMenuController
{
    NSArray *_menuIcons;
}

static NSString * const reuseIdentifier = @"menu";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menuIcons = @[
    ({
        MenuData *m = [MenuData new];
        m.title = @"Open";
        m.imageName = @"NotesButton";
        m.target = self;
        m.action = @selector(openLecture:);
        m;
    }),
    ({
        MenuData *m = [MenuData new];
        m.title = @"Connect";
        m.imageName = @"StreamButton";
        m.target = self;
        m.action = @selector(openConnect:);
        m;
    }),
    ({
        MenuData *m = [MenuData new];
        m.title = @"About";
        m.imageName = @"About";
        m.target = self;
        m.action = @selector(openAbout:);
        m;
    }),
    ({
        MenuData *m = [MenuData new];
        m.title = @"Settings";
        m.imageName = @"Settings";
        m.target = self;
        m;
    })];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _menuIcons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MenuIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    MenuData *data = _menuIcons[indexPath.row];
    
    cell.iconImage.image = [UIImage imageNamed:data.imageName];
    cell.title.text = data.title;
    
    [cell setUserInteractionEnabled:YES];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    MenuData *data = _menuIcons[indexPath.row];
    if (data.target && data.action) {
        [data.target performSelector:data.action withObject:self];
    }
    #pragma clang diagnostic pop
}

#pragma mark - Buttons

- (void)openAbout:(id)sender
{
    [self performSegueWithIdentifier:@"toAbout" sender:self];
}

- (void)openLecture:(id)sender
{
    [self performSegueWithIdentifier:@"open" sender:self];
}

- (void)openSearch:(id)sender
{
    
}

- (void)openConnect:(id)sender
{
    
}

@end
