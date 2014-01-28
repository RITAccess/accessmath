//
//  AccessLecture_XCTests.m
//  AccessLecture XCTests
//
//  Created by Michael on 1/28/14.
//
//

#import <XCTest/XCTest.h>
#import "ImageNoteViewController.h"

@interface AccessLecture_XCTests : XCTestCase

@property (retain, atomic) ImageNoteViewController *controller;

@end

@interface ImageNoteViewController ()

- (void)makeRequest;
- (NSURLRequest *)requestWithImage:(UIImage *)image;

@end

@implementation AccessLecture_XCTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _controller = [ImageNoteViewController new];
}

- (void)tearDown
{
    _controller = Nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testImageReqest
{
    UIImage *img = [UIImage imageNamed:@"Icon"];
    NSURLRequest *request = [_controller requestWithImage:img];
    XCTAssertNotNil(request, @"Request not created");
}

- (void)testMakingRequest
{
    XCTAssertNoThrow([_controller makeRequest], @"Failed");
}

@end
