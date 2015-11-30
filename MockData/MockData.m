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
#import "AMIndex.h"
#import "MoreShuffle.h"

void signal_done(dispatch_semaphore_t lc, dispatch_semaphore_t count) {
    int res = dispatch_semaphore_wait(count, DISPATCH_TIME_NOW);
    if(res > 0) {
        dispatch_semaphore_signal(lc);
    }
}

@implementation MockData

- (NSArray *)loadData
{
    NSURL *contentURL = [NSURL URLWithString:@"http://www.gutenberg.org/files/98/98.txt"];
    NSURLRequest *request = [NSURLRequest requestWithURL:contentURL];
    NSError *error;
    NSURLResponse *response;
    NSData *totc = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *story = [NSString stringWithUTF8String:totc.bytes];
    
    NSArray *breakDown = [story componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return breakDown;
}

- (BOOL)generateData
{
    NSLog(@"DEBUG: deleting old docs...");
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *directory = [[AMIndex localDocumentsDirectoryPath] stringByAppendingPathComponent:@"/"];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
        if (!success || error) {
            NSLog(@"DEBUG: %@", error);
            NSLog(@"DEBUG: %@", file);
        }
    }
    NSLog(@"DEBUG: done");
    
    // Get Data
    NSArray *lines = [[self loadData] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *string, NSDictionary *bindings) {
        return ![string isEqualToString:@""];
    }]];
    
    int count = 500;
    int chunks = floor(lines.count / count);
    
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
            NSRange range = NSMakeRange(count * chunks, chunks);
            [self createNoteDataOnLecture:current withRange:range inCtx:lines completion:^{
                signal_done(lecture_creation, created);
            }];
        }];
    }
    
    NSLog(@"DEBUG: creating docs...");
    dispatch_semaphore_wait(lecture_creation, DISPATCH_TIME_FOREVER);
    NSLog(@"DEBUG: done");
    return YES;
}

- (void)createNoteDataOnLecture:(AMLecture *)lecture withRange:(NSRange)range inCtx:(NSArray *)lines completion:(void(^)())completion
{
    for (int i = range.location; i < range.location + range.length; i++) {
        Note *n = [Note new];
        NSString *line = lines[i];
        n.title = line;
        n.content = line;
        [lecture.lecture addNotes:[NSSet setWithObject:n]];
    }
    
    [lecture saveWithCompletetion:^(BOOL success) {
        completion();
    }];

}


@end
