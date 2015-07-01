//
//  ViewController.m
//  GPS_test
//
//  Created by JIWEI LIN on 15/06/2015.
//  Copyright (c) 2015 IM. All rights reserved.
//

#import "ViewController.h"
//#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

#import "LocationObject.h"
#import "LocationObjectController.h"
#import "LocationListViewController.h"
#import "LocationService.h"

@interface ViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (strong, nonatomic) IBOutlet UILabel *Accuracy;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UIView *GoogleMap;
- (IBAction)saveLocation:(id)sender;


@end

@implementation ViewController {
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    GMSMapView *mapView_;
//    CLLocation *currentlocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [LocationService sharedInstance];
    [[LocationService sharedInstance] addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
    //[[LocationService sharedInstance] startUpdatingLocation];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.myMap.delegate = self;
    [self.myMap setShowsUserLocation:YES];
  //  [manager requestWhenInUseAuthorization];
    

    // Google MAP
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.886376
                                                            longitude:151.229407
                                                                 zoom:10];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 450, 375, 200) camera:camera];
    mapView_.myLocationEnabled = YES;
    [self.view addSubview:mapView_];
    NSLog(@"User's location: %@", mapView_.myLocation);
//    mapView_.settings.myLocationButton = YES;
    
    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(-33.886376, 151.229407);
//    marker.title = @"Sydney";
//    marker.snippet = @"Australia";
//    marker.map = mapView_;
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (IBAction)switchBt:(UIButton *)sender {
//    if ([self.mapSwitch isOn]) {
//        self.switchLabel.text = @"Switch is off";
//        [self.mapSwitch setOn:NO animated:YES];
//    } else {
//        self.switchLabel.text = @"Switch is on";
//        [self.mapSwitch setOn:YES animated:YES];
//    }
//}

- (void) observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    if ([keyPath isEqualToString:@"currentLocation"]) {
        self.latitude.text = [NSString stringWithFormat:@"%f", [LocationService sharedInstance].currentLocation.coordinate.latitude];
        self.longitude.text = [NSString stringWithFormat:@"%f", [LocationService sharedInstance].currentLocation.coordinate.longitude];
        self.Accuracy.text = [NSString stringWithFormat:@"%.0f m", [LocationService sharedInstance].currentLocation.horizontalAccuracy];
    }
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocationCoordinate2D myLocation = [userLocation coordinate];
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(myLocation, 100, 100);
    [self.myMap setRegion:zoomRegion animated:NO];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
}

#pragma mark CLLocationManagerDelegate Methods


- (void)viewWillDisappear:(BOOL)animated {
//    [manager stopUpdatingLocation];
    [[LocationService sharedInstance] stopUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
//    [manager startUpdatingLocation];
    [[LocationService sharedInstance] startUpdatingLocation];
}

- (IBAction)saveLocation:(id)sender {
    LocationObject *savedLocation;
    NSDate *today = [NSDate date];
    
    savedLocation = [[LocationObject alloc] initWithName:[NSString stringWithFormat:@"%@",today] latitude:_latitude.text longitude:_longitude.text accuracy:_Accuracy.text date:today];
    NSLog(@"%@",savedLocation);
    [self.locationDataController addLocation:savedLocation];
    [self.locationDataController saveToPlist];
    
//    CLLocation* location1 =
//    [[CLLocation alloc]
//     initWithLatitude: -33.884611
//     longitude: 151.226586];
//    CLLocation* location2 =
//    [[CLLocation alloc]
//     initWithLatitude: -33.886207
//     longitude: 151.228953];
//    
//    self.distance.text = [NSString stringWithFormat:@"%.0f m", [location1 distanceFromLocation:location2]];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowLocations"]) {
        LocationListViewController *ListViewController = [segue destinationViewController];
        
        ListViewController.locationDataController = self.locationDataController;
    }
}
@end
