//
//  LectureContainer.m
//  AccessLecture
//
//  Created by Michael Timbrook on 8/6/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "LectureViewContainer.h"
#import "DrawViewController.h"
#import "ZoomBounds.h"

@interface LectureViewContainer ()

// Zoom pan test
@property (nonatomic) CGPoint center;
@property (nonatomic) CGSize space;
@property (nonatomic) CGAffineTransform zoomLevel;
@property (nonatomic) BOOL finish;

- (void)applyTransforms;

@end

@interface LectureContainer : SenTestCase

@property LectureViewContainer *testLVC;

@end

@implementation LectureContainer

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _testLVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:LectureViewContainerSBID];
    [_testLVC viewDidLoad];
    [_testLVC viewDidAppear:NO];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class. 
    [super tearDown];
    _testLVC = nil;
}

- (void)testChildrenCount
{
    // Number of child view controllers should be 4
    STAssertTrue(_testLVC.childViewControllers.count == 4, @"Number of children is incorrect, %d returned", _testLVC.childViewControllers.count);
}

- (void)testVectors
{
    Vector vector = VectorMake(CGPointZero, CGPointMake(cos(1), sin(1)));
    VectorApplyScale(2, &vector);
    STAssertTrue(CGPointEqualToPoint(CGPointMake(2*cos(1), 2*sin(1)), vector.end), @"Points not equal");
}

- (void)testTransformsWithoutLimitBounce
{
    _testLVC.center = CGPointMake(500, 500);
    _testLVC.finish = NO;
    [_testLVC applyTransforms];
    CGPoint testCenter = [(id<LectureViewChild>)[_testLVC.childViewControllers objectAtIndex:rand() % _testLVC.childViewControllers.count] contentView].center;
    STAssertEquals(testCenter, CGPointMake(500, 500), @"View not transformed correctly");
}

@end
