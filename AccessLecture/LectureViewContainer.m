//
//  LectureViewContainer.m
//  AccessLecture
//
//  Created by Michael Timbrook on 6/26/13.
//
//

#import "LectureViewContainer.h"

@interface LectureViewContainer ()

@end

@implementation LectureViewContainer {
    BOOL menuOpen;
    NSArray *menuItems;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    menuOpen = NO;
    [self setUpMenuItems];
}

- (void)setUpMenuItems
{
    UIImageView *save = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Save.png"]];
    [save setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(savePressed:)];
    [save addGestureRecognizer:tap];
    
    menuItems = @[save];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_sideMenu setHidden:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_sideMenu setHidden:NO];
    [self setMenuOpen:NO];
    [self setExpandOpen:NO];
}

- (void)savePressed:(UITapGestureRecognizer *)reg
{
    NSLog(@"Save requested");
}

- (IBAction)menuButtonTapped:(id)sender
{
    if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        [self setMenuOpen:!menuOpen];
    } else {
        [self setExpandOpen:!menuOpen];
    }
}

- (IBAction)back:(id)sender
{
    if (menuOpen) {
        if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            [self setMenuOpen:NO];
        } else {
            [self setExpandOpen:NO];
        }
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)setMenuOpen:(BOOL)open
{
    [UIView animateWithDuration: 0.2 animations:^{
        CGRect frame = _sideMenu.frame;
        if (open) {
            frame.origin.x = self.view.frame.size.height - _sideMenu.frame.size.width;
        } else {
            frame.origin.x = self.view.frame.size.height;
        }
        [_sideMenu setFrame:frame];
    }];
    if (!menuItems){
        [self removeMenuItems];
    }
    menuOpen = open;
}

- (void)setExpandOpen:(BOOL)open
{
    [self loadNavMenuItems];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _navBar.frame;
        frame.size.height = open ? 160 : 80;
        [_navBar setFrame:frame];
    }];
    if (!menuItems){
        [self removeMenuItems];
    }
    [_navBar setNeedsDisplay];
    menuOpen = open;
}

- (void)loadNavMenuItems
{
    for (UIView *item in menuItems) {
        [item setFrame:CGRectMake(25, 80, 70, 70)];
        [_navBar addSubview:item];
    }
}

- (void)removeMenuItems
{
    for (UIView *item in menuItems) {
        [item removeFromSuperview];
    }
}

- (void)viewDidUnload {
    [self setSideMenu:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
}
@end
