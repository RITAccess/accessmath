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
    testDrawViewController.drawView.tapStamp = [UITapGestureRecognizer new];
    testDrawViewController.drawView.fingerDrag = [UIPanGestureRecognizer new];
    testDrawViewController.drawView.buttonString = [NSMutableString new];
    testDrawViewController.buttonStrings = [[NSMutableArray alloc] initWithObjects:@"star.png", @"arrow.png", @"undo.png", @"circle.png", nil];;
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

- (void)testPenSizeChange
{
    [testDrawViewController penSizeSlide:nil];
    STAssertEquals(testDrawViewController.drawView.penSize, testDrawViewController.penSizeSlider.value, @"Slider does not equal pen size value.");
}

- (void)testRemoveLastObjectFromUndoButtonPress
{
    [testDrawViewController.drawView.shapes insertObject:@"TestShape" atIndex:0];
    NSString *testObject = testDrawViewController.drawView.shapes.lastObject;
    STAssertEqualObjects(@"TestShape", testObject, @"Objects don't match.");
    [testDrawViewController undoButtonPress:nil];
    STAssertTrue(![testDrawViewController.drawView.shapes containsObject:testObject], @"Object was not removed.");
}

- (void)testButtonStringAssign
{
    [testDrawViewController shapeButtonPress:nil];
    STAssertTrue([testDrawViewController.drawView.buttonString isEqualToString:[testDrawViewController.buttonStrings objectAtIndex:testDrawViewController.shapeButtonIndex]], @"Button strings are not being assigned correctly.");
}

- (void)testTapGestureEnableFromShapeButtonPress
{
    [testDrawViewController shapeButtonPress:nil];
    STAssertTrue(testDrawViewController.drawView.tapStamp.enabled == YES, @"Tap gesture is not enabled.");
}

- (void)testPanGestureDisableFromShapeButtonPress
{
    [testDrawViewController shapeButtonPress:nil];
    STAssertTrue(testDrawViewController.drawView.fingerDrag.enabled == NO, @"Swipe gesture is still enabled.");
}

- (void)testDisableTapStampFromSegmentSelect
{
    [testDrawViewController segmentChanged:nil];
    STAssertTrue(testDrawViewController.drawView.tapStamp.enabled == NO, @"Tap gesture is still enabled.");
}

- (void)testPanGestureEnableFromSegmentSelect
{
    [testDrawViewController segmentChanged:nil];
    STAssertTrue(testDrawViewController.drawView.fingerDrag.enabled == YES, @"Pan gesture is not enabled.");
}

@end
