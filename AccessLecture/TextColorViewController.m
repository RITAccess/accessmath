//
//  TextColorViewController.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 4/21/16.
//
//

#import "TextColorViewController.h"

@interface TextColorViewController ()

@end

@implementation TextColorViewController
{
    NSArray *textColorChoices;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initialize the array
    textColorChoices = [[NSArray alloc] initWithObjects:[UIColor blackColor], [UIColor blueColor], nil];
    
    [self createContentView];
}

-(void)createContentView {
    CGFloat x = 5;
    CGFloat y = 15;
    
    for (UIColor *currentColor in textColorChoices) {
        
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
    // Dispose of any resources that can be recreated.
}


@end
