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
    return;
}

- (void)beginIndexing
{
    [self beginIndexingAtPath:@"/"];
}

- (void)beginIndexingAtPath:(NSString *)path
{
    NSLog(@"DEBUG: FS Indexing started");
    NSString *base = [FSIndex localDocumentsDirectoryPath];
    NSLog(@"DEBUG: %@", base);
    NSArray *docuemnts = [FSIndex listContentsOfDirectory:[base stringByAppendingPathComponent:path]];
    [_db inDatabase:^(FMDatabase *db) {
        bool success = [db executeStatements:@"drop table if exists fs_name_index; create table fs_name_index (filename varchar(80), directory varchar(80));"];
        NSLog(@"DEBUG: created table %@", success ? @"YES" : @"NO");
    }];
    [_db inDatabase:^(FMDatabase *db) {
        for (NSString *fileName in docuemnts) {
            [db executeUpdate:@"INSERT into fs_name_index (filename, directory) VALUES (?,?)", fileName, path];
        }
    }];
    NSMutableArray *files = [NSMutableArray new];
    [_db inDatabase:^(FMDatabase *db) {
        FMResultSet *results = [db executeQuery:@"select * from fs_name_index;"];
        while ([results next]) {
            [files addObject:[results stringForColumn:@"filename"]];
//            NSLog(@"DEBUG: %@ in %@", [results stringForColumn:@"filename"], [results stringForColumn:@"directory"]);
        }
        [results close];
    }];
    _files = files;
}

- (void)invalidate
{
    [self createDatabase];
    [self beginIndexing];
}

#pragma mark - File System Quering

+ (NSArray *)listContentsOfDirectory:(NSString *)path
{
    NSError *err;
    NSArray *names = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&err];
    if (err) {
        NSLog(@"There was an error reading directory '%@', %@", path, err);
        return nil;
    }
    NSPredicate *isFile = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *fullPath = [path stringByAppendingPathComponent:evaluatedObject];
        NSLog(@"DEBUG: %@", fullPath);
        bool isDirectory = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory];
        NSLog(@"DEBUG: isDirectory %@", isDirectory ? @"YES" : @"NO");
        return !(isDirectory);
    }];
    NSPredicate *isLecture = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[[evaluatedObject componentsSeparatedByString:@"."] lastObject] isEqualToString:@"lec"];
    }];
    return [[[names filteredArrayUsingPredicate:isFile] filteredArrayUsingPredicate:isLecture]
    sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(NSString *file1, NSString *file2) {
        NSError *error;
        
        NSString *f1 = [[FSIndex localDocumentsDirectoryPath] stringByAppendingPathComponent:file1];
        NSString *f2 = [[FSIndex localDocumentsDirectoryPath] stringByAppendingPathComponent:file2];
        
        NSDictionary* p1 = [[NSFileManager defaultManager]
                            attributesOfItemAtPath:f1
                            error:&error];
        
        NSDictionary* p2 = [[NSFileManager defaultManager]
                            attributesOfItemAtPath:f2
                            error:&error];
        
        NSDate *fileDate1 = [p1 objectForKey:NSFileModificationDate];
        NSDate *fileDate2 = [p2 objectForKey:NSFileModificationDate];
        
        return [fileDate2 compare:fileDate1];
    }];
}

+ (NSString *)localDocumentsDirectoryPath {
    static NSString *documentsDirectoryPath;
    if (!documentsDirectoryPath) {
        documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    return documentsDirectoryPath;
}

+ (NSURL *)iCloudDirectoryURL {
    NSURL *ubiquity = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    return ubiquity;
}


@end
