//
//  StreamViewController.m
//  AccessLecture
//
//  Created by Michael Timbrook on 6/27/13.
//
//

#import "StreamViewController.h"

@interface StreamViewController ()

@end

@implementation StreamViewController {
    UIView *test;
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
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        [self.view setFrame:CGRectMake(0, 0, 768, 1024)];
    } else {
        [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    }
    // Do any additional setup after loading the view from its nib.
    test = [[UIView alloc] initWithFrame:CGRectMake(300, 400, 200, 200)];
    [test setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:test];
}

#pragma mark Child View Controller Calls

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"will have new parent %@", parent);
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"new parent %@", parent);
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
        test.transform = transform;
    } completion:nil];
}

- (void)willSaveState
{
    [self.view setBackgroundColor:[UIColor grayColor]];
}

#pragma mark Orientation

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [UIView animateWithDuration:0.1 animations:^{
        if (UIInterfaceOrientationIsPortrait(fromInterfaceOrientation)) {
            [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
        } else {
            [self.view setFrame:CGRectMake(0, 0, 768, 1024)];
        }
    }];
}

@end
