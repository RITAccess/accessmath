//
//  NoteShuffleButton.m
//  AccessLecture
//
//  Created by Piper on 10/9/15.
//
//

#import "NoteShuffleButton.h"
#import "AccessLectureKit.h"

@implementation NoteShuffleButton

- (void)drawRect:(CGRect)rect
{
    [AccessLectureKit drawNoteShuffleButtonWithFrame:rect];
}

@end
