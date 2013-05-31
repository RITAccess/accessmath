//
//  AccessMathTests.m
//  AccessMathTests
//
//  Created by student on 5/31/13.
//
//

#define OFFLINETEST 1

#import "AccessMathTests.h"

@implementation AccessMathTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

#if OFFLINETEST

/**
 * Tests the socket framwork against and echo server
 */
- (void)testSocketBasic
{
    STAssertTrue(true, @"Not true?");
}

#endif

@end
