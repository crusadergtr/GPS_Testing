//
//  LocationMapViewController.h
//  GPS_test
//
//  Created by JIWEI LIN on 29/06/2015.
//  Copyright (c) 2015 IM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "LocationObjectController.h"

@class LocationObjectController;


@interface LocationMapViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *locationInformation;
@property (strong, nonatomic) LocationObjectController *locationDataController;
- (IBAction)showDetailInformation:(id)sender;


@end
