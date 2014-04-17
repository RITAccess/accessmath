//
//  NoteTakingViewController.m
//  AccessLecture
//
//  Created by Michael Timbrook on 9/10/13.
//
//

#import "NoteTakingViewController.h"
#import "TextNoteViewController.h"
#import "ImageNoteViewController.h"
#import "FileManager.h"
#import "MTFlowerMenu.h"
#import "AddNote.h"
#import "AddImage.h"

@interface NoteTakingViewController ()

@property UILabel *addNote;
@property CGPoint menuPoint;
@property (strong) MTFlowerMenu *menu;
@property (strong) AMLecture *document;

@end

@implementation NoteTakingViewController

#pragma mark Setup and Loading

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
    
    // Get keyboard notifictions
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    // Load Menu
    AddNote *addNote = [[AddNote alloc] init];
    addNote.identifier = @"AddNote";
    
    AddImage *addImage = [[AddImage alloc] init];
    addImage.identifier = @"AddImage";
    
    _menu = [[MTFlowerMenu alloc] initWithFrame:CGRectZero];
    [_menu addTarget:self action:@selector(menuSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_menu addTarget:self action:@selector(menuAppear:) forControlEvents:UIControlEventTouchDown];

    [_menu addMenuItem:addNote];
    [_menu addMenuItem:addImage];
    
    [self.view addSubview:_menu];

}

- (void)viewDidAppear:(BOOL)animated
{
    // Get document
    [[FileManager defaultManager] currentDocumentWithCompletion:^(AMLecture *lecture) {
        _document = lecture;
        for (Note *note in _document.lecture.notes) {
            [self loadNoteAndPresent:note];
        }
    }];
}


#pragma mark - Note Creation and Viewing

- (void)createTextNoteAndPresentAtPoint:(CGPoint)point
{
    TextNoteViewController *tnvc = [[TextNoteViewController alloc] initWithPoint:point];
    [_document.lecture addNotes:[NSSet setWithObject:[(TextNoteView *)tnvc.view data]]];
    [self addChildViewController:tnvc];
    [self.view addSubview:tnvc.view];
    tnvc.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:UIViewAnimationCurveEaseInOut animations:^{
        tnvc.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_document save];
    }];
}

- (void)loadNoteAndPresent:(Note *)note
{
    TextNoteViewController *tnvc = [[TextNoteViewController alloc] initWithNote:note];
    [self addChildViewController:tnvc];
    [self.view addSubview:tnvc.view];
    [_document save];
}

#pragma mark - Actions

- (void)menuSelected:(MTFlowerMenu *)sender
{
    if ([sender.selectedIdentifier isEqualToString:@"AddNote"]) {
        [self createTextNoteAndPresentAtPoint:sender.location];
    } else if([sender.selectedIdentifier isEqualToString:@"AddImage"]) {
        NSLog(@"Add Image");
    }
}

- (void)menuAppear:(MTFlowerMenu *)sender
{
    [self.view bringSubviewToFront:sender];
}

#pragma mark Keyboard and Resonder

- (void)keyboardDidShow:(NSNotification *)notification
{

}

- (void)keyboardDidHide:(NSNotification *)notification
{

}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return YES;
}

#pragma mark <LectureViewChild> - Deprecated?

- (UIView *)contentView
{
    return self.view;
}

@end
