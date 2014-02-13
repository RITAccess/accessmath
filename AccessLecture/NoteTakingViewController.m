//
//  NoteTakingViewController.m
//  AccessLecture
//
//  Created by Michael Timbrook on 9/10/13.
//
//


#import "NoteTakingViewController.h"
#import "TextNoteViewController.h"
#import "FileManager.h"
#import "AddNote.h"
#import "AddImage.h"
#import "ImageNoteViewController.h"

@interface NoteTakingViewController ()

@property UILabel *addNote;
@property CGPoint menuPoint;
@property (strong) MTRadialMenu *menu;

@property (strong) AMLecture *document;
@property UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation NoteTakingViewController

+ (instancetype)loadFromStoryboard
{
    return [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"NoteTakingViewController"];
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
}

- (NSArray *)menuItemsForRadialMenu:(MTRadialMenu *)menu
{
    // Add listeners
    [menu addTarget:self action:@selector(menuSelected:) forControlEvents:UIControlEventTouchUpInside];
    [menu addTarget:self action:@selector(menuAppear:) forControlEvents:UIControlEventTouchDown];
    
    // Load Menu
    AddNote *addNote = [[AddNote alloc] init];
    addNote.identifier = @"AddNote";
    
    AddImage *addImage = [[AddImage alloc] init];
    addImage.identifier = @"AddImage";
    
    return @[addNote, addImage];
}

- (void)menuSelected:(MTRadialMenu *)sender
{
    if ([sender.selectedIdentifier isEqualToString:@"AddNote"]) {
        [self createTextNoteAndPresentAtPoint:sender.location];
    } else if([sender.selectedIdentifier isEqualToString:@"AddImage"]) {
        [self createImageNoteAndPresentAtPoint:sender.location];
    }
}

- (void)menuAppear:(MTRadialMenu *)sender
{
    [self.view bringSubviewToFront:sender];
}

- (void)lectureContainer:(LectureViewContainer *)container switchedToDocument:(AMLecture *)document
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[MTRadialMenu class]])
            continue;
        [view removeFromSuperview];
    }
    _document = document;
    for (id note in _document.lecture.notes) {
        if ([note isKindOfClass:[Note class]]) {
            [self loadNoteAndPresent:note];
        } else if ([note isKindOfClass:[ImageNoteViewController class]]) {
            ImageNoteViewController *i = (ImageNoteViewController *)note;
            [self loadImageNoteAndPresent:i];
        }
    }
}

- (void)loadNoteAndPresent:(Note *)note
{
    TextNoteViewController *tnvc = [[TextNoteViewController alloc] initWithNote:note];
    [self addChildViewController:tnvc];
    [self.view addSubview:tnvc.view];
    [_document save];
}

- (void)loadImageNoteAndPresent:(ImageNoteViewController *)invc
{
    [self addChildViewController:invc];
    [self.view addSubview:invc.view];
}

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

- (void)createImageNoteAndPresentAtPoint:(CGPoint)point
{
    ImageNoteViewController *invc = [[ImageNoteViewController alloc] initWithPoint:point];
    [_document.lecture addNotes:[NSSet setWithObject:invc]];
    [self addChildViewController:invc];
    [self.view addSubview:invc.view];
    invc.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:UIViewAnimationCurveEaseInOut animations:^{
        invc.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_document save];
    }];
}

- (void)presentOptionsAtPoint:(CGPoint)point
{
    _addNote = ({
        UILabel *label = [UILabel new];
        CGRect frame = CGRectMake(point.x - 60, point.y - 10, 120, 20);
        label.frame = frame;
        label.alpha = 0.0;
        label.text = @"Add Note";
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        label;
    });
    [UIView animateWithDuration:0.2 animations:^{
        [_addNote setFrame:({
            CGRect frame = _addNote.frame;
            frame.origin.y = frame.origin.y - 50;
            frame;
        })];
        [_addNote setAlpha:1.0];
    }];
}

- (void)dismissOptions
{
    [UIView animateWithDuration:0.2 animations:^{
        [_addNote setAlpha:0.0];
    } completion:^(BOOL finished) {
        [_addNote removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return YES;
}

#pragma mark - Keyboard Responder

- (void)keyboardDidShow:(NSNotification *)notification
{
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:_tapGestureRecognizer];
}

- (void)dismissKeyboard:(UITapGestureRecognizer *)sender
{
    for (UIView *noteTextView in self.view.subviews){
        if ([noteTextView isKindOfClass:[TextNoteView class]]){
            [noteTextView endEditing:YES];
        }
    }
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    [self.view removeGestureRecognizer:_tapGestureRecognizer];
}

#pragma mark - <LectureViewChild>

- (UIView *)contentView
{
    return self.view;
}

@end
