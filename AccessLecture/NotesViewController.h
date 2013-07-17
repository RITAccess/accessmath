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
#import "Lecture.h"
#import "AccessDocument.h"
#import "FileManager.h"
#import "AccessLectureRuntime.h"
static NSString* const NotesViewControllerXIB = @"NotesViewController";
@interface NotesViewController : UIViewController<UITextViewDelegate,LectureViewChild>
{
    UIColor *textColor;
    UIColor *drawcolor;
    CGFloat lastScale;
    NSString *startTag;
    NSString *endTag;
    BOOL isBackSpacePressed;
    Lecture *currentLecture;
    AccessDocument *currentDocument;
    BOOL isOpened;
    UIPanGestureRecognizer *panToMoveNote;
    UIPanGestureRecognizer *panToResize;
    UILongPressGestureRecognizer *longPressGestureRecognizer;
    UILongPressGestureRecognizer *longPressGestureRecognizer2;

}

@property (nonatomic) BOOL isCreatingNote;
@property (nonatomic) BOOL isDrawing;
@property (nonatomic) CGPoint *start;
@property UITapGestureRecognizer *tapToCreateNote;
@property UITapGestureRecognizer *tapToCreateNoteDrawingNote;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *drawNote;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *textNote;
@property UITapGestureRecognizer *tapToDismissKeyboard;

- (IBAction)setBlueColor:(id)sender;
- (IBAction)createDrawNote:(id)sender;
- (IBAction)setYellowColor:(id)sender;
- (IBAction)setRedColor:(id)sender;
- (IBAction)createTextNote:(id)sender;
- (IBAction)resizeDraw:(id)sender;

@end
