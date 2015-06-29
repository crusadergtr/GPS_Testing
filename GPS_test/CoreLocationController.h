//
//  CoreLocationController.h
//  CoreLocationTest
//
//  Created by Shane Cox on 30/10/12.
//  Copyright (c) 2012 Shane Cox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CoreLocationControllerDelegate
@required
- (void)locationUpdate:(CLLocation *)location; // Our location updates are sent here
- (void)locationError:(NSError *)error; // Any errors are sent here
@end

@interface CoreLocationController : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locMgr;
	id delegate;
}

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic) id delegate;

@end
