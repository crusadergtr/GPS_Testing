//
//  GPS_testTests.m
//  GPS_testTests
//
//  Created by JIWEI LIN on 15/06/2015.
//  Copyright (c) 2015 IM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "LocationService.h"

@interface GPS_testTests : XCTestCase

@property (nonatomic) LocationObject *testLocationObject;
@property (nonatomic) LocationService *testLocationService;
//@property (nonatomic) LocationMapViewController *testLocationmapViewController;

@end

@implementation GPS_testTests


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.testLocationObject = [[LocationObject alloc] init];
    self.testLocationService = [[LocationService alloc] init];
//    self.testLocationmapViewController = [[LocationMapViewController alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSaveToList {
    NSDate *today = [NSDate date];
    LocationObject *testSaveLocation;
    CLLocation *testFoundLocation;
    CLLocation *testMockLocation;

    testMockLocation = [[CLLocation alloc]initWithLatitude:-33.886485 longitude:151.2292716];
    
    testSaveLocation = [[LocationObject alloc] initWithName:[NSString stringWithFormat:@"%@", today] latitude:[NSString stringWithFormat:@"-33.886485"] longitude:[NSString stringWithFormat:@"151.2292716"] accuracy:[NSString stringWithFormat:@"10"] date:today];
    
    NSLog(@"\nmockup location latitude:  %@ \nmockup location longitude: %@", testSaveLocation.latitude, testSaveLocation.longitude);
    [[LocationService sharedInstance] addLocation:testSaveLocation];
    [[LocationService sharedInstance] saveToPlist];
    
    for (NSInteger i = 0; i < [[LocationService sharedInstance] countOfList]; i++) {
        [[LocationService sharedInstance] objectInListAtIndex:i];
        LocationObject *locationAtIndex = [[LocationService sharedInstance] objectInListAtIndex:i];

        NSLog(@"\nLocation NO.%ld \nList Location latitude:  %@ \nlList Location longitude: %@", i, locationAtIndex.latitude, locationAtIndex.longitude);
        if ([locationAtIndex.latitude doubleValue] == testMockLocation.coordinate.latitude && [locationAtIndex.longitude doubleValue] == testMockLocation.coordinate.longitude) {
                testFoundLocation = [[CLLocation alloc] initWithLatitude:[locationAtIndex.latitude doubleValue] longitude:[locationAtIndex.longitude doubleValue]];
                NSLog(@"\nFound location at: ---%ld--- \nFound location latitude:  %f \nFound location longitude: %f", i, testFoundLocation.coordinate.latitude, testFoundLocation.coordinate.longitude);
                break;
        }
    }
//    XCTAssertEqualObjects(testCurrentLocation, testFoundLocation, @"The save founction didn't work very well");
//    XCTAssertEqual(testCurrentLocation.coordinate.latitude, testFoundLocation.coordinate.latitude, @"The save founction didn't work very well - latitude");
//    XCTAssertEqual(testCurrentLocation.coordinate.longitude, testFoundLocation.coordinate.longitude, @"The save founction didn't work very well - longitude");
    XCTAssertEqual(-33.886485, testFoundLocation.coordinate.latitude, @"The save founction tests fail - latitude");
    XCTAssertEqual(151.2292716, testFoundLocation.coordinate.longitude, @"The save founction tests fail - longitude");
}

- (void)testAtLocation {

    CLLocation *testCurrentLocation = [[CLLocation alloc] initWithLatitude:-33.886485 longitude:151.2292716];
    for (NSInteger i = 0; i < [[LocationService sharedInstance] countOfList]; i++) {
        [[LocationService sharedInstance] objectInListAtIndex:i];
        LocationObject *locationAtIndex = [[LocationService sharedInstance] objectInListAtIndex:i];
        CLLocation *testMockLocation = [[CLLocation alloc] initWithLatitude:[locationAtIndex.latitude doubleValue] longitude:[locationAtIndex.longitude doubleValue]];
        
        if ([testCurrentLocation distanceFromLocation:testMockLocation] <= 10) {
            [LocationService sharedInstance].atLocation = locationAtIndex;
            XCTAssertNotNil([LocationService sharedInstance].atLocation, @"At location founction tests fail");
            NSLog(@"\n---at location distance: %f--- \nlatitude:  %@ \nlongitude: %@", [testCurrentLocation distanceFromLocation:testMockLocation],[LocationService sharedInstance].atLocation.latitude, [LocationService sharedInstance].atLocation.longitude);
            [LocationService sharedInstance].atLocation = nil;
        } else {
            NSLog(@"distance: %f", [testCurrentLocation distanceFromLocation:testMockLocation]);
            NSLog(@"Not at location");
            XCTAssertNil([LocationService sharedInstance].atLocation, @"At location founction tests fail");
        }
    }

}

- (void)testReadLocationList {
    for (NSInteger i = 0; i < [[LocationService sharedInstance] countOfList]; i++) {
//        NSLog(@"test list property: %ld", (long)i);
//        [[LocationService sharedInstance] objectInListAtIndex:i];
//        LocationObject *locationAtIndex = [[LocationService sharedInstance] objectInListAtIndex:i];
//        NSLog(@"\nlatitude:  %@ \nlongitude: %@", locationAtIndex.latitude, locationAtIndex.longitude);
    }
}



@end
