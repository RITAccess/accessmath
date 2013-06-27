//
//  NotesViewController.h
//  AccessLecture
//
//  Created by Student on 6/26/13.
//
//

#import <UIKit/UIKit.h>

@interface NotesViewController : UIViewController
@property (nonatomic) BOOL isCreatingNote;
@property (nonatomic) BOOL isDrawing;
@property (nonatomic) CGPoint *start;
@property UITapGestureRecognizer *tapToCreateNote;
@property UITapGestureRecognizer *tapToDismissKeyboard;
@end
