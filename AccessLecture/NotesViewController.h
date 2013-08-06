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
#import "UISegmentedControlExtension.h"
#import "Note.h"
static NSString* const NotesViewControllerXIB = @"NotesViewController";
@interface NotesViewController : UIViewController<UITextViewDelegate,LectureViewChild>{
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
    NSInteger drawIndex;
}
@property UIView *mainView;
@property (nonatomic) BOOL isCreatingNote;
@property (nonatomic) BOOL isDrawing;
@property (nonatomic) CGPoint *start;
@property UITapGestureRecognizer *tapToCreateNote;
@property UITapGestureRecognizer *tapToCreateNoteDrawingNote;
@property UISegmentedControl *notesPanelControl;
@property UITapGestureRecognizer *tapToDismissKeyboard;
@property (weak, nonatomic) IBOutlet UIImageView *trashBin;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;


- (IBAction)createDrawNote:(id)sender;
- (IBAction)createTextNote:(id)sender;
- (IBAction)undoButtonPressed:(id)sender;
- (IBAction)erasePressed:(id)sender;

@end
