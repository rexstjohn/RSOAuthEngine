//
//  YelpDemoTests.m
//  YelpDemoTests
//
//  Created by Rex St. John on 12/16/13.
//  Copyright (c) 2013 SharpCube. All rights reserved.
//

#import <XCTest/XCTest.h> 
#import "UXRYelpNetworkingEngine.h"
#import "UXRAsyncTesting.h"

@interface UXRYelpTests : XCTestCase
@property(nonatomic,strong) UXRYelpNetworkingEngine *yelpEngine;
@end

@implementation UXRYelpTests

- (void)setUp
{
    [super setUp];
    self.yelpEngine = [[UXRYelpNetworkingEngine alloc] init];
    
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testOAUTH
{
    StartBlock();
    
    __block BOOL done = NO;
    
    [self.yelpEngine getRestaurantsWithCompletionBlock:^(NSArray *restaurants) {
        XCTAssert(restaurants.count != 0, @"Results should not be empty");
        done = YES;
    } failureBlock:^(NSError *error) {
        XCTAssertNil(error, @"Error should be nil");
        done = YES;
    }];
    
    WaitWhile(done == NO);
    
}

@end