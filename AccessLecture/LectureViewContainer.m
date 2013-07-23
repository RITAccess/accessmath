//
//  LectureViewContainer.m
//  AccessLecture
//
//  Created by Michael Timbrook on 6/26/13.
//
//

#import "LectureViewContainer.h"
#import "StreamViewController.h"
#import "DrawViewController.h"
#import "NotesViewController.h"

// Default content size
#define LC_WIDTH 1920
#define LC_HEIGHT 1080
#define SHOWLAYERS 0

#pragma mark Vectors

Vector VectorMake(CGPoint root, CGPoint end) {
    Vector *v = malloc(sizeof(Vector));
    v->root = root;
    v->end = end;
    return *v;
}

void VectorApplyScale(CGFloat scale, Vector *vector) {
    CGPoint *root = &vector->root;
    CGPoint *end = &vector->end;
    float nxd = (end->x - root->x) * scale;
    float nyd = (end->y - root->y) * scale;
    end->x = root->x + nxd;
    end->y = root->y + nyd;
}

#pragma mark Blank Canvas Class

@interface VCBlank : UIViewController <LectureViewChild>
@end

@implementation VCBlank

+ (instancetype)new
{
    VCBlank *new = [[VCBlank alloc] init];
    [new.view setBackgroundColor:[UIColor whiteColor]];
    return new;
}
- (UIView *)contentView { return self.view; }
- (void)contentSizeChanging:(CGSize)size { }

@end

#pragma mark Lecture Container Class

@interface LectureViewContainer ()

@property CGPoint center;
@property CGSize space;

@end

@implementation LectureViewContainer {
    // Controllers
    NotesViewController *nvc;
    DrawViewController *dcv;
    StreamViewController *svc;
    
    // Menu
    NSArray *menuItems;
    BOOL menuOpen;

    // Zoom
    CGAffineTransform _zoomLevel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark Load and Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpGestures];
    
    [_sideMenu setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:0.8]];
    [_navBar setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:0.5]];
    [self.view setBackgroundColor:[UIColor grayColor]];
    [self.view setClipsToBounds:YES];
    
    // Set up viewControllers
    nvc = [[NotesViewController alloc] initWithNibName:NotesViewControllerXIB bundle:nil];
    dcv = [[DrawViewController alloc] initWithNibName:DrawViewControllerXIB bundle:nil];
    svc = (StreamViewController *)[[UIStoryboard storyboardWithName:StreamViewControllerStoryboard bundle:nil] instantiateViewControllerWithIdentifier:StreamViewControllerID];
    
    _space = CGSizeMake(LC_WIDTH, LC_HEIGHT);
    
    [self addController:nvc];
    [self addController:dcv];
    [self addController:svc];
    [self addController:[VCBlank new]];
    
    _center = CGPointMake(CGRectGetMidY(self.view.frame), CGRectGetMidX(self.view.frame));
    
    // Close menus
    menuOpen = NO;
    [self setUpMenuItems];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setContentSize:_space];
}

- (void)setUpGestures
{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchZoom:)];
    [self.view addGestureRecognizer:pinch];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandle:)];
    pan.minimumNumberOfTouches = 2;
    [self.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapZoom:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
}

- (void)setUpMenuItems
{
    // Save
    UIImageView *save = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Save.png"]];
    [save setTag:0];
    [save setUserInteractionEnabled:YES];
    [save addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)]];
    
    // Notes
    UIImageView *notes = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
    [notes setTag:1];
    [notes setUserInteractionEnabled:YES];
    [notes addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)]];
    
    // Draw
    UIImageView *draw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Notes.png"]];
    [draw setTag:2];
    [draw setUserInteractionEnabled:YES];
    [draw addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)]];
    
    // Stream
    UIImageView *stream = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Invert.png"]];
    [stream setTag:3];
    [stream setUserInteractionEnabled:YES];
    [stream addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)]];
    
    menuItems = @[save, notes, draw, stream];
}

#pragma mark Actions

- (void)setContentSize:(CGSize)size
{
    [self.childViewControllers enumerateObjectsUsingBlock:^(id<LectureViewChild> obj, NSUInteger idx, BOOL *stop) {
        UIView *content = [obj contentView];
        [content setBounds:CGRectMake(0, 0, size.width, size.height)];
        [content setCenter:_center];
        if ([obj respondsToSelector:@selector(contentSizeChanging:)]) {
            [obj contentSizeChanging:size];
        }
    }];
}

- (void)tapZoom:(UITapGestureRecognizer *)gesture
{
    
}

/**
 * Pinch to zoom handle
 */
