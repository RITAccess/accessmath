//
//  FullScreenNoteViewController.m
//  AccessLecture
//
//  Created by Michael on 1/8/14.
//
//

#import "FullScreenNoteViewController.h"

@interface FullScreenNoteViewController ()

@end

@implementation FullScreenNoteViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnToLecture:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
