//
//  NotesViewController.h
//  AccessLecture
//
//  Created by Student on 6/26/13.
//
//

#import <UIKit/UIKit.h>
#import "LineDrawView.h"
@interface NotesViewController : UIViewController<UITextViewDelegate>
{
    UIColor *textColor;
    UIColor *drawcolor;
    CGFloat lastScale;
}
@property (nonatomic) BOOL isCreatingNote;
@property (nonatomic) BOOL isDrawing;
@property (nonatomic) CGPoint *start;
@property UITapGestureRecognizer *tapToCreateNote;
@property UITapGestureRecognizer *tapToCreateNoteDrawingNote;
- (IBAction)createDrawNote:(id)sender;

- (IBAction)createTextNote:(id)sender;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *drawNote;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *textNote;

@property UITapGestureRecognizer *tapToDismissKeyboard;
@end
