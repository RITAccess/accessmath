//
//  NoteResetButton.m
//  AccessLectureKit
//
//  Created by Mohammad Rafique on 6/11/18.
//

#import "NoteResetButton.h"
#import "AccessLectureKit.h"

@implementation NoteResetButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawRect:(CGRect)rect
{
    [AccessLectureKit drawResetNoteButtonWithFrame:rect];
}

@end
