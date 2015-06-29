//
//  LocationObjectController.h
//  CoreLocationTest
//
//  Created by Shane Cox on 3/11/12.
//  Copyright (c) 2012 Shane Cox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LocationObject;

@interface LocationObjectController : NSObject
@property (nonatomic, copy) NSMutableArray *masterLocationList;

- (NSUInteger)countOfList;
- (LocationObject *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)removeObjectAtIndex:(NSUInteger)theIndex;
- (void)addLocation:(LocationObject *)location;
- (void)editLocation:(NSUInteger)theIndex:(LocationObject *)location;
- (void) saveToPlist;
@end
