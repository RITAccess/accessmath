//
//  FSIndex.m
//  AccessLecture
//
//  Created by Michael Timbrook on 3/30/15.
//
//

#import "AMIndex.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "FileManager.h"

NSString *const FSFileChangeNotification = @"static NSString *const FSFileChangeNotification";

@implementation AMIndex
{
    FMDatabaseQueue *_db;
    NSNotificationCenter *_nc;
    NSURL *_indexPath;
    dispatch_queue_t _worker;
}

+ (instancetype)sharedIndex {
    static id shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[AMIndex alloc] initWithIndex:[NSURL URLWithString:[[@"~" stringByExpandingTildeInPath] stringByAppendingPathComponent:@"fs_index.db"]]];
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

- (NSArray *)objectForKeyedSubscript:(id <NSCopying>)key;
{
    NSString *requested = [[(NSString *)key stringByExpandingTildeInPath] stringByStandardizingPath];
    bool directoryRequest = [[requested substringFromIndex:requested.length - 1] isEqualToString:@"*"];
    if (directoryRequest) {
        NSString *dir = [requested substringToIndex:requested.length - 1];
        return [AMIndex listContentsOfDirectory:dir justDirectorys:YES];
    }
    
    static NSString *path;
    static NSMutableArray *documents;
    [[NSNotificationCenter defaultCenter] addObserverForName:FSFileChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // This caching should probable be moved into a global state.
        documents = nil;
    }];
    if (documents && path && [requested isEqualToString:path]) {
        return documents;
    } else {
        path = requested;
        documents = [NSMutableArray new];
        [_db inDatabase:^(FMDatabase *db) {
            FMResultSet *results = [db executeQuery:@"select * from fs_name_index where directory=? order by modification desc;", [path stringByAbbreviatingWithTildeInPath]];
            while ([results next]) {
                [documents addObject:[results stringForColumn:@"filename"]];
            }
            [results close];
        }];
        return (NSArray *)documents;
    }
}

- (void)beginIndexing
{
    [_db inDatabase:^(FMDatabase *db) {
        bool success = [db executeStatements:@"drop table if exists fs_name_index; create table fs_name_index (filename varchar(80), directory varchar(80), modification REAL);"];
        NSLog(@"DEBUG: created table %@", success ? @"YES" : @"NO");
    }];
    [self beginIndexingAtPath:@"~/Documents"];
    NSLog(@"DEBUG: Finished");
    [self notifyFileCacheChange];
}

- (void)beginIndexingAtPath:(NSString *)path
{
    NSLog(@"DEBUG: FS Indexing started at %@", path);
    NSArray *directories = [AMIndex listContentsOfDirectory:[path stringByExpandingTildeInPath] justDirectorys:YES];
    NSArray *docs = [AMIndex listContentsOfDirectory:[path stringByExpandingTildeInPath] justDirectorys:NO];
    
    [_db inDatabase:^(FMDatabase *db) {
        for (NSString *fileName in docs) {
            NSError *error;
            NSDictionary* p1 = [[NSFileManager defaultManager]
                                attributesOfItemAtPath:[[path stringByExpandingTildeInPath] stringByAppendingPathComponent:fileName]
                                error:&error];
            double date = (double)[[p1 objectForKey:NSFileModificationDate] timeIntervalSince1970];
            NSNumber *time = [NSNumber numberWithDouble:date];
            [db executeUpdate:@"INSERT into fs_name_index (filename, directory, modification) VALUES (?,?,?)", fileName, [path stringByAbbreviatingWithTildeInPath], time];
        }
    }];
    
    for (NSString *directory in directories) {
        [self beginIndexingAtPath:[path stringByAppendingPathComponent:directory]];
    }
}

- (void)addToIndex:(NSURL *)file completion:(void(^)(NSError *error))completion
{
    if (file.isFileURL) {
        NSString *directory = [file.resourceSpecifier stringByDeletingLastPathComponent];
        NSString *docName = [file.resourceSpecifier stringByReplacingOccurrencesOfString:directory withString:@""];
        double date = (double)[[NSDate new] timeIntervalSince1970];
        NSNumber *time = [NSNumber numberWithDouble:date];
        [_db inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"INSERT into fs_name_index (filename, directory, modification) VALUES (?,?,?)", [[docName stringByRemovingPercentEncoding] substringFromIndex:1], [directory stringByAbbreviatingWithTildeInPath], time];
        }];
        [self notifyFileCacheChange];
        completion(nil);
    } else {
        completion([NSError errorWithDomain:@"FSError" code:401 userInfo:@{}]);
    }
}


- (void)invalidate
{
    [self createDatabase];
    dispatch_async(_worker, ^{
        [self beginIndexing];
    });
}

#pragma mark - Notifications

- (void)notifyFileCacheChange
{
    if (!_nc) {
        _nc = [NSNotificationCenter defaultCenter];
    }
    [_nc postNotificationName:FSFileChangeNotification object:nil userInfo:nil];
}

#pragma mark - File System Quering

+ (NSArray *)listContentsOfDirectory:(NSString *)path justDirectorys:(bool)justDirectory
{
    NSError *err;
    NSArray *names = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&err];
    if (err) {
        NSLog(@"There was an error reading directory '%@', %@", path, err);
        return nil;
    }
    NSPredicate *isFile = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *fullPath = [path stringByAppendingPathComponent:evaluatedObject];
        BOOL isDirectory = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory];
        return !(isDirectory);
    }];
    NSPredicate *isDirectory = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *fullPath = [path stringByAppendingPathComponent:evaluatedObject];
        BOOL _isDirectory = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&_isDirectory];
        return _isDirectory;
    }];
    NSPredicate *isLecture = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[[evaluatedObject componentsSeparatedByString:@"."] lastObject] isEqualToString:@"lec"];
    }];
    NSCompoundPredicate *filterLecture = [NSCompoundPredicate andPredicateWithSubpredicates:@[isFile, isLecture]];
    return [[names filteredArrayUsingPredicate:justDirectory ? isDirectory : filterLecture]
    sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(NSString *file1, NSString *file2) {
        NSError *error;
        
        NSString *f1 = [[AMIndex localDocumentsDirectoryPath] stringByAppendingPathComponent:file1];
        NSString *f2 = [[AMIndex localDocumentsDirectoryPath] stringByAppendingPathComponent:file2];
        
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
