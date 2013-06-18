//
//  Lectures.m
//  AccessLecture
//
//  Created by Michael Timbrook on 6/12/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "Lecture.h"

@interface Lectures : SenTestCase

@end

@implementation Lectures {
    Lecture *testLecture;
    NSDate *startDate;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    testLecture = [[Lecture alloc] init];
    testLecture.name = @"Test Name";
    startDate = [NSDate date];
    testLecture.date = startDate;
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testCreateLectureWithName
{
    Lecture *lect = [[Lecture alloc] initWithName:@"Test Name"];
    STAssertTrue([lect.date timeIntervalSinceDate:startDate] < 60, @"Time is to far off.");
}

- (void)testCreateLectureWithCoder
{
    STFail(@"Not implemented in tests yet.");
}

- (void)testCreateLectureWithPacket1
{
    SocketIOPacket *packet = [[SocketIOPacket alloc] init];
    double time = [startDate timeIntervalSince1970];
    [packet setData:[NSString stringWithFormat:@"{\"name\":\"lecture-response\",\"args\":[{\"name\":\"class\",\"_id\":\"51b8c1973987508356000001\",\"data\":[\"Test Data\",\"More Test Data\"],\"date\":%f}]}", time]];
     Lecture *lect = [[Lecture alloc] initWithPacket:packet];
     STAssertEqualsWithAccuracy(lect.date.timeIntervalSince1970, startDate.timeIntervalSince1970, 100, @"Lecture not made correctly");
}

- (void)testCreateLectureWithPacket2
{
    SocketIOPacket *packet = [[SocketIOPacket alloc] init];
    double time = [startDate timeIntervalSince1970];
    [packet setData:[NSString stringWithFormat:@"{\"name\":\"lecture-response\",\"args\":[{\"name\":\"class\",\"_id\":\"51b8c1973987508356000001\",\"data\":[\"Test Data\",\"More Test Data\"],\"date\":%f}]}", time]];
    Lecture *lect = [[Lecture alloc] initWithPacket:packet];
    STAssertTrue([lect.name isEqualToString:@"class"], @"Lecture not made correctly");
}

@end
