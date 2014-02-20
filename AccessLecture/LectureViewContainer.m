//
//  LectureViewContainer.m
//  AccessLecture
//
//  Created by Michael Timbrook on 6/26/13.
//
//

#import "ACEViewController.h"
#import "LectureViewContainer.h"
#import "StreamViewController.h"
#import "NoteTakingViewController.h"
#import "ZoomBounds.h"
#import "LectureNavbar.h"
#import "FileManager.h"
#import "DrawMode.h"

#import "Promise.h"

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

#pragma mark Lecture Container Class

@interface LectureViewContainer ()

@property (weak) AMLecture *document;

@property (weak, nonatomic) IBOutlet LectureNavbar *navigationbar;
@property (strong, nonatomic) MTRadialMenu *actionMenu;

@property (strong) ACEViewController *dvc;
@property (strong) StreamViewController *svc;
@property (strong) NoteTakingViewController *ntvc;

@property (weak) UIViewController<LectureViewChild> *active;

@end

@implementation LectureViewContainer

#pragma mark Load and Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Add button outlets
    [_navigationbar.openButton addTarget:self action:@selector(openLectureAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationbar.drawingToggle addTarget:self action:@selector(toggledDrawMode:) forControlEvents:UIControlEventValueChanged];
    
    // Add Controllers
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dvc = [[ACEViewController alloc] initWithNibName:@"ACEViewController" bundle:nil];
        _ntvc = [NoteTakingViewController loadFromStoryboard];
    });
    
    [self addChildViewController:_dvc];
    [self addChildViewController:_ntvc];
    
    _ntvc.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_ntvc.view];
    [self.view bringSubviewToFront:_navigationbar];
    
    _actionMenu = [MTRadialMenu new];
    _actionMenu.startingAngle = DEGREES_TO_RADIANS(-100);
    
    [_actionMenu addTarget:self action:@selector(actionFromMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_ntvc respondsToSelector:@selector(menuItemsForRadialMenu:)]) {
        NSArray *items = [_ntvc menuItemsForRadialMenu:_actionMenu];
        for (MTMenuItem *leaf in items) {
            [_actionMenu addMenuItem:leaf];
        }
    }
    
//    // Add mode switching
//    DrawMode *switchMode = [[DrawMode alloc] init];
//    switchMode.identifier = @"switch";
//    [_actionMenu addMenuItem:switchMode];
    
    [self.view addSubview:_actionMenu];
}

- (void)moveControlTo:(UIViewController<LectureViewChild> *)vc
{
    [self.view addSubview:[vc contentView]];
    _active = vc;
    [self.view bringSubviewToFront:_navigationbar];
}


#pragma mark Actions

// TODO - Switch to stack based with a push and pop controller type maybe?
// TODO - disable if off
- (void)toggledDrawMode:(UISwitch *)sender
{
    if (sender.on) {
        [self moveControlTo:_dvc];
    } else {
        [self moveControlTo:_ntvc];
    }
}

- (void)openLectureAction:(id)sender
{
    [_ntvc lectureContainer:self switchedToDocument:nil];
    [FileManager.defaultManager forceSave];
    Promise *closed = [FileManager.defaultManager finishedWithDocument];
    [closed wait:10]; // Should block till closed doc
    Promise *lecture = [FileManager.defaultManager currentDocumentPromise];
    [lecture when:^(AMLecture *lecture) {
        [_ntvc lectureContainer:self switchedToDocument:lecture];
    }];
}

- (void)actionFromMenu:(MTRadialMenu *)menu
{
    if ([menu.selectedIdentifier isEqualToString:@"switch"]) {
        if (_active == _dvc) {
            [self moveControlTo:_ntvc];
        } else {
            [self moveControlTo:_dvc];
        }
    }
}

@end
