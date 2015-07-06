//
//  LocationListViewController.m
//  CoreLocationTest
//
//  Created by Shane Cox on 3/11/12.
//  Copyright (c) 2012 Shane Cox. All rights reserved.
//

#import "LocationListViewController.h"
#import "LocationDetailViewController.h"
#import "LocationService.h"
#import <MapKit/MapKit.h>


@interface LocationListViewController ()

@end

@implementation LocationListViewController
    CLLocation *listLocation;
    CLLocation *listCurrentLocation;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [[LocationService sharedInstance] addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[LocationService sharedInstance] countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"LocationObjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    LocationObject *locationAtIndex = [[LocationService sharedInstance] objectInListAtIndex:indexPath.row];
    [[cell textLabel] setText:locationAtIndex.locationName];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%.0f m", [locationAtIndex.distance doubleValue]]];
    return cell;
}

- (void) observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    if ([keyPath isEqualToString:@"currentLocation"]) {
        [self.tableView reloadData];
    }
}


#pragma mark CLLocationManagerDelegate Methods
- (void)viewWillDisappear:(BOOL)animated {
    [[LocationService sharedInstance] stopUpdatingLocation];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[LocationService sharedInstance] startUpdatingLocation];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return NO;
        }
    }
    return YES;
    
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[LocationService sharedInstance] removeObjectAtIndex:indexPath.row];
        [[self tableView] reloadData];
        [[LocationService sharedInstance] saveToPlist];
     }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
     }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowLocationDetails"]) {
        LocationDetailViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.location = [[LocationService sharedInstance] objectInListAtIndex:[self.tableView indexPathForSelectedRow].row];
        self.selectedindex = [self.tableView indexPathForSelectedRow];
        NSLog(@"segue location");
    }
}

-(IBAction)save:(UIStoryboardSegue *)segue {
    NSLog(@"SEGUE unwind");
    LocationObject *editedlocation;
    LocationDetailViewController *detailcontroller = [segue sourceViewController];
    if (detailcontroller.location) {
        editedlocation = [[LocationObject alloc] initWithName:detailcontroller.locationNameLabel.text
                                                     latitude:detailcontroller.location.latitude
                                                    longitude:detailcontroller.location.longitude
                                                     accuracy:detailcontroller.location.accuracy
                                                         date:detailcontroller.location.date];
    
    [[LocationService sharedInstance] editLocation:self.selectedindex.row :editedlocation];
    [self.tableView reloadData];
    [[LocationService sharedInstance] saveToPlist];
    }
}

- (void) dealloc {
    [[LocationService sharedInstance] removeObserver:self forKeyPath:@"currentLocation"];
}

@end