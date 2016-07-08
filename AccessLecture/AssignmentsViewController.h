//
//  AssignmentsViewController.h
//  LandScapeV2
//
//  Created by Kimberly Sookoo on 6/24/15.
//  Copyright (c) 2015 Kimberly Sookoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssignmentsViewController : UITableViewController

@property NSMutableArray *toDoItems;

- (IBAction)editButton:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;


- (IBAction)sortingChoice:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentChoice;



@end
