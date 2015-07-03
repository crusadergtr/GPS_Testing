//
//  LocationMapViewController.m
//  GPS_test
//
//  Created by JIWEI LIN on 29/06/2015.
//  Copyright (c) 2015 IM. All rights reserved.
//

#import "LocationMapViewController.h"
//#import <GoogleMaps/GoogleMaps.h>
#import "LocationObject.h"
#import "LocationService.h"
#import <MapKit/MapKit.h>


@interface LocationMapViewController ()
@end

@implementation LocationMapViewController {
    BOOL _markerSelected;
    BOOL _detailShown;
    CLLocation *mapCurrentLocation;
    CLLocation *mapSelectedLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LocationService sharedInstance] addObserver:self forKeyPath:@"atLocation" options:NSKeyValueObservingOptionNew context:nil];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[LocationService sharedInstance].currentLocation.coordinate.latitude
                                                            longitude:[LocationService sharedInstance].currentLocation.coordinate.longitude
                                                                 zoom:17];
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;
    [self.view insertSubview:self.mapView belowSubview:self.locationDetailView];
    
    for (NSInteger i = 0; i < [[LocationService sharedInstance] countOfList]; i++) {
        [[LocationService sharedInstance] objectInListAtIndex:i];
        LocationObject *locationAtIndex = [[LocationService sharedInstance] objectInListAtIndex:i];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([locationAtIndex.latitude doubleValue], [locationAtIndex.longitude doubleValue]);
        marker.title = locationAtIndex.locationName;
        marker.map = self.mapView;
        marker.icon = [UIImage imageNamed:@"icon_gps_active"];
        marker.userData = locationAtIndex;
    }
    _markerSelected = NO;

}

- (void) observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    if ([keyPath isEqualToString:@"atLocation"]) {
        //self.selectedLocationLabel.text = [LocationService sharedInstance].atLocation.locationName;
    }
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    LocationObject *obj = marker.userData;
    //self.selectedLocationLabel.text = obj.locationName;
    if (obj == [LocationService sharedInstance].atLocation) {
        NSLog(@"same marker");
        if (_markerSelected == NO) {
            [self open];
            NSLog(@"open info");
            _markerSelected = YES;
        } else if (_markerSelected == YES){
            [self close];
            NSLog(@"close info");
            _markerSelected = NO;
        }
    } else if (obj != [LocationService sharedInstance].atLocation) {
        NSLog(@"not same marker");
        [LocationService sharedInstance].atLocation = obj;
        
        if (_markerSelected == NO) {
            NSLog(@"open info");
            [self open];
            _markerSelected = YES;
        } else if (_markerSelected == YES){
            NSLog(@"change info");
            _markerSelected = YES;
        }
    }
    
    return YES;
}

- (void)open {
            CGRect existingFrame = self.locationDetailView.frame;
    NSLog(@"a= %f",existingFrame.origin.y);
            existingFrame.origin.y = self.locationDetailView.frame.origin.y - 60;
//            [UIView animateWithDuration:0.3 animations:^{
//                self.locationDetailView.frame = existingFrame;
//            }];
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        self.locationDetailView.frame = existingFrame;
        [self.distanceToSelectedLocation setText:@"TEST"];
    } completion:^(BOOL finished){
        //self.selectedLocationLabel.text = @"SSS";
        //[self.distanceToSelectedLocation setText:@"TEST"];
//        mapCurrentLocation = [[CLLocation alloc]initWithLatitude:[LocationService sharedInstance].currentLocation.coordinate.latitude longitude:[LocationService sharedInstance].currentLocation.coordinate.longitude];
//        mapSelectedLocation = [[CLLocation alloc]initWithLatitude: _mapView.selectedMarker.position.latitude longitude:_mapView.selectedMarker.position.longitude];
//        self.distanceToSelectedLocation.text = [NSString stringWithFormat:@"%.0f m", [mapCurrentLocation distanceFromLocation:mapSelectedLocation]];
    }];
}

- (void)close {
    CGRect existingFrame = self.locationDetailView.frame;
     NSLog(@"b= %f",existingFrame.origin.y);
    existingFrame.origin.y = self.locationDetailView.frame.origin.y + 60;
    [UIView animateWithDuration:0.3 animations:^{
        self.locationDetailView.frame = existingFrame;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[LocationService sharedInstance] removeObserver:self forKeyPath:@"atLocation"];
}

- (void)viewWillAppear:(BOOL)animated {
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
