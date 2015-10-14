//
//  SettingsViewController.h
//  LandScapeV2
//
//  Created by Student on 7/6/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *mySlider;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;

-(IBAction)resetDefault:(id)sender;

@end
