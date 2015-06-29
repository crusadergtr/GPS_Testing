//
//  LocationListViewController.h
//  CoreLocationTest
//
//  Created by Shane Cox on 3/11/12.
//  Copyright (c) 2012 Shane Cox. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LocationObjectController;

@interface LocationListViewController : UITableViewController

@property (strong, nonatomic) LocationObjectController *locationDataController;
@property (strong, nonatomic) NSIndexPath *selectedindex;
@end
