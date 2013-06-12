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

@interface Networking : SenTestCase

@end

@implementation Networking {
    AccessLectureAppDelegate *app;
    ALNetworkInterface *server;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    app = [[UIApplication sharedApplication] delegate];
    server = app.server;
    [server setConnectionURL:TESTSERVER];
    [server connect];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testConnected
{
    STAssertTrue(server.conneted, @"Did not connect to server");
}

@end
