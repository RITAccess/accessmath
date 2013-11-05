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
#import "AMLecture.h"
#import "ImageNote.h"
#import "Position.h"
#import "FileManager.h"

@interface Lectures : SenTestCase

@end

@implementation Lectures
{
    NSString *path;
}

- (void)setUp
{
    [super setUp];
    // Remove any files
    path = [FileManager localDocumentsDirectoryPath];
    char *cpath = malloc(sizeof(char) * 250);
    sprintf(cpath, "%s/testDoc.lec", path.UTF8String);
    unlink(cpath);
    free(cpath);

}

- (void)tearDown
{
    [super tearDown];
}

- (AMLecture *)create
{
    AMLecture *newLec = [FileManager createDocumentWithName:@"testDoc"];
    newLec.metadata.title = @"This is the test title.";
    [newLec save];
    return newLec;
}

- (void)testCreatingUIDocument
{
    AMLecture *newLec = [self create];
    STAssertNotNil(newLec, @"Fail");
}

- (void)testOpeningUIDocument
{
    [self create];
    sleep(1);
    AMLecture *test = [FileManager findDocumentWithName:@"testDoc" failure:^(NSError *error) {
        STFail(@"Did not open lecture. %@", error);
    }];
    
    [test openWithCompletionHandler:^(BOOL success) {
        STAssertEquals(test.metadata.title, @"This is the test title.", @"Wrong lecture opened.");
    }];
}

- (void)testModifyingDocument
{
    [self create];
    sleep(1);
    AMLecture *test = [FileManager findDocumentWithName:@"testDoc" failure:^(NSError *error) {
        STFail(@"Did not open lecture. %@", error);
    }];
    test.metadata.title = @"This is the changed file";
    [test saveWithCompletetion:^(BOOL success) {
        STAssertEquals(test.metadata.title, @"This is the changed file", @"Failed to save");
    }];
}

@end
