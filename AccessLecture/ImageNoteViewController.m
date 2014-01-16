//
//  ImageNoteViewController.m
//  AccessLecture
//
//  Created by Michael on 1/15/14.
//
//

#import "ImageNoteViewController.h"

@interface ImageNoteViewController ()

@end

@implementation ImageNoteViewController

- (id)initWithPoint:(CGPoint)point
{
    self = [super initWithNibName:@"ImageNoteViewController" bundle:nil];
    if (self) {
        // Custom initialization
        CGRect frame = CGRectMake(0, 0, 200, 200);
        self.view.frame = frame;
        self.view.center = point;
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    UIPanGestureRecognizer *scale = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sizeView:)];
    [scale setMinimumNumberOfTouches:@1];
    [scale setMaximumNumberOfTouches:@1];
    [scale setDelaysTouchesBegan:NO];
    [scale setDelegate:self];
    [self.view addGestureRecognizer:scale];
}

- (void)sizeView:(UIPanGestureRecognizer *)reg
{
    NSLog(@"%@", reg);
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureStuff

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
