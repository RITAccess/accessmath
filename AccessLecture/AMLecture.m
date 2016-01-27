//
//  AMLecture.m
//  AccessLecture
//
//  Created by Michael Timbrook on 9/19/13.
//
//

#import "AMLecture.h"
#import "AccessLectureKit.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "Note.h"

#define TEST 1

#define DB_NAME @"notes.db"
#define NOTE_TABLE @"notes"
#define STATE_TABLE @"state"
#define META_TABLE @"meta"

static NSString *MetaKey = @"meta";
static NSString *LectureKey = @"lecture";

@interface AMLecture ()

@property NSFileWrapper *fileWrapper;
@property (readonly) NSString *databasePath;

@end

@implementation AMLecture {
     FMDatabaseQueue * _Nonnull _db;
}

- (id)initWithFileURL:(NSURL *)url
{
    self = [super initWithFileURL:url];
    if (self) {
        _metadata = [ALMetaData new];
        _metadata.dateCreated = [NSDate date];
        _metadata.title = @"Untitled";
        _lecture = [Lecture new];
        [_lecture setParent:self];
    }
    return self;
}

- (NSString *)databasePath {
    static NSString *path;
    if (!path) {
        path = [self.fileURL.path stringByAppendingPathComponent:DB_NAME];
    }
    return path;
}

- (void)initDatabaseConnection {
    if (![NSFileManager.defaultManager fileExistsAtPath:self.databasePath]) {
        [NSFileManager.defaultManager createFileAtPath:self.databasePath contents:[NSData new] attributes:NULL];
    }
    _db = [FMDatabaseQueue databaseQueueWithPath:self.databasePath];
    [_db inDatabase:^(FMDatabase *db) {
        bool success = [db executeStatements:
                        @"create table IF NOT EXISTS " NOTE_TABLE @" (title varchar(80), contents varchar(5000), modification REAL);"
                        @"create table IF NOT EXISTS " STATE_TABLE @" (position varchar(80), modification REAL);"
                        @"create table IF NOT EXISTS " META_TABLE @" (title varchar(80), date varchar(80) modification REAL);"

                    ];
        
        NSLog(@"DEBUG: created %@", success ? @"YES" : @"NO");
    }];
}

#pragma mark Encode and decode file wrappers

- (void)encodeObject:(id<NSCoding>)object toWrappers:(NSMutableDictionary *)wrappers preferredFilename:(NSString  *)preferredFilename
{
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archive encodeObject:object forKey:@"data"];
    [archive finishEncoding];
    NSFileWrapper *wrap = [[NSFileWrapper alloc] initRegularFileWithContents:data];
    [wrappers setObject:wrap forKey:preferredFilename];
}

- (void)encodeImage:(UIImage *)image toWrappers:(NSMutableDictionary *)wrappers preferredFilename:(NSString *)preferredFilename
{
    NSFileWrapper *wrap = [[NSFileWrapper alloc] initRegularFileWithContents:UIImagePNGRepresentation(image)];
    [wrappers setObject:wrap forKey:preferredFilename];
}

- (id)decodeObjectFromWrapperWithPreferredFilename:(NSString *)preferredFilename {
    
    NSFileWrapper * fileWrapper = [self.fileWrapper.fileWrappers objectForKey:preferredFilename];
    if (!fileWrapper) {
        NSLog(@"Unexpected error: Couldn't find %@ in file wrapper!", preferredFilename);
        return nil;
    }
    
    NSData * data = [fileWrapper regularFileContents];
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    return [unarchiver decodeObjectForKey:@"data"];
    
}

- (id)decodeImageFromWrapperWithPreferredFilename:(NSString *)preferredFilename
{
    NSFileWrapper * fileWrapper = [self.fileWrapper.fileWrappers objectForKey:preferredFilename];
    if (!fileWrapper) {
        NSLog(@"Unexpected error: Couldn't find %@ in file wrapper!", preferredFilename);
        return nil;
    }
    NSData * data = [fileWrapper regularFileContents];
    return [UIImage imageWithData:data];
}

#pragma mark Open and close file wrapper

- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSMutableDictionary *wrappers = [NSMutableDictionary dictionary];
    [self encodeObject:self.metadata toWrappers:wrappers preferredFilename:@"lecture.meta"];
    [self encodeObject:self.lecture toWrappers:wrappers preferredFilename:@"lecture.data"];
    [self encodeImage:self.thumb toWrappers:wrappers preferredFilename:@"thumb.png"];
    NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:wrappers];
    return fileWrapper;
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    self.fileWrapper = (NSFileWrapper *)contents;
    // Lazy load everything
    self.metadata = nil;
    self.lecture = nil;
    self.thumb = nil;
    [self initDatabaseConnection];
#if TEST
    NSLog(@"DEBUG: %@", [self testSomeCode]);;
#endif
    return YES;
}

#pragma mark Load in file contents

- (UIImage *)thumb
{
    if (_thumb == nil) {
        if (self.fileWrapper != nil) {
            self.thumb = [self decodeImageFromWrapperWithPreferredFilename:@"thumb.png"];
        } else {
            self.thumb = [AccessLectureKit imageOfNoLecture:CGRectMake(0, 0, 180, 250)];
        }
    }
    return _thumb;
}

- (ALMetaData *)metadata
{
    if (_metadata == nil) {
        if (self.fileWrapper != nil) {
            self.metadata = [self decodeObjectFromWrapperWithPreferredFilename:@"lecture.meta"];
        } else {
            self.metadata = [ALMetaData new];
        }
    }
    return _metadata;
}

- (Lecture *)lecture
{
    if (_lecture == nil) {
        if (self.fileWrapper != nil) {
            self.lecture = [self decodeObjectFromWrapperWithPreferredFilename:@"lecture.data"];
        } else {
            self.lecture = [Lecture new];
        }
    }
    return _lecture;
}

- (void)save
{
    [self saveWithCompletetion:nil];
}

- (void)saveWithCompletetion:(void(^)(BOOL success))completion
{
    [self saveToURL:self.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:completion];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"AMLecture<%d> Title: '%@' number of notes %d", [super hash], _metadata.title, _lecture.notes.count];
}

#if TEST
- (NSArray<Note *> *)testSomeCode {
    __block FMResultSet *results;
    [_db inDatabase:^(FMDatabase *db) {
        [db executeUpdate:
            @"INSERT into " NOTE_TABLE @" (title, contents) VALUES ('Test Note', 'Test not content that is resonably long but probably doesnt reach some edge case');"
         ];
        results = [db executeQuery:@"select * from " NOTE_TABLE];
    }];
    NSMutableArray<Note *> *resultsArray = [@[] mutableCopy];
    while ([results next]) {
        Note *n = [Note new];
        [n setTitle:[results stringForColumn:@"title"]];
        [n setContent:[results stringForColumn:@"contents"]];
        [resultsArray addObject:n];
    }
    [results close];
    return resultsArray;
}
#endif

- (NSArray *)getNotes __deprecated_msg("Getting notes will require a state referance otherwise locations can't be populated. More info on how note listing will work. Will most likely be moved to Lecture.h and be a promise");
{
    return _lecture.notes;
}

@end
