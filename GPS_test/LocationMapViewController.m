//
//  LocationMapViewController.m
//  GPS_test
//
//  Created by JIWEI LIN on 29/06/2015.
//  Copyright (c) 2015 IM. All rights reserved.
//

#import "LocationMapViewController.h"
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "LocationObject.h"



@interface LocationMapViewController ()

@end

@implementation LocationMapViewController
    GMSMapView *mapView;
    CLLocationManager *manager_;


- (LocationObjectController *)locationDataController{
    if (!_locationDataController) _locationDataController = [[LocationObjectController alloc] init];
    return _locationDataController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    manager_ = [[CLLocationManager alloc] init];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.886376
                                                            longitude:151.229407
                                                                 zoom:14];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) camera:camera];
    mapView.myLocationEnabled = YES;
//    [self.view addSubview:mapView];
    [self.view insertSubview:mapView belowSubview:self.locationInformation];
    
    //    manager_.delegate = self;
    manager_.desiredAccuracy = kCLLocationAccuracyBest;
    [manager_ startUpdatingLocation];
//    NSLog(@"tt: %lu",(unsigned long)[self.locationDataController countOfList]);
    
    for (NSInteger i = 0; i < [self.locationDataController countOfList]; i++) {
        [self.locationDataController objectInListAtIndex:i];
        LocationObject *locationAtIndex = [self.locationDataController objectInListAtIndex:i];
        NSLog(@"%@",locationAtIndex.longitude);
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([locationAtIndex.latitude doubleValue], [locationAtIndex.longitude doubleValue]);
        marker.title = locationAtIndex.locationName;
        marker.map = mapView;
    }

}



-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [manager_ stopUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [manager_ startUpdatingLocation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)markMaker{
    
}

- (IBAction)showDetailInformation:(id)sender {
    if(self.locationInformation.frame.origin.y == 587) {
            [UIView animateWithDuration:0.2f animations:^{
                self.locationInformation.frame = CGRectMake(0,367, 375, 300);
            }];
    } else if (self.locationInformation.frame.origin.y == 367) {
        [UIView animateWithDuration:0.2f animations:^{
            self.locationInformation.frame = CGRectMake(0,587, 375, 300);
        }];
    }
}
@end
