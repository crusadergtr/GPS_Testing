//
//  LocationService.m
//  GPS_test
//
//  Created by Shane Cox on 1/07/2015.
//  Copyright © 2015 IM. All rights reserved.
//

#import "LocationService.h"

@interface LocationService ()
    - (void)initializeDefaultDataList;
    - (void)initializeFromPlist;
@end

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
        
        [self initializeDefaultDataList];
        [self initializeFromPlist];
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

- (void)setMasterLocationList:(NSMutableArray *)masterLocationList {
    if (_masterLocationList != masterLocationList) {
        _masterLocationList = [masterLocationList mutableCopy];
    }
}

- (void)initializeDefaultDataList {
    NSMutableArray *locationList = [[NSMutableArray alloc] init];
    self.masterLocationList = locationList;
    LocationObject *location;
    NSDate *today = [NSDate date];
    location = [[LocationObject alloc] initWithName:@"Default Location" latitude:@"-33.916484" longitude:@"151.251277" accuracy:@"10" date:today];
    [self addLocation:location];
}

-(void)initializeFromPlist{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectoryPath
                           stringByAppendingPathComponent:@"savedLocations.plist"];
    
    NSMutableArray* savedLocations = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    NSDictionary *locationItem;
    LocationObject *location;
    
    for (int n = 0; n< [savedLocations count]; n= n + 1) {
        locationItem = [savedLocations objectAtIndex:n];
        location = [[LocationObject alloc]
                    initWithName:[locationItem objectForKey:@"locationName"]
                    latitude:[locationItem objectForKey:@"latitude"]
                    longitude:[locationItem objectForKey:@"longitude"]
                    accuracy:[locationItem objectForKey:@"accuracy"]
                    date:[locationItem objectForKey:@"date"]];
        [self addLocation:location];
    }
}

- (void) saveToPlist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectoryPath
                           stringByAppendingPathComponent:@"savedLocations.plist"];
    NSMutableArray *savedLocations = [[NSMutableArray alloc]init];
    LocationObject *location;
    
    for (int n = 1; n< [self countOfList]; n= n + 1) {
        location = [self objectInListAtIndex:n];
        NSDictionary *locationItem = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      location.locationName,@"locationName",
                                      location.latitude,@"latitude",
                                      location.longitude,@"longitude",
                                      location.accuracy, @"accuracy",
                                      location.date, @"date",nil];
        [savedLocations addObject:locationItem];
        
    }
    [savedLocations writeToFile:plistPath atomically:NO];
    
}

- (NSUInteger)countOfList {
    return [self.masterLocationList count];
}

- (LocationObject *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.masterLocationList objectAtIndex:theIndex];
}

- (void)removeObjectAtIndex:(NSUInteger)theIndex {
    return [self.masterLocationList removeObjectAtIndex:theIndex];
}

- (void)editLocation:(NSUInteger)theIndex:(LocationObject *)location{
    [self.masterLocationList replaceObjectAtIndex:theIndex withObject:location];
}

- (void)addLocation:(LocationObject *)location{
    [self.masterLocationList addObject:location];
}


@end
