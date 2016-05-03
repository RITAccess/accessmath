//
//  TextNoteView.h
//  AccessLecture
//
//  Created by Michael on 1/6/14.
//
//

#import <UIKit/UIKit.h>
#import "TextNoteViewDelegate.h"
#import "NoteTakingNote.h"

@interface TextNoteView : UIView <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic) id<TextNoteViewDelegate> delegate;
@property (nonatomic) NoteTakingNote *data;
@property (nonatomic) IBOutlet UITextField *title;
@property (nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UIButton *minimzeButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *fullButton;

- (IBAction)hideView;
- (IBAction)titleActions:(id)sender forEvent:(UIEvent *)event;
- (IBAction)fullScreeen:(id)sender;

@end
