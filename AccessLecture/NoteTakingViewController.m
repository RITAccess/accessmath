//
//  NoteTakingViewController.m
//  AccessLecture
//
//  Created by Michael Timbrook on 9/10/13.
//
//

#import "NoteTakingViewController.h"

@interface NoteTakingViewController ()

@property UILabel *addNote;
@property CGPoint menuPoint;

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
	// Do any additional setup after loading the view.
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self.view addGestureRecognizer:longPress];
    
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
    if (translation.y >= 45 && translation.y < 120 && translation.x < 75 && translation.x > -75) {
        NSLog(@"Add Note");
    }
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

#pragma mark <LectureViewChild>

- (UIView *)contentView
{
    return self.view;
}

@end
