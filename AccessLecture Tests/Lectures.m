//
//  Lectures.m
//  AccessLecture
//
//  Created by Michael Timbrook on 6/12/13.
//
//  This test class is for testing the UIDocument for the lecutues
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "AccessDocument.h"
#import "Note.h"
#import "ImageNote.h"
#import "Position.h"
#import "FileManager.h"

@interface Lectures : SenTestCase

@end

@implementation Lectures

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCreatingUIDocument
{

    NSString *file = [NSString stringWithFormat:@"%@/testDocument.access", [FileManager localDocumentsDirectoryURL]];
    NSURL *fileURL = [NSURL fileURLWithPath:file];
    AccessDocument *testDocument = [[AccessDocument alloc] initWithFileURL:fileURL];
    
    [FileManager saveDocument:testDocument];
    
    STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:file], @"File does not exist");
    
}

@end
