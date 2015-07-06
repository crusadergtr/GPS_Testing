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

@property (strong, nonatomic) GMSMapView *mapView;

@property (weak, nonatomic) IBOutlet UIView *locationInformationView;
@property (weak, nonatomic) IBOutlet UIButton *locationDetailButton;
@property (weak, nonatomic) IBOutlet UIView *locationDetailView;

@property (weak, nonatomic) IBOutlet UILabel *selectedLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceToSelectedLocation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomconstraint;

@property (weak, nonatomic) IBOutlet UILabel *GPSCoordinates;
@property (weak, nonatomic) IBOutlet UITextField *locationName;

- (IBAction)locationDetailSwipeToOpen:(id)sender;
- (IBAction)locationDetailSwipeToClose:(id)sender;
- (IBAction)showLocationDetailAction:(id)sender;
- (IBAction)hideDetailTapToClose:(id)sender;
@end
