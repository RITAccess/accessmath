//
//  NotesViewController.h
//  AccessLecture
//
//  Created by Student on 6/26/13.
//
//

#import <UIKit/UIKit.h>
#import "FTCoreTextView.h"
#import "LectureViewContainer.h"
#import "DrawView.h"

static NSString* const NotesViewControllerXIB = @"NotesViewController";




@interface NotesViewController : UIViewController<UITextViewDelegate,LectureViewChild>
{
    UIColor *textColor;
    UIColor *drawcolor;
    CGFloat lastScale;
    NSString *startTag;
    NSString *endTag;
    BOOL isBackSpacePressed;
}

@property (nonatomic) BOOL isCreatingNote;
@property (nonatomic) BOOL isDrawing;
@property (nonatomic) CGPoint *start;
@property UITapGestureRecognizer *tapToCreateNote;
@property UITapGestureRecognizer *tapToCreateNoteDrawingNote;
- (IBAction)createDrawNote:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)createTextNote:(id)sender;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *drawNote;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *textNote;
- (IBAction)setBlueColor:(id)sender;

- (IBAction)setYellowColor:(id)sender;
- (IBAction)setRedColor:(id)sender;

@property UITapGestureRecognizer *tapToDismissKeyboard;

@end
