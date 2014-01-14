//
//  TextNoteView.h
//  AccessLecture
//
//  Created by Michael on 1/6/14.
//
//

#import <UIKit/UIKit.h>
#import "TextNoteViewDelegate.h"
#import "Note.h"

@interface TextNoteView : UIView <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic) id<TextNoteViewDelegate> delegate;

@property (nonatomic) Note *data;

@property (weak, nonatomic) IBOutlet UITextField *title;
@property (weak, nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

- (IBAction)hideView;
- (IBAction)titleActions:(id)sender forEvent:(UIEvent *)event;
- (IBAction)fullScreeen:(id)sender;

@end
