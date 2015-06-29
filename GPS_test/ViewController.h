//
//  ViewController.h
//  GPS_test
//
//  Created by JIWEI LIN on 15/06/2015.
//  Copyright (c) 2015 IM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>
#import <CoreData/CoreData.h>
#import "LocationObjectController.h"

@interface ViewController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *myMap;
@property (strong, nonatomic) LocationObjectController *locationDataController;
@property (strong, nonatomic) LocationObject *location;
@property (strong, nonatomic) IBOutlet UILabel *distance;

@end

