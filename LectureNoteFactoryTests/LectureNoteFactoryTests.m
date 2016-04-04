//
//  LectureNoteFactoryTests.m
//  LectureNoteFactoryTests
//
//  Created by Michael Timbrook on 3/1/16.
//
//

#import <XCTest/XCTest.h>
#import "AMLecture.h"
#import "NoteTakingNote.h"

static NSString *testPath = @"~/Documents/testing-lecture-16231A42-2361-4A79-8128-CB019BF9A614.lec";

@interface LectureNoteFactoryTests : XCTestCase

@property AMLecture *lecture;

@end

@implementation LectureNoteFactoryTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    dispatch_semaphore_t createdDoc = dispatch_semaphore_create(0);
    
    self.lecture = [[AMLecture alloc] initWithFileURL:[NSURL fileURLWithPath:[testPath stringByExpandingTildeInPath]]];
    [self.lecture saveToURL:self.lecture.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        dispatch_semaphore_signal(createdDoc);
    }];
    while (dispatch_semaphore_wait(createdDoc, 1)) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [[NSFileManager defaultManager] removeItemAtPath:testPath error:nil];
}

- (void)testLectureDoesntReturnNilNotes {
    NSArray *notes = self.lecture.getNotes;
    XCTAssertNotNil(notes, @"Lectures notes returned nil array");
}

- (void)testCreatingANewNoteUsingFactoryMethod_createNote {
    NoteTakingNote *note = [self.lecture createNote];
    XCTAssertNotNil(note, @"Note failed creation");
    XCTAssertEqual(note.location.x, 0.0, @"Failed x position");
    XCTAssertEqual(note.location.y, 0.0, @"Failed y position");
}

- (void)testCreatingANewNoteUsingFactoryMethod_hasDefaultTitleAndContent {
    NoteTakingNote *note = [self.lecture createNote];
    XCTAssertNotNil(note, @"Note failed creation");
    XCTAssert([note.title isEqualToString:@"New Note"], @"Failed to have title");
}

- (void)testCreatingANewNoteUsingFactoryMethod_createNoteAtPosition {
    NoteTakingNote *note = [self.lecture createNoteAtPosition:(CGPoint) { .x = 50.0, .y = 70.0 }];
    XCTAssertNotNil(note, @"Note failed creation");
    XCTAssertEqual(note.location.x, 50.0, @"Failed x position");
    XCTAssertEqual(note.location.y, 70.0, @"Failed y position");
}

- (void)testFetchingNotesForTypeNoteTakingNote {
    // Create Three notes as NoteTakingNote
    NoteTakingNote *a = [self.lecture createNote]; [self.lecture createNote]; [self.lecture createNote];
    a.title = @"Different";
    
    // Fetch as ShuffleNote
    [self.lecture getNotes];
    
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
