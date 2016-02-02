//
//  NoteInterface.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/28/16.
//
//

#import <ReactiveCocoa.h>
#import "NoteInterface.h"

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
            r = [db executeQuery:@"select position, zIndex from state where noteId=? and stateGrouping=?" withArgumentsInArray:@[@(_noteID), @(_state)]];
        }];
        [r next];
        NSString *point = [r stringForColumn:@"position"];
        self.zIndex = [r intForColumn:@"zIndex"];
        [r close];
        self.location = CGPointFromString(point);
        
        [[RACObserve(self, zIndex)
          throttle:3.0]
          subscribeNext:^(id x) {
             [self _updateZIndex:[x integerValue]];
         }];
        
        [[RACObserve(self, location)
          throttle:3.0]
          subscribeNext:^(id x) {
             [self _updateLocation:[x CGPointValue]];
        }];
        
    }
    return self;
}

- (void)_updateLocation:(CGPoint)loc {
    NSString *s = NSStringFromCGPoint(loc);
    [_db inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"update state set position=? where noteId=? and stateGrouping=?" withArgumentsInArray:@[s, @(_noteID), @(_state)]];
    }];
}

- (void)_updateZIndex:(NSInteger)z {
    [_db inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"update state set zIndex=? where noteId=? and stateGrouping=?" withArgumentsInArray:@[@(z), @(_noteID), @(_state)]];
    }];
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
