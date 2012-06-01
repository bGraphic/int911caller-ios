//
//  DetailViewController.h
//  Int911Caller
//
//  Created by Benedicte Raae on 19.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CountryListing.h"
#import "CallButton.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) CountryListing *detailItem;

@property (strong, nonatomic) IBOutlet CallButton *callButtonOne;
@property (strong, nonatomic) IBOutlet CallButton *calButtonTwo;
@property (strong, nonatomic) IBOutlet CallButton *callButtonThree;
@property (strong, nonatomic) NSArray *callButtons;
@property (strong, nonatomic) IBOutlet CallButton *singleNumberButton;

- (IBAction)callEmergencyNumberAction:(id)sender;

@end
