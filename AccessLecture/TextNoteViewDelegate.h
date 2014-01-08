//
//  TextNoteViewDelegate.h
//  AccessLecture
//
//  Created by Michael on 1/8/14.
//
//

#import <Foundation/Foundation.h>

@protocol TextNoteViewDelegate <NSObject>

- (void)textNoteView:(id)sender didHide:(BOOL)hide;

- (void)textNoteView:(id)sender presentFullScreen:(BOOL)animated;

@end
