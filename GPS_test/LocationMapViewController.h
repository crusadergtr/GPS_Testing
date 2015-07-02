//
//  LocationMapViewController.h
//  GPS_test
//
//  Created by Shane Cox on 1/07/2015.
//  Copyright © 2015 IM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationMapViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *locationDetailButton;
@property (weak, nonatomic) IBOutlet UIView *locationDetailView;

- (IBAction)showLocationDetail:(id)sender;
@end
