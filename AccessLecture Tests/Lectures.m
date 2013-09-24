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

    NSString *file = [NSString stringWithFormat:@"%@/testDocument.access", [FileManager localDocumentsDirectoryURL]];
    NSURL *fileURL = [NSURL fileURLWithPath:file];
    
    AMLecture *testDoc = [[AMLecture alloc] initWithFileURL:fileURL];
    
    [testDoc openWithCompletionHandler:^(BOOL success) {
        NSLog(@"Loaded");
        [testDoc saveToURL:testDoc.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            NSLog(@"Saved");
            [testDoc closeWithCompletionHandler:^(BOOL success) {
                NSLog(@"Closed");
            }];
        }];
    }];
    
}

@end
