//
//  FavoritesViewController.m
//  AccessLecture
//
//  Created by Piper Chester on 7/23/13.
//
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissFavorites:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"Dismissed!");
    }];
}

@end
