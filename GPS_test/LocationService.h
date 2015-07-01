//
//  LocationService.h
//  GPS_test
//
//  Created by Shane Cox on 1/07/2015.
//  Copyright © 2015 IM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationService : NSObject <CLLocationManagerDelegate>


+ (LocationService *) sharedInstance;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

-(void)startUpdatingLocation;
-(void)stopUpdatingLocation;

@end
