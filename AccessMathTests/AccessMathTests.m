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
    testEchoServer = [[ALNetworkInterface alloc] initWithURL:@"ws://echo.websocket.org"];
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
    
    [testEchoServer sendData:@"Test String"];
    
    [testEchoServer onMessageBlock:^(NSString *response) {
        STAssertEquals(@"Test String", response, @"Echo Failed");
    }];
    
    [testEchoServer sendData:@"Test String"];
    
    [testEchoServer onMessageBlock:^(NSString *response) {
        STAssertFalse([@"" isEqualToString:response], @"Echo Failed");
    }];
    

}

@end
