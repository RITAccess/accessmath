//
//  NoteInterface.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/28/16.
//
//

#import <ReactiveCocoa.h>
#import "NoteInterface.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

#define THROTTLE 0.5

@interface NoteInterface ()

@end

@implementation NoteInterface {
    
    int _noteID;
    
    NSUInteger _state;
    FMDatabaseQueue *_db;
}

- (id)initWithOutsaveToDB:(FMDatabaseQueue *)pdb
                withState:(NSString *)state
                      xid:(int)xid
{
    self = [super init];
    if (self) {
        _db = pdb;
        _state = [state hash];
        _noteID = xid;

        // Update location
        __block FMResultSet *r;
        [_db inDatabase:^(FMDatabase *db) {
            r = [db executeQuery:@"select position, zIndex, title, contents from state join notes on notes.id=state.noteId where noteId=? and stateGrouping=?" withArgumentsInArray:@[@(_noteID), @(_state)]];
        }];
        [r next];
        
        self.title = [r stringForColumn:@"title"];
        self.content = [r stringForColumn:@"contents"];
        
        NSString *point = [r stringForColumn:@"position"];
        self.zIndex = [r intForColumn:@"zIndex"];
        self.location = CGPointFromString(point);
       
         [r close];
        
        [[RACObserve(self, zIndex)
          throttle:THROTTLE]
          subscribeNext:^(id x) {
             [self _updateZIndex:[x integerValue]];
         }];
        
        [[RACObserve(self, location)
          throttle:THROTTLE]
          subscribeNext:^(id x) {
             [self _updateLocation:[x CGPointValue]];
        }];
        
        [[RACObserve(self, title)
          throttle:THROTTLE]
          subscribeNext:^(NSString *x) {
             [self _updateTitle:x];
         }];
        
        [[RACObserve(self, content)
          throttle:THROTTLE]
          subscribeNext:^(NSString *x) {
             [self _updateContent:x];
         }];
    }
    return self;
}

- (void)_updateState:(NSString *)col with:(id)arg {
    [_db inDatabase:^(FMDatabase *db) {
        [db executeUpdate:[NSString stringWithFormat:@"update state set %@=? where noteId=? and stateGrouping=?", col] withArgumentsInArray:@[arg, @(_noteID), @(_state)]];
    }];
}

- (void)_updateNote:(NSString *)col with:(id)arg {
    [_db inDatabase:^(FMDatabase *db) {
        [db executeUpdate:[NSString stringWithFormat:@"update notes set %@=? where id=?", col] withArgumentsInArray:@[arg, @(_noteID)]];
    }];
}

- (void)_updateTitle:(NSString *)title {
    [self _updateNote:@"title" with:title];
}

- (void)_updateContent:(NSString *)cont {
    [self _updateNote:@"contents" with:cont];
}

- (void)_updateLocation:(CGPoint)loc {
    NSString *s = NSStringFromCGPoint(loc);
    NSLog(@"DEBUG: saving location %@", s);
    [self _updateState:@"position" with:s];
}

- (void)_updateZIndex:(NSInteger)z {
    [self _updateState:@"zIndex" with:@(z)];
}

- (void)setID:(NSString *)state inDB:(FMDatabaseQueue *)pdb new:(BOOL)create id:(NSInteger) idx {
    _state = [state hash];
    _db = pdb;
    __block FMResultSet *r;
    [_db inDatabase:^(FMDatabase *db) {
        if (create) {
            __unused bool s = [db executeUpdate:
                @"INSERT into notes (title, contents) VALUES ('New Note', '');"
            ];
            [db executeUpdate:
                @"INSERT into state (position, zIndex, stateGrouping, noteId) VALUES (?,?,?,(select max(id) from notes));"
            withArgumentsInArray:@[NSStringFromCGPoint(CGPointZero), @0, @(_state)]];
            
            // Get the note id
            r = [db executeQuery:@"select max(id) as id from notes"];
        } else {
            // TODO find or create state and note
        }
    
    }];
    // ID
    [r next];
    _noteID = [r intForColumn:@"id"];
    [r close];
}


@end
