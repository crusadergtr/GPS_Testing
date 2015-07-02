//
//  LocationDetailViewController.h
//  CoreLocationTest
//
//  Created by Shane Cox on 3/11/12.
//  Copyright (c) 2012 Shane Cox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class LocationObject;

@interface LocationDetailViewController : UITableViewController <MKMapViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *locationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;

@property (strong, nonatomic) LocationObject *location;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
