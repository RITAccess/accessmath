//
//  NewNotesSideViewController.h
//  AccessLecture
//
//  Created by Kimberly Sookoo on 2/11/16.
//
//

#import <UIKit/UIKit.h>

@protocol NewNotesSideViewControllerDelegate <NSObject>

@end

@interface NewNotesSideViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) id<NewNotesSideViewControllerDelegate> delegate;

@end