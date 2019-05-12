//
//  AMLecture.m
//  AccessLecture
//
//  Created by Michael Timbrook on 9/19/13.
//
//

@import CoreData;

#import "AMLecture.h"
#import "AccessLectureKit.h"
#import "ShuffleNote.h"
#import "Note.h"

static NSString *MetaKey = @"meta";
static NSString *LectureKey = @"lecture";

@interface AMLecture ()

@property NSFileWrapper *fileWrapper;

// Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation AMLecture
{
    NSManagedObjectContext *_managedObjectContext;
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
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
    [self saveWithCompletetion:^(BOOL success) {
        //
        NSLog(@"DEBUG: document did save - from AMLecture %@", success ? @"YES" : @"NO");
    }];
}

- (void)saveWithCompletetion:(void(^)(BOOL success))completion
{
    NSError *error;
    [[self managedObjectContextForLecture:self] save:&error]; //saves the context (.sqlite)
    NSLog(@"DEBUG: %@", error);
    static dispatch_once_t onceToken;
    if (onceToken) {
        NSLog(@"DEBUG: returning do to another save");
        completion(FALSE);
        return;
    }
    dispatch_once(&onceToken, ^{
        NSLog(@"DEBUG: dispatching save");
        dispatch_after(500, dispatch_get_main_queue(), ^{
            onceToken = 0;
            completion(TRUE);
        });
        [self saveToURL:self.fileURL forSaveOperation:UIDocumentSaveForOverwriting
            completionHandler:^(BOOL success) {
              onceToken = 0;
              completion(success);
            }];
    });
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"AMLecture<%d> Title: '%@'", [super hash], _metadata.title];
}

#pragma mark - Note factory methods
- (id)createNoteOfType:(Class)type
{
    return [self createNoteAtPosition:CGPointZero ofType:type];
}

- (id)createNoteAtPosition:(CGPoint)point ofType:(Class)type
{
    Note *parent = [Note insertInManagedObjectContext:[self managedObjectContextForLecture:self]];
    
    NoteTakingNote *tnote = [NoteTakingNote insertInManagedObjectContext:[self managedObjectContextForLecture:self]];
    ShuffleNote *snote = [ShuffleNote insertInManagedObjectContext:[self managedObjectContextForLecture:self]];

    [tnote setNote:parent];
    [snote setNote:parent];
    
    [tnote setLocation:point];
    [snote setLocation:point];
    
    [[self managedObjectContextForLecture:self] save:nil];
    
    if ([NSStringFromClass(type) isEqualToString:@"NoteTakingNote"]) {
        return tnote;
    }
    
    if ([NSStringFromClass(type) isEqualToString:@"ShuffleNote"]) {
        return snote;
    }
    
    return nil;
}

- (NSArray *)notes
{
    NSLog(@"DEBUG: fetching notes");
    
    NSManagedObjectContext *nmoc = [self managedObjectContextForLecture:self];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NoteTakingNote"];
    NSError *error = nil;
    NSArray *notes = [nmoc executeFetchRequest:request error:&error];
    if (!notes) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    return notes;
}

//Get the managed object context from AccessLectureAppDelegate class
- (NSManagedObjectContext *)managedObjectContextForLecture:(AMLecture*)lecture {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContextForLecture:) withObject:lecture]) {
        context = [delegate managedObjectContextForLecture:lecture];
    }
    return context;
}

@end
