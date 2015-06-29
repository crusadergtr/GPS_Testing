//
//  LocationObject.h
//  CoreLocationTest
//
//  Created by Shane Cox on 3/11/12.
//  Copyright (c) 2012 Shane Cox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationObject : NSObject
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *accuracy;
@property (nonatomic, strong) NSDate *date;

-(id)initWithName:(NSString *)locationName latitude:(NSString *)latitude longitude:(NSString *)longitude accuracy:(NSString *)accuracy date:(NSDate *)date;
@end
