//
//  weeksNotesViewController.h
//  LandScapeV2
//
//  Created by Student on 6/24/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeeksNotesViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) IBOutlet UIButton *upcomingDD;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer * textZoom;

@end
