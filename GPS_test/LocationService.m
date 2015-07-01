//
//  LocationService.m
//  GPS_test
//
//  Created by Shane Cox on 1/07/2015.
//  Copyright © 2015 IM. All rights reserved.
//

#import "LocationService.h"

@implementation LocationService

+ (LocationService *) sharedInstance
{
    static LocationService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if(self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //self.locationManager.distanceFilter = 100; // meters
        self.locationManager.delegate = self;
        NSLog(@"Initialise Location");
    }
    return self;
}

- (void)startUpdatingLocation
{
    NSLog(@"Starting location updates");
    [self.locationManager startUpdatingLocation];
}

- (void) stopUpdatingLocation
{
    NSLog(@"Stopping location updates");
    [self.locationManager stopUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Location service failed with error %@", error);
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray*)locations
{
    CLLocation *location = [locations lastObject];
    NSLog(@"Latitude %+.6f, Longitude %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude);
    self.currentLocation = location;
}

@end
