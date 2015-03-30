//
//  FSIndex.m
//  AccessLecture
//
//  Created by Michael Timbrook on 3/30/15.
//
//

#import "FSIndex.h"
#import "FMDatabaseQueue.h"

@implementation FSIndex
{
    FMDatabaseQueue *_db;
    NSURL *_indexPath;
}

- (instancetype)initWithIndex:(NSURL *)pathToIndex
{
    self = [super init];
    if (self)
    {
        _indexPath = pathToIndex;
        _db = [FMDatabaseQueue databaseQueueWithPath:pathToIndex.absoluteString];
        [self beginIndexing];
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
    
}

- (NSArray *)files
{
    return @[];
}

- (void)beginIndexing
{
    NSLog(@"DEBUG: FS Indexing started");
}

@end
