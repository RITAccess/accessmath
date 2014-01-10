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

@interface NoteTakingViewController ()

@property UILabel *addNote;
@property CGPoint menuPoint;

@end

@interface NoteTakingViewController ()

@property (strong) AMLecture *document;

@end

@implementation NoteTakingViewController

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
	// Add menu activation gesture
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self.view addGestureRecognizer:longPress];
    
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

- (void)longPressGesture:(UILongPressGestureRecognizer *)reg
{
    switch (reg.state) {
        case UIGestureRecognizerStateBegan:
            _menuPoint = [reg locationInView:self.view];
            [self presentOptionsAtPoint:[reg locationInView:self.view]];
            break;

        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded: {
            CGPoint current = [reg locationInView:self.view];
            CGPoint translation = CGPointMake(_menuPoint.x - current.x, _menuPoint.y - current.y);
            [self recognizeWithTranslation:translation];
            [self dismissOptions];
        } break;
            
        default:
            break;
    }
}

- (void)recognizeWithTranslation:(CGPoint)translation
{
    // TODO add a modular system for adding menu items, look into UIDynamics for object colltion.
    if (translation.y >= 45 && translation.y < 120 && translation.x < 75 && translation.x > -75) {
        // Add note
        [self createTextNoteAndPresentAtPoint:_menuPoint];
    }
}

- (void)loadNoteAndPresent:(Note *)note
{
    TextNoteViewController *tnvc = [[TextNoteViewController alloc] initWithNote:note];
    [self addChildViewController:tnvc];
    [self.view addSubview:tnvc.view];
    [_document save];
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
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return YES;
}

#pragma mark Keyboard resonder

- (void)keyboardDidShow:(NSNotification *)notification
{

}

- (void)keyboardDidHide:(NSNotification *)notification
{

}

#pragma mark <LectureViewChild>

- (UIView *)contentView
{
    return self.view;
}

@end
