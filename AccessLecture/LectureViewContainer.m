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
#import "MTFlowerMenu.h"
#import "LectureNavbar.h"
#import "FileManager.h"

#pragma mark Lecture Container Class

@interface LectureViewContainer ()

@property (weak, nonatomic) IBOutlet LectureNavbar *navigationbar;

@property(strong) ACEViewController *dvc;
@property(strong) StreamViewController *svc;
@property(strong) NoteTakingViewController *ntvc;

@end

@implementation LectureViewContainer

#pragma mark Load and Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Add button outlets
    [_navigationbar.openButton addTarget:self action:@selector(openLectureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
}

#pragma mark Actions

- (void)openLectureAction:(id)sender
{
    [_ntvc lectureContainer:self switchedToDocument:nil];
    [FileManager.defaultManager forceSave];
    [FileManager.defaultManager finishedWithDocument];
    [FileManager.defaultManager currentDocumentWithCompletion:^(AMLecture *lecture) {
        [_ntvc lectureContainer:self switchedToDocument:lecture];
    }];
}

@end
