//
//  HighlighterViewController.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 1/28/16.
//
//

#import "HighlighterViewController.h"

@interface HighlighterViewController ()

@end

@implementation HighlighterViewController
{
    NSArray *highlighterColorChoices;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initialize highlighter choice array
    highlighterColorChoices = [[NSArray alloc] initWithObjects:[UIColor colorWithRed:127.0f/255.0f green:226.0f/255.0f blue:255.0f/255.0f alpha:1.0], [UIColor colorWithRed:245.0f/255.0f green:255.0f/255.0f blue:0.0f/255.0f alpha:1.0], [UIColor colorWithRed:208.0f/255.0f green:164.0f/255.0f blue:237.0f/255.0f alpha:1.0], [UIColor colorWithRed:108.0f/255.0f green:255.0f/255.0f blue:95.0f/255.0f alpha:1.0], [UIColor colorWithRed:253.0f/255.0f green:153.0f/255.0f blue:176.0f/255.0f alpha:1.0], [UIColor colorWithRed:233.0f/255.0f green:215.0f/255.0f blue:255.0f/255.0f alpha:1.0], [UIColor colorWithRed:154.0f/255.0f green:159.0f/255.0f blue:91.0f/255.0f alpha:1.0], [UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:226.0f/255.0f alpha:1.0], [UIColor colorWithRed:107.0f/255.0f green:191.0f/255.0f blue:211.0f/255.0f alpha:1.0], [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:236.0f/255.0f alpha:1.0], [UIColor colorWithRed:255.0f/255.0f green:62.0f/255.0f blue:62.0f/255.0f alpha:1.0], [UIColor colorWithRed:132.0f/255.0f green:100.0f/255.0f blue:174.0f/255.0f alpha:1.0], [UIColor colorWithRed:255.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1.0], [UIColor colorWithRed:212.0f/255.0f green:255.0f/255.0f blue:170.0f/255.0f alpha:1.0], [UIColor colorWithRed:101.0f/255.0f green:188.0f/255.0f blue:255.0f/255.0f alpha:1.0], nil];
    
    [self createContentView];
}

-(void)createContentView {
    CGFloat x = 5;
    CGFloat y = 15;
    
    for (UIColor *currentColor in highlighterColorChoices) {
        
        UIButton *color = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 50, 50)];
        color.backgroundColor = currentColor;
        color.layer.borderColor = [UIColor blackColor].CGColor;
        color.layer.borderWidth = 1.0f;
        color.layer.cornerRadius = 10.0f;
        [self.view addSubview:color];
        
        if (x < 225) {
            x += 55;
        } else {
            x = 5;
            y += 55;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
