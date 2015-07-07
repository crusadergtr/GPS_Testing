//
//  ViewController.h
//  GPS_test
//
//  Created by JIWEI LIN on 15/06/2015.
//  Copyright (c) 2015 IM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *locationDetailBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveLocationButton;

@property (weak, nonatomic) IBOutlet UISwitch *locationAwareSwitch;
- (IBAction)changeLocationAware:(id)sender;

@end

