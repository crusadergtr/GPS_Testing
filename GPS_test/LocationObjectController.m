//
//  LocationObjectController.m
//  CoreLocationTest
//
//  Created by Shane Cox on 3/11/12.
//  Copyright (c) 2012 Shane Cox. All rights reserved.
//

#import "LocationObjectController.h"
#import "LocationObject.h"

@interface LocationObjectController ()
- (void)initializeDefaultDataList;

- (void)initializeFromPlist;
@end

@implementation LocationObjectController

- (id)init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        [self initializeFromPlist];
        return self;
    }
    return nil;
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
