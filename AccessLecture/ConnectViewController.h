//
//  ConnectViewController.h
//  AccessLecture
//
//  Created by Michael Timbrook on 6/7/13.
//
//

#import <UIKit/UIKit.h>

@interface ConnectViewController : UIViewController


/* UI Interfacing */
- (IBAction)cancel:(id)sender;
- (IBAction)addressChanged:(id)sender;
- (IBAction)streamRequest:(id)sender;
- (IBAction)downloadRequest:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *serverAddress;
@property (weak, nonatomic) IBOutlet UITextField *lectureName;


@end
