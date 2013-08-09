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

@end
