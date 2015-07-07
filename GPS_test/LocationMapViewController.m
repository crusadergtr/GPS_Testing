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
    GMSMarker *atMarker;
    GMSMarker *tappedMarker;
    LocationObject *tappedLocation;
    NSMutableArray *allMarkers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[LocationService sharedInstance].currentLocation.coordinate.latitude
                                                            longitude:[LocationService sharedInstance].currentLocation.coordinate.longitude
                                                                 zoom:17];
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;
    [self.view insertSubview:self.mapView belowSubview:self.locationDetailView];
    
    allMarkers = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < [[LocationService sharedInstance] countOfList]; i++) {
        [[LocationService sharedInstance] objectInListAtIndex:i];
        LocationObject *locationAtIndex = [[LocationService sharedInstance] objectInListAtIndex:i];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([locationAtIndex.latitude doubleValue], [locationAtIndex.longitude doubleValue]);
        marker.icon = [UIImage imageNamed:@"gps_icon_inactive"];
        marker.userData = locationAtIndex;
        marker.map = self.mapView;
        [allMarkers addObject:marker];

    }
    atMarker = [[GMSMarker alloc] init];
    [atMarker setTappable:NO];
    tappedMarker = [[GMSMarker alloc] init];
    
    if ([LocationService sharedInstance].atLocation != nil) {
        [self setActiveMarker];
        tappedMarker = atMarker;
        LocationObject *markerLocation = tappedMarker.userData;
        self.selectedLocationLabel.text = markerLocation.locationName;
        [self showLocationInfo];
    }

}

- (GMSMarker *) findMarker : (LocationObject *) forLocation{
    for (GMSMarker *marker in allMarkers){
        if(marker.position.latitude == [forLocation.latitude doubleValue] && marker.position.longitude == [forLocation.longitude doubleValue]){
            
            return marker;
            
        }
    }
    return nil;
}

- (void) observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    if ([keyPath isEqualToString:@"atLocation"]) {
        [self setActiveMarker];
    } else if ([keyPath isEqualToString:@"currentLocation"]) {
        LocationObject *markerLocation = tappedMarker.userData;
        self.distanceToSelectedLocation.text = [[LocationService sharedInstance] distanceFormatter:markerLocation.distance] ;
    }
}

- (void) setActiveMarker {
    GMSMarker *marker = [self findMarker:[LocationService sharedInstance].atLocation];
    NSLog(@"%@",marker);
    if (marker == nil) {
        if (atMarker == tappedMarker) {
            atMarker.icon = [UIImage imageNamed:@"gps_icon_selected"];
        } else {
            atMarker.icon = [UIImage imageNamed:@"gps_icon_inactive"];
            
        }
        atMarker = nil;
    } else {
        atMarker = marker;
        atMarker.icon = [UIImage imageNamed:@"gps_icon_active"];
    }
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    LocationObject *markerLocation = marker.userData;
    if (marker == tappedMarker) {
        if (marker == atMarker) {
            marker.icon = [UIImage imageNamed:@"gps_icon_active"];
        } else {
            marker.icon = [UIImage imageNamed:@"gps_icon_inactive"];
        }
        
        tappedMarker = nil;
        tappedLocation = nil;
        [self closeLocationInfo];
    } else {
        if (tappedMarker != atMarker) {
            tappedMarker.icon = [UIImage imageNamed:@"gps_icon_inactive"];
        }
        if (marker != atMarker) {
            marker.icon = [UIImage imageNamed:@"gps_icon_selected"];
            
        }
        self.selectedLocationLabel.text = markerLocation.locationName;
        [self showLocationInfo];
        [self addLocationDetail:markerLocation];
        tappedMarker = marker;
        tappedLocation = markerLocation;
        
        
    }
    
    return YES;
}

- (void)showLocationDetail {
    [self.view layoutIfNeeded];
    
    self.bottomconstraint.constant = 0;
    [UIView animateWithDuration:.5
                     animations:^{
                         
                         [self.locationInformationView setAlpha:0];
                         
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
    GMSCameraUpdate *update = [GMSCameraUpdate setTarget:tappedMarker.position];
    [self.mapView moveCamera:update];
    update = [GMSCameraUpdate scrollByX:0 Y:self.mapView.bounds.size.height/4];
    [self.mapView moveCamera:update];
}

- (void) addLocationDetail: (LocationObject *)location{
    NSLog(@"add location detail");
    self.locationName.text = location.locationName;
    self.GPSCoordinates.text = [NSString stringWithFormat:@"(%@, %@)",location.latitude, location.longitude];
}

- (void)showLocationInfo {
    [self.view layoutIfNeeded];
    
    self.bottomconstraint.constant = -340;
    [UIView animateWithDuration:.5
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                         [self.locationInformationView setAlpha:1];
                     }];
}

- (void)closeLocationInfo {
    [self.view layoutIfNeeded];
    
    self.bottomconstraint.constant = -400;
    [UIView animateWithDuration:.5
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[LocationService sharedInstance] removeObserver:self forKeyPath:@"atLocation"];
    [[LocationService sharedInstance] removeObserver:self forKeyPath:@"currentLocation"];
}

- (void)viewWillAppear:(BOOL)animated {
    [[LocationService sharedInstance] addObserver:self forKeyPath:@"atLocation" options:NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionPrior context:nil];
    [[LocationService sharedInstance] addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionPrior context:nil];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [self setActiveMarker];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)locationDetailSwipeToOpen:(id)sender {
    [self showLocationDetail];
}

- (IBAction)locationDetailSwipeToClose:(id)sender {
    [self showLocationInfo];
}

- (IBAction)hideDetailTapToClose:(id)sender {
    [self showLocationInfo];
}

- (IBAction)showLocationDetailAction:(id)sender {
    if (self.bottomconstraint.constant == -340) {
        [self showLocationDetail];
    } else if (self.bottomconstraint.constant == 0) {
        [self showLocationInfo];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.selectedLocationLabel.text = self.locationName.text;
    [[LocationService sharedInstance] saveToPlist];
    tappedLocation.locationName = self.locationName.text;
    return NO;
}



@end
