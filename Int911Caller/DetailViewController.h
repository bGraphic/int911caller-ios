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

@interface DetailViewController : UIViewController

@property (strong, nonatomic) CountryListing *detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *countryListButton;

@property (strong, nonatomic) IBOutlet UIButton *callButtonOne;
@property (strong, nonatomic) IBOutlet UIButton *calButtonTwo;
@property (strong, nonatomic) IBOutlet UIButton *callButtonThree;

@end
