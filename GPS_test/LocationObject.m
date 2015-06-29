//
//  LocationObject.m
//  CoreLocationTest
//
//  Created by Shane Cox on 3/11/12.
//  Copyright (c) 2012 Shane Cox. All rights reserved.
//

#import "LocationObject.h"

@implementation LocationObject

-(id)initWithName:(NSString *)locationName latitude:(NSString *)latitude longitude:(NSString *)longitude accuracy:(NSString *)accuracy date:(NSDate *)date{
    self = [super init];
    if (self) {
        _locationName = locationName;
        _latitude = latitude;
        _longitude = longitude;
        _accuracy = accuracy;
        _date = date;
        return self;
    }
    return nil;
}
@end
