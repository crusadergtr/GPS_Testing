//
//  LocationService.h
//  GPS_test
//
//  Created by Shane Cox on 1/07/2015.
//  Copyright © 2015 IM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationObject.h"

@interface LocationService : NSObject <CLLocationManagerDelegate>


+ (LocationService *) sharedInstance;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, copy) NSMutableArray *masterLocationList;

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) LocationObject *atLocation;

-(void)startUpdatingLocation;
-(void)stopUpdatingLocation;

- (NSString *) distanceFormatter : (NSNumber *)distance ;

- (NSUInteger)countOfList;
- (LocationObject *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)removeObjectAtIndex:(NSUInteger)theIndex;
- (void)addLocation:(LocationObject *)location;
- (void)editLocation:(NSUInteger)theIndex:(LocationObject *)location;
- (void) saveToPlist;



@end
