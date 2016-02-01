//
//  NoteInterface.m
//  AccessLecture
//
//  Created by Michael Timbrook on 1/28/16.
//
//

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
    }
    return self;
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

- (CGPoint)location {
    __block FMResultSet *r;
    [_db inDatabase:^(FMDatabase *db) {
        r = [db executeQuery:@"select position from state where noteId=? and stateGrouping=?" withArgumentsInArray:@[@(_noteID), @(_state)]];
    }];
    [r next];
    NSString *point = [r stringForColumn:@"position"];
    [r close];
    return CGPointFromString(point);
}

- (void)setLocation:(CGPoint)location {
//    self.location = location;
}

- (NSInteger)zIndex {
    return 0;
}

- (void)setZIndex:(NSInteger)zIndex {
    
}

@end
