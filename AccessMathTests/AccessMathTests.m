//
//  AccessMathTests.m
//  AccessMathTests
//
//  Created by student on 5/31/13.
//
//

#import "AccessMathTests.h"
#import "ALNetworkInterface.h"

@implementation AccessMathTests {
    __strong ALNetworkInterface *testEchoServer;
}

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    testEchoServer = [[ALNetworkInterface alloc] initWithURL:@"localhost"];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
    
    testEchoServer = nil;
}

/**
 * Tests the socket framwork against and echo server
 */
- (void)testSocketBasic
{
    
    [testEchoServer getFullLecture:@"Some Lecture" completion:^(id lecture) {
        STAssertTrue(FALSE, @"DATA %@", lecture);
    }];
    

}

@end
