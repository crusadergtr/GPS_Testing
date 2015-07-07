//
//  ViewController.m
//  GPS_test
//
//  Created by JIWEI LIN on 15/06/2015.
//  Copyright (c) 2015 IM. All rights reserved.

// TESTING a PUSH
//

#import "ViewController.h"

#import "LocationObject.h"
#import "LocationListViewController.h"
#import "LocationService.h"
#import <MapKit/MapKit.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (strong, nonatomic) IBOutlet UILabel *Accuracy;
@property (weak, nonatomic) IBOutlet UILabel *address;
- (IBAction)saveLocation:(id)sender;


@end

@implementation ViewController {
}
CLLocation *mainCurrentLocation;
CLLocation *mainMarksLocation;


- (void)viewDidLoad {
    [super viewDidLoad];
    [LocationService sharedInstance];
    [[LocationService sharedInstance] addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    
    
    if ([keyPath isEqualToString:@"currentLocation"]) {
        self.latitude.text = [NSString stringWithFormat:@"%f", [LocationService sharedInstance].currentLocation.coordinate.latitude];
        self.longitude.text = [NSString stringWithFormat:@"%f", [LocationService sharedInstance].currentLocation.coordinate.longitude];
        self.Accuracy.text = [NSString stringWithFormat:@"%.0f m", [LocationService sharedInstance].currentLocation.horizontalAccuracy];
        
        if ([LocationService sharedInstance].atLocation !=nil) {
            [self.locationDetailBtn setSelected:YES];
            [self.saveLocationButton setEnabled:NO];
        } else {
            [self.locationDetailBtn setSelected:NO];
            [self.saveLocationButton setEnabled:YES];
        }
    }
}


#pragma mark CLLocationManagerDelegate Methods
- (void)viewWillDisappear:(BOOL)animated {
    
    NSLog(@"viewController Disappear");
}

- (void)viewWillAppear:(BOOL)animated {
}

- (IBAction)saveLocation:(id)sender {
    LocationObject *savedLocation;
    NSDate *today = [NSDate date];
    
    savedLocation = [[LocationObject alloc] initWithName:[NSString stringWithFormat:@"%@",today] latitude:_latitude.text longitude:_longitude.text accuracy:_Accuracy.text date:today];
    NSLog(@"%@",savedLocation);
    [[LocationService sharedInstance] addLocation:savedLocation];
    [[LocationService sharedInstance] saveToPlist];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowLocations"]) {

    }
}

- (void) dealloc {
    [[LocationService sharedInstance] removeObserver:self forKeyPath:@"currentLocation"];

}
- (IBAction)changeLocationAware:(id)sender {
    if (self.locationAwareSwitch.on == YES) {
        [[LocationService sharedInstance] startUpdatingLocation];

    } else {
        [[LocationService sharedInstance] stopUpdatingLocation];

    }
}
@end
