//
//  MoreShuffle.h
//  LandScapeV2
//
//  Created by Student on 7/24/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NoteTakingNote.h"

@interface MoreShuffle : SKScene<UIPopoverControllerDelegate>

@property NSArray* notesFromSelectedLecture;

@property NSMutableArray *notesToSelectedLecture;

@property NSMutableArray *notesToBeRemoved;

@property BOOL sceneReset;

-(void)newPaper;//added by Rafique
-(NSMutableDictionary*)getNoteData;//added by Rafique
@property NSDictionary *noteDetailsFromNewNote;
-(NoteTakingNote*) getTouchedNote;
@property BOOL isLastTouchedNodeNew;

@end
