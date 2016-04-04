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

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AccessLecture" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self fileURL] URLByAppendingPathComponent:@"notes.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Should properly handle dump here, abort() shouldn't be used in production
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
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

#pragma mark - Note factory methods
- (NoteTakingNote *)createNote
{
    return [self createNoteAtPosition:CGPointZero];
}

- (NoteTakingNote *)createNoteAtPosition:(CGPoint)point
{
    Note *parent = [Note insertInManagedObjectContext:self.managedObjectContext];
    
    NoteTakingNote *tnote = [NoteTakingNote insertInManagedObjectContext:self.managedObjectContext];
    ShuffleNote *snote = [ShuffleNote insertInManagedObjectContext:self.managedObjectContext];

    [tnote setLocation:point];
    
    [tnote setNote:parent];
    [snote setNote:parent];
    
    return tnote;
}

- (NSArray *)getNotes
{
    NSLog(@"DEBUG: fetching notes");
    NSFetchRequest *allNotes = [[NSFetchRequest alloc] initWithEntityName:@"Note"];
    
    
    NSArray *notes = [[self managedObjectContext] executeFetchRequest:allNotes error:nil];
    
    NSLog(@"DEBUG: %@", notes);
    
    return notes;
}

@end
