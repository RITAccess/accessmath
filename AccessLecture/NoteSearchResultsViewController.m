//
//  NoteSearchResultsViewController.m
//  AccessLecture
//
//  Created by Piper on 9/23/15.
//
//

#import "NoteSearchResultsViewController.h"


@implementation NoteSearchResultsViewController

// Presents note in search results pane
-(void)presentNote:(NoteTakingNote*)note
{
    _textNoteView.hidden = NO;
    _textNoteViewTitle.text = note.title;
    _textNoteViewContent.text = note.content;
}

@end
