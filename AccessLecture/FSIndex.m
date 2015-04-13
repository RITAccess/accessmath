//
//  FSIndex.m
//  AccessLecture
//
//  Created by Michael Timbrook on 3/30/15.
//
//

#import "FSIndex.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "FileManager.h"

@implementation FSIndex
{
    FMDatabaseQueue *_db;
    NSURL *_indexPath;
    dispatch_queue_t _worker;
    NSArray *_files;
}

+ (instancetype)sharedIndex {
    static id shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[FSIndex alloc] initWithIndex:[NSURL URLWithString:[[FileManager localDocumentsDirectoryPath] stringByAppendingPathComponent:@"fs_index.db"]]];
    });
    return shared;
}

- (instancetype)initWithIndex:(NSURL *)pathToIndex
{
    self = [super init];
    if (self)
    {
        _indexPath = pathToIndex;
        _worker = dispatch_queue_create("fsindex.am.rit", DISPATCH_QUEUE_SERIAL);
        [self setupDatabase:YES];
        dispatch_async(_worker, ^{
            [self beginIndexing];
        });
    }
    return self;
}

- (void)setupDatabase:(BOOL)clean
{
    BOOL hasDB = [[NSFileManager defaultManager] fileExistsAtPath:_indexPath.absoluteString isDirectory:NO];
    if (!hasDB || clean) {
        [self createDatabase];
    }
}

- (void)createDatabase
{
    [[NSFileManager defaultManager] removeItemAtPath:_indexPath.absoluteString error:nil];
    _db = [FMDatabaseQueue databaseQueueWithPath:_indexPath.absoluteString];
}

- (NSUInteger)count
{
    return _files.count;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return _files[idx];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    
}

- (void)beginIndexing
{
    NSLog(@"DEBUG: FS Indexing started");
    NSArray *docuemnts = [FileManager listContentsOfDirectory:[FileManager localDocumentsDirectoryPath]];
    [_db inDatabase:^(FMDatabase *db) {
        bool success = [db executeStatements:@"drop table if exists fs_name_index; create table fs_name_index (filename varchar(80), unique (filename));"];
        NSLog(@"DEBUG: query %@", success ? @"YES" : @"NO");
    }];
    [_db inDatabase:^(FMDatabase *db) {
        for (NSString *fileName in docuemnts) {
            [db executeUpdate:@"INSERT into fs_name_index (filename) VALUES (?)", fileName];
        }
    }];
    NSMutableArray *files = [NSMutableArray new];
    [_db inDatabase:^(FMDatabase *db) {
        FMResultSet *results = [db executeQuery:@"select * from fs_name_index;"];
        while ([results next]) {
            [files addObject:[results stringForColumn:@"filename"]];
        }
        [results close];
    }];
    _files = files;
}

- (void)invalidate
{
	
}

@end
