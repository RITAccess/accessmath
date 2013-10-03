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
    NSString *path = [FileManager localDocumentsDirectoryPath];
    char *cpath = malloc(sizeof(char) * 250);
    sprintf(cpath, "%s/testDoc.lec", path.UTF8String);
    unlink(cpath);
    free(cpath);
    AMLecture *newLec = [FileManager createDocumentWithName:@"testDoc" failure:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    sleep(1);
    STAssertNotNil(newLec, @"Fail");
}

- (void)testOpeningUIDocument
{
    
    AMLecture *lecture = [FileManager findDocumentWithName:@"testDoc" failure:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    STAssertNotNil(lecture, @"Fail");
}

@end
