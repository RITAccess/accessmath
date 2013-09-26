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

    AMLecture *newLec = [FileManager createDocumentWithName:@"testDoc"];
    
    
    
}

@end
