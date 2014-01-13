//
//  AMLecture.m
//  AccessLecture
//
//  Created by Michael Timbrook on 9/19/13.
//
//

#import "AMLecture.h"

static NSString *MetaKey = @"meta";
static NSString *LectureKey = @"lecture";

@implementation AMLecture

- (id)initWithFileURL:(NSURL *)url
{
    self = [super initWithFileURL:url];
    if (self) {
        _metadata = [ALMetaData new];
        _metadata.dateCreated = [NSDate date];
        _metadata.title = @"Untitled";
        _lecture = [Lecture new];
    }
    return self;
}

- (void)save
{
    [self saveWithCompletetion:nil];
}

- (void)saveWithCompletetion:(void(^)(BOOL success))completion
{
    [self saveToURL:self.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:completion];
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSData *archivedData = (NSData *)contents;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:archivedData];
    
    _metadata = [unarchiver decodeObjectForKey:MetaKey];
    _lecture = [unarchiver decodeObjectForKey:LectureKey];
    
    return YES;
}

- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSMutableData *archivedData = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archivedData];
    
    [archiver encodeObject:_metadata forKey:MetaKey];
    [archiver encodeObject:_lecture forKey:LectureKey];
    
    [archiver finishEncoding];
    
    return (NSData *)archivedData;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"AMLecture<%d> Title: '%@' number of notes %d", [super hash], _metadata.title, _lecture.notes.count];
}

@end
