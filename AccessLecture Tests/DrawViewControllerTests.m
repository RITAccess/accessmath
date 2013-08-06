//
//  DrawViewControllerTests.m
//  AccessLecture
//
//  Created by Piper Chester on 8/6/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "DrawViewController.h"

@interface DrawViewControllerTests : SenTestCase

@end

@implementation DrawViewControllerTests {
    DrawViewController *testDrawViewController;
}

- (void)setUp
{
    [super setUp];
    testDrawViewController = [DrawViewController new];
    testDrawViewController.drawView = [DrawView new];
    testDrawViewController.drawView.shapes = [NSMutableArray new];
    testDrawViewController.drawView.paths = [NSMutableArray new];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testClearShapesArray
{
    [testDrawViewController.drawView.shapes insertObject:@"TestShape" atIndex:0];
    [testDrawViewController clearNotesButtonPress:nil];
    STAssertTrue(testDrawViewController.drawView.shapes.count == 0, @"Shapes array not being emptied by clear button press.");
}

- (void)testClearPathsArray
{
    [testDrawViewController.drawView.paths insertObject:@"TestPoint" atIndex:0];
    [testDrawViewController clearNotesButtonPress:nil];
    STAssertTrue(testDrawViewController.drawView.paths.count == 0, @"Paths array not being emptied by clear button press.");
}

@end
