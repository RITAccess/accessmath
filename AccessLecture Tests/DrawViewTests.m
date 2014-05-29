//
//  DrawViewTests.m
//  AccessLecture
//
//  Created by Piper on 5/29/14.
//
//

#import <XCTest/XCTest.h>
#import "DrawViewController.h"

@interface DrawViewTests : XCTestCase

@end

@implementation DrawViewTests {
    DrawViewController *drawViewController;
}

/**
 *  Called before each test.
 */
- (void)setUp
{
    [super setUp];
    drawViewController = [DrawViewController new];
}

/**
 *  Put teardown code here. This method is called after the invocation of each test method in the class.
 */
- (void)tearDown
{
    [super tearDown];
}

/**
 *  Ensure that the DrawView toolbar is dismissed properly.
 */
- (void)testDrawViewToolbarHide
{
    [drawViewController dismissToolbarWithAnimation:NO];
    XCTAssertTrue(drawViewController.toolbar.hidden = YES, @"Should be hidden.");
}

/**
 *  Ensure DrawView toolbar is displayed.
 */
- (void)testDrawViewToolbarDisplay
{
    [drawViewController displayToolbarWithAnimation:NO];
    XCTAssertTrue(drawViewController.toolbar.hidden = NO, @"Toolbar should be displayed.");
}

@end
