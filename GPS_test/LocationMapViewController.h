//
//  LocationMapViewController.h
//  GPS_test
//
//  Created by Shane Cox on 1/07/2015.
//  Copyright © 2015 IM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface LocationMapViewController : UIViewController <GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *locationDetailButton;
@property (weak, nonatomic) IBOutlet UIView *locationDetailView;
@property (strong, nonatomic) GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *selectedLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceToSelectedLocation;

@end
