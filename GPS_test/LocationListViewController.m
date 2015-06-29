//
//  LocationListViewController.m
//  CoreLocationTest
//
//  Created by Shane Cox on 3/11/12.
//  Copyright (c) 2012 Shane Cox. All rights reserved.
//

#import "LocationListViewController.h"
#import "LocationDetailViewController.h"
#import "LocationObject.h"
#import "LocationObjectController.h"


@class LocationObjectController;

@interface LocationListViewController ()

@end

@implementation LocationListViewController


//@synthesize locationDataController = _locationDataController;


- (LocationObjectController *)locationDataController{
    if (!_locationDataController) _locationDataController = [[LocationObjectController alloc] init];
    return _locationDataController;
}

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
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.locationDataController countOfList];
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
    
    LocationObject *locationAtIndex = [self.locationDataController objectInListAtIndex:indexPath.row];
    [[cell textLabel] setText:locationAtIndex.locationName];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"(%@, %@)",locationAtIndex.latitude,locationAtIndex.longitude]];
    return cell;
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
        [self.locationDataController removeObjectAtIndex:indexPath.row];
        [[self tableView] reloadData];
        [self.locationDataController saveToPlist];
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
        
        detailViewController.location = [self.locationDataController objectInListAtIndex:[self.tableView indexPathForSelectedRow].row];
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
    
    [self.locationDataController editLocation:self.selectedindex.row :editedlocation];
    [self.tableView reloadData];
        [self.locationDataController saveToPlist];
    }
}

@end