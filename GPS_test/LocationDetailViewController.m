//
//  LocationDetailViewController.m
//  CoreLocationTest
//
//  Created by Shane Cox on 3/11/12.
//  Copyright (c) 2012 Shane Cox. All rights reserved.
//

#import "LocationDetailViewController.h"
#import "LocationObject.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface LocationDetailViewController ()
- (void)configureView;
- (void)distanceCalculation;


@end

@implementation LocationDetailViewController
    CLLocationManager *manager;
    GMSMapView *mapView_;

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.locationNameLabel)  {
        self.saveButton.enabled = YES;
        [textField resignFirstResponder];
    }
    return YES;
}


- (void)setLocation:(LocationObject *) newLocation
{
    if (_location != newLocation) {
        _location = newLocation;
        
        // Update the view.
        [self configureView];
    }}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    self.saveButton.enabled = NO;
    LocationObject *theLocation = self.location;
    
    manager = [[CLLocationManager alloc] init];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.886376
                                                            longitude:151.229407
                                                                 zoom:10];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 242, 375, 300) camera:camera];
    mapView_.myLocationEnabled = YES;
    [self.view addSubview:mapView_];
    
//    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([theLocation.latitude doubleValue], [theLocation.longitude doubleValue]);
    marker.title = theLocation.locationName;
    marker.map = mapView_;
}

- (void)configureView
{
    // Update the user interface for the detail item.
    LocationObject *theLocation = self.location;
    
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    if (theLocation) {
        self.locationNameLabel.text = theLocation.locationName;
        self.latitudeLabel.text = theLocation.latitude;
        self.longitudeLabel.text = theLocation.longitude;
//        self.distanceLabel.text;
        self.accuracyLabel.text = [NSString stringWithFormat:@"%.0f m", [theLocation.accuracy doubleValue]];
        
        CLLocationCoordinate2D locationCoords;
        locationCoords.latitude = [theLocation.latitude doubleValue];
        locationCoords.longitude = [theLocation.longitude doubleValue];
        

//        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(locationCoords, 2000, 2000);
//        [self.locationMapView setRegion:region];
//        
//        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//        point.coordinate = locationCoords;
//        [self.locationMapView addAnnotation:point];
    }
}

- (void)distanceCalulation{
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"Location: %@", newLocation);
    CLLocation *currentlocation = newLocation;
    
    LocationObject *theLocation = self.location;
    
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    if (theLocation) {
        CLLocation* location1 = [[CLLocation alloc] initWithLatitude:[theLocation.latitude doubleValue] longitude:[theLocation.longitude doubleValue]];
        CLLocation* location2 = [[CLLocation alloc] initWithLatitude:currentlocation.coordinate.latitude longitude:currentlocation.coordinate.longitude];
        self.distanceLabel.text = [NSString stringWithFormat:@"%.0f m", [location1 distanceFromLocation:location2]];
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                            longitude:newLocation.coordinate.longitude
                                                                 zoom:17];
    [mapView_ animateToCameraPosition:camera];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLocationNameLabel:nil];
    [self setLatitudeLabel:nil];
    [self setLongitudeLabel:nil];
    [self setAccuracyLabel:nil];
    [self setDistanceLabel:nil];
//    [self setLocationMapView:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [manager stopUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [manager startUpdatingLocation];
}

@end
