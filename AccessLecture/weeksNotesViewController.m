//
//  weeksNotesViewController.m
//  LandScapeV2
//
//  Created by Student on 6/24/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "weeksNotesViewController.h"
#import "AssignmentsViewController.h"

@interface weeksNotesViewController ()


@end

@implementation weeksNotesViewController{
    UITextField *currDate;
}

@synthesize upcomingDD;
@synthesize textZoom;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currDate = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, 166, 21)];
    
    //date things
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [[NSDate alloc]init];
    NSString *theDate = [dateFormat stringFromDate:now];
    currDate.text = theDate;
    currDate.userInteractionEnabled = NO;
    [self.view addSubview:currDate];
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleZoom:)];
    recognizer.delegate = self;
    recognizer.numberOfTapsRequired = 2;
    recognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:recognizer];

}

-(IBAction)upcomingAssignments{
    AssignmentsViewController *aViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UpcomingDueDates"];
    [self.navigationController pushViewController:aViewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)unwindToList:(UIStoryboardSegue *)segue
{
}

-(void) handleZoom:(UITapGestureRecognizer *)recognizer{
    //[self.textZoom zoomToRect:rectToZoomInTo animated:NO];
    //[self.textZoom ]
    
}

@end
