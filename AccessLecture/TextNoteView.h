//
//  TextNoteView.h
//  AccessLecture
//
//  Created by Michael on 1/6/14.
//
//

#import <UIKit/UIKit.h>

@interface TextNoteView : UIView

@property (weak, nonatomic) IBOutlet UITextView *text;
- (IBAction)hideView;

@end
