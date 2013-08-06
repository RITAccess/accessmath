//
//  DrawViewTests.m
//  AccessLecture
//
//  Created by Piper Chester on 8/6/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "DrawView.h"

@interface DrawViewTests : SenTestCase

@end

@implementation DrawViewTests {
    DrawView *testDrawView;
}

- (void)setUp
{
    [super setUp];
    testDrawView = [DrawView new];
    testDrawView.shapes = [NSMutableArray new];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testAddStampToShapeArray
{
    [testDrawView tapToStamp:[UITapGestureRecognizer new]];
    STAssertEquals((int)testDrawView.shapes.count, 1, @"Shape not being inserted into the array.");
}

@end
