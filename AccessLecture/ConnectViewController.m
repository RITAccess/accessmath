//
//  ConnectViewController.m
//  AccessLecture
//
//  Created by Michael Timbrook on 6/7/13.
//
//

#import "ConnectViewController.h"
#import "AccessLectureAppDelegate.h"
#import "Lecture.h"

@interface ConnectViewController ()

@end

@implementation ConnectViewController {
    AccessLectureAppDelegate *app;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    app = [[UIApplication sharedApplication] delegate];
    [app.server setConnectionURL:_serverAddress.text];
}

- (void)connectToLecture:(NSString *)lecture {
    [app.server connect];
    [app.server requestAccessToLectureSteam:lecture];
}

- (void)downloadLecture:(NSString *)lecture {
    [app.server connect];
    [app.server getFullLecture:lecture completion:^(Lecture *lecture, BOOL found) {
        if (found) {
            NSLog(@"%@", lecture);
        } else NSLog(@"Not Found");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)addressChanged:(id)sender {
    [app.server setConnectionURL:[(UITextField *)sender text]];
}

- (IBAction)streamRequest:(id)sender {
    [self connectToLecture:_lectureName.text];
}

- (IBAction)downloadRequest:(id)sender {
    [self downloadLecture:_lectureName.text];
}
- (void)viewDidUnload {
    [self setServerAddress:nil];
    [self setLectureName:nil];
    [super viewDidUnload];
}
@end
