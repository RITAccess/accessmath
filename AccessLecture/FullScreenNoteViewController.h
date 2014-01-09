//
//  FullScreenNoteViewController.h
//  AccessLecture
//
//  Created by Michael on 1/8/14.
//
//

#import <UIKit/UIKit.h>

static NSString *const FullScreenNoteVCNibName = @"FullScreenNoteViewController";

@interface FullScreenNoteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *text;

- (IBAction)returnToLecture:(id)sender;

@end
