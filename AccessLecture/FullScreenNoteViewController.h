//
//  FullScreenNoteViewController.h
//  AccessLecture
//
//  Created by Michael on 1/8/14.
//
//

#import <UIKit/UIKit.h>
#import "TextNoteView.h"

static NSString *const FullScreenNoteVCNibName = @"FullScreenNoteViewController";

@interface FullScreenNoteViewController : UIViewController

@property (nonatomic) IBOutlet UITextView *text;
@property (nonatomic) IBOutlet UINavigationItem *titleLabel;
@property (nonatomic) TextNoteView *noteView;

- (IBAction)returnToLecture:(id)sender;
- (IBAction)changeFontSize:(id)sender;

@end