- (void)pinchZoom:(UIPinchGestureRecognizer *)gesture
{
    float scale = [gesture scale];
    [gesture setScale:1.0];
    
    CGPoint touch = [gesture locationInView:self.view];
    Vector relation = VectorMake(touch, self.center);
    VectorApplyScale(scale, &relation);
    self.center = relation.end;
    free(&relation);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _zoomLevel = CGAffineTransformIdentity;
    });
    _zoomLevel = CGAffineTransformScale(_zoomLevel, scale, scale);
    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController<LectureViewChild> *child, NSUInteger idx, BOOL *stop) {
        UIView *content = [child contentView];
        content.transform = _zoomLevel;
        [content setCenter:self.center];
    }];
}

/**
 * Manages the pan gesture.
 */
- (void)panHandle:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:self.view];
    [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
    for (id<LectureViewChild> obj in self.childViewControllers) {
        if ([obj respondsToSelector:@selector(contentView)]) {
            UIView *view = [obj contentView];
            [view setCenter:CGPointMake(view.center.x + translation.x, view.center.y + translation.y)];
        }
    }
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
}

- (void)action:(UITapGestureRecognizer *)reg
{    
    switch (reg.view.tag) {
        case 0:
            // Save
            [self startSave];
            break;
        case 1:
        {
            [self addController:nvc];
            break;
        }
        case 2:
        {
            // Draw
            [self addController:dcv];
            break;
        }
        case 3:
        {
            // Stream
            [self addController:svc];
            break;
        }
            
        default:
            NSLog(@"∆");
            break;
    }
    if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        [self setMenuOpen:NO];
    } else {
        [self setExpandOpen:NO];
    }
}

- (void)addController:(UIViewController<LectureViewChild> *)vc
{
    // Leave parent
    NSMutableArray *children = [[NSMutableArray alloc] initWithArray:self.childViewControllers];
    for (UIViewController<LectureViewChild> *child in self.childViewControllers) {
        if ([child respondsToSelector:@selector(willLeaveActiveState)]) {
            [child willLeaveActiveState];
        }
    }
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [self.view bringSubviewToFront:_navBar];
    [self.view bringSubviewToFront:_sideMenu];
    for (UIViewController<LectureViewChild> *child in children) {
        if ([child isEqual:vc]) continue;
        if ([child respondsToSelector:@selector(willLeaveActiveState)]) {
            [child didLeaveActiveState];
        }
    }
    
    if ([vc isKindOfClass:[VCBlank class]]) {
        [self.view sendSubviewToBack:vc.contentView];
        [vc.view removeConstraints:vc.view.constraints];
    }
    
#if SHOWLAYERS
    // Testing code
    if ([vc isKindOfClass:[DrawViewController class]]) {
        [vc.contentView setBackgroundColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5]];
    }
    if ([vc isKindOfClass:[StreamViewController class]]) {
        [vc.contentView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5]];
    }
    if ([vc isKindOfClass:[NotesViewController class]]) {
        [vc.contentView setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5]];
    }
#endif
    
    children = nil;
    [vc didMoveToParentViewController:self];
}

- (IBAction)menuButtonTapped:(id)sender
{
    if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        [self setMenuOpen:!menuOpen];
    } else {
        [self setExpandOpen:!menuOpen];
    }
}

- (IBAction)backButtonTapped:(id)sender
{
    if (menuOpen) {
        if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            [self setMenuOpen:NO];
        } else {
            [self setExpandOpen:NO];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark View contoller

- (void)setMenuOpen:(BOOL)open
{
    [self loadSideMenuItems];
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

- (void)loadSideMenuItems
{
    int y = 25;
    for (UIView *item in menuItems) {
        [item setFrame:CGRectMake(25, y, 100, 100)];
        [_sideMenu addSubview:item];
        y += 125;
    }
}

- (void)loadNavMenuItems
{
    int x = 25;
    for (UIView *item in menuItems) {
        [item setFrame:CGRectMake(x, 80, 70, 70)];
        [_navBar addSubview:item];
        x += 105;
    }
}

- (void)removeMenuItems
{
    for (UIView *item in menuItems) {
        [item removeFromSuperview];
    }
}

#pragma mark Saving

- (void)startSave
{
    for (UIViewController<LectureViewChild> *children in self.childViewControllers) {
        if ([children respondsToSelector:@selector(willSaveState)]) {
            [children willSaveState];
        }
    }
    
    // Do state saving
    for (UIViewController<LectureViewChild> *children in self.childViewControllers) {
        if ([children respondsToSelector:@selector(didSaveState)]) {
            [children didSaveState];
        }
    }
}

#pragma mark System calls

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_sideMenu setHidden:NO];
    [self setMenuOpen:NO];
    [self setExpandOpen:NO];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods { return YES; }

- (BOOL)shouldAutomaticallyForwardRotationMethods { return YES; }

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    for (UIViewController *child in self.childViewControllers) {
        [UIView animateWithDuration:duration animations:^{
            child.view.frame = self.view.bounds;
        }];
    }
    [self setContentSize:_space];
}

- (void)viewDidUnload {
    [self setSideMenu:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
}
@end
