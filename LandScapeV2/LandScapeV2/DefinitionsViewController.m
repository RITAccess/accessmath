//
//  DefinitionsViewController.m
//  LandScapeV2
//
//  Created by Student on 6/24/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "DefinitionsViewController.h"

@interface DefinitionsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *currDate;
@end

@implementation DefinitionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //date things
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [[NSDate alloc]init];
    NSString *theDate = [dateFormat stringFromDate:now];
    _currDate.text = theDate;
    _currDate.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
