//
//  LectureContainer.m
//  AccessLecture
//
//  Created by Michael Timbrook on 8/6/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "LectureViewContainer.h"
#import "ZoomBounds.h"

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

- (void)testChildren
{
    
    STAssertTrue(_testLVC.childViewControllers.count == 4, @"Number of children is incorrect, %d returned", _testLVC.childViewControllers.count);
    
    
}


@end
