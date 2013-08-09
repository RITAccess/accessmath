//
//  StreamViewControllerTests.m
//  AccessLecture
//
//  Created by Piper Chester on 8/9/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "StreamViewController.h"

@interface StreamViewController (TestMethods)

- (void)userDidCancel;
- (void)didFailToConnectTo:(NSString *)lecture;
- (void)didFinishRecievingBulkUpdate:(NSArray *)data;
- (void)currentStreamUpdatePercentage:(float)percent;
- (void)willMoveToParentViewController:(UIViewController *)parent;

@end

@interface StreamViewControllerTests : SenTestCase

@end

@implementation StreamViewControllerTests {
    StreamViewController *streamViewController;
}

- (void)setUp
{
    [super setUp];
    streamViewController = [StreamViewController new];
    streamViewController.loadProgress = [UIProgressView new];
    streamViewController.bottomToolbar = [UIToolbar new];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testHideProgressOnUserDidCancel
{
    STAssertNotNil(streamViewController, @"View controller should not be nil.");
    STAssertNotNil(streamViewController.loadProgress, @"ProgressView should not be nil.");
    [streamViewController userDidCancel];
    
    if (!streamViewController.loadProgress.hidden){
        STFail(@"ProgressView should be hidden.");
    }
}

- (void)testHideProgressOnFail
{
    STAssertNotNil(streamViewController, @"View controller should not be nil.");
    STAssertNotNil(streamViewController.loadProgress, @"ProgressView should not be nil.");
    [streamViewController didFailToConnectTo:nil];
    
    if (!streamViewController.loadProgress.hidden){
        STFail(@"ProgressView should be hidden.");
    }
}

- (void)testHideProgessOnBulkUpdateFinish
{
    STAssertNotNil(streamViewController, @"View controller should not be nil.");
    STAssertNotNil(streamViewController.loadProgress, @"ProgressView should not be nil.");
    [streamViewController didFinishRecievingBulkUpdate:nil];
    
    if (!streamViewController.loadProgress.hidden){
        STFail(@"ProgressView should be hidden.");
    }
}

- (void)testStreamUpdatePercent
{
    STAssertNotNil(streamViewController, @"View controller should not be nil.");
    STAssertNotNil(streamViewController.loadProgress, @"ProgressView should not be nil.");
    [streamViewController currentStreamUpdatePercentage:50.0];
    
    STAssertTrue(streamViewController.loadProgress.progress == 50.0 / 100.0, @"Progress should equal 50 / 100.");
}

- (void)testHideBottomToolbarOnWillMoveToParent
{
    STAssertNotNil(streamViewController, @"View controller should not be nil.");
    STAssertNotNil(streamViewController.bottomToolbar, @"Toolbar should not be nil.");
    [streamViewController willMoveToParentViewController:nil];
    
    if (streamViewController.bottomToolbar.hidden){
        STFail(@"Toolbar should not be hidden.");
    }
}


@end
