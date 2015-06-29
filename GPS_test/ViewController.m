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

@interface ViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (strong, nonatomic) IBOutlet UILabel *Accuracy;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UIView *GoogleMap;
- (IBAction)saveLocation:(id)sender;


@end

@implementation ViewController {
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    GMSMapView *mapView_;
//    CLLocation *currentlocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    self.myMap.delegate = self;
    [self.myMap setShowsUserLocation:YES];
    [manager requestWhenInUseAuthorization];
    
    manager.delegate = self;
//    manager.distanceFilter = 10;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [manager startUpdatingLocation];

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
    

    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Setting", nil];
        [alert show];
    }
    
    self.locationDataController = [[LocationObjectController alloc] init];
    
    NSLog(@"view Loaded");
    
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

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
    NSLog(@"Fail to get location : (");
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"Location: %@", newLocation);
    CLLocation *currentlocation = newLocation;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                            longitude:newLocation.coordinate.longitude
                                                                 zoom:17];
    [mapView_ animateToCameraPosition:camera];
    
    if (currentlocation != nil) {
        self.latitude.text = [NSString stringWithFormat:@"%f", currentlocation.coordinate.latitude];
        self.longitude.text = [NSString stringWithFormat:@"%f", currentlocation.coordinate.longitude];
        self.Accuracy.text = [NSString stringWithFormat:@"%.0f m", currentlocation.horizontalAccuracy];
        
    }
    
//    [geocoder reverseGeocodeLocation:currentlocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (error == nil && [placemarks count] > 0) {
//            placemark =[placemarks lastObject];
//            
//            self.address.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
//                                 placemark.subThoroughfare, placemark.thoroughfare,
//                                 placemark.postalCode, placemark.locality,
//                                 placemark.administrativeArea,
//                                 placemark.country];
//        } else {
//            NSLog(@"%@", error.debugDescription);
//        }
//    }];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [manager stopUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [manager startUpdatingLocation];
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
