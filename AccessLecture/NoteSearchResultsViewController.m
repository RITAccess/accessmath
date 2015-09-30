//
//  NoteSearchResultsViewController.m
//  AccessLecture
//
//  Created by Piper on 9/23/15.
//
//

#import "NoteSearchResultsViewController.h"


@implementation NoteSearchResultsViewController

-(void)viewDidLoad
{
//    [super viewDidLoad];
    
    NSLog(@"DEBUG: NoteSearchResultsViewController loaded.");
}

-(void)presentNote:(Note*)note
{
    // TODO: stubbed - going to present note in draw viewm
    NSLog(@"DEBUG: Presenting note....");
    
    UIView* noteView = [[UIView alloc] initWithFrame:CGRectMake(300, 200, 250, 125)];
    noteView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview: noteView];
}

@end
