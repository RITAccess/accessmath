//
//  Networking.m
//  AccessLecture
//
//  Created by Michael Timbrook on 6/12/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "ALNetworkInterface.h"

#define TESTSERVER @"129.21.113.151"

@interface Networking : SenTestCase <SocketIODelegate>

@end

@implementation Networking {
    ALNetworkInterface *server;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    server = [[ALNetworkInterface alloc] init];
    [server setConnectionURL:TESTSERVER];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testConnectingToServer1
{
    [server connectCompletion:^(BOOL success) {
        if (success) {
            STAssertTrue(server.connected, @"Did not connect to server");
        } else {
            STFail(@"Server did not respond");
        }
    }];
}

//- (void)testConnectingToServer2
//{
//    [server connect];
//    while (server.isConnecting)
//        ;
//    STAssertTrue(server.connected, @"Did not connect to server");
//}
//
//- (void)testConnectingToServer3
//{
//    ALNetworkInterface *test = [[ALNetworkInterface alloc] initWithURL:TESTSERVER];
//    [test connectCompletion:^(BOOL success) {
//        if (success) {
//            STAssertTrue(server.connected, @"Did not connect to server");
//        } else {
//            STFail(@"Server did not respond");
//        }
//    }];
//}
//
//- (void)testConnectingToServer4
//{
//    SocketIO *newSocket = [[SocketIO alloc] initWithDelegate:self];
//    [newSocket connectToHost:TESTSERVER onPort:9000];
//    while (newSocket.isConnecting)
//        ;
//    STAssertTrue(newSocket.isConnected, @"Failed to connect to server");
//}

@end














