//
//  MockData.m
//  MockData
//
//  Created by Michael Timbrook on 3/16/15.
//
//

#import "FileManager.h"
#import "MockData.h"
#import "Note.h"
#import "FSIndex.h"

void signal_done(dispatch_semaphore_t lc, dispatch_semaphore_t count) {
    int res = dispatch_semaphore_wait(count, DISPATCH_TIME_NOW);
    if(res > 0) {
        dispatch_semaphore_signal(lc);
    }
}

@implementation MockData

- (BOOL)generateData
{
    NSLog(@"DEBUG: deleting old docs...");
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *directory = [[FSIndex localDocumentsDirectoryPath] stringByAppendingPathComponent:@"/"];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
        if (!success || error) {
            NSLog(@"DEBUG: %@", error);
            NSLog(@"DEBUG: %@", file);
        }
    }
    NSLog(@"DEBUG: done");
    
    int count = 500;
    
    // In order for dispatch_release() to be called on the semaphore, the calls
    // between signal/wait need to be ballanced. Can't just create a semaphore
    // at count - 1.
    dispatch_semaphore_t created = dispatch_semaphore_create(0);
    int c = count - 1;
    while (c--> 0) {
        dispatch_semaphore_signal(created);
    }
    
    dispatch_semaphore_t lecture_creation = dispatch_semaphore_create(0);
    while (--count >= 0) {
        [FileManager createDocumentWithName:[NSString stringWithFormat:@"Test Document %i", count] completion:^(NSError *error, AMLecture *current) {
            [self createNoteDataOnLecture:current completion:^{
                signal_done(lecture_creation, created);
            }];
        }];
    }
    
    NSLog(@"DEBUG: creating docs...");
    dispatch_semaphore_wait(lecture_creation, DISPATCH_TIME_FOREVER);
    NSLog(@"DEBUG: done");
    return YES;
}

- (void)createNoteDataOnLecture:(AMLecture *)lecture completion:(void(^)())completion
{
    for (int i = 0; i < 20; i++) {
        Note *n = [Note new];
        n.title = @"Test Note";
        n.content = @"Note stuff";
        [lecture.lecture addNotes:[NSSet setWithObject:n]];
    }
    
    [lecture saveWithCompletetion:^(BOOL success) {
        completion();
    }];

}


@end
