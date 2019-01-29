//
//  NotesViewController.h
//  LandScapeV2
//
//  Created by Student on 6/16/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "AMLecture.h"
#import "MoreShuffle.h"

@interface NoteShuffleViewController : UIViewController

@property AMLecture *selectedLecture;
@property (strong) MoreShuffle *shuffleSKScene;//added from .m file by Rafique

@end
