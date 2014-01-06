//
//  TextNoteViewController.m
//  AccessLecture
//
//  Created by Michael on 1/6/14.
//
//

#import "TextNoteViewController.h"

@interface TextNoteViewController ()

@end

@implementation TextNoteViewController

- (instancetype)initWithPoint:(CGPoint)point
{
    self = [super initWithNibName:@"TextNoteView" bundle:nil];
    if (self) {
        self.view.frame = CGRectMake(point.x - 200, point.y - 100, 400, 200);
        self.view.backgroundColor = [UIColor grayColor];
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

@end
