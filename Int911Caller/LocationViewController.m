//
//  LocationViewController.m
//  Int911Caller
//
//  Created by Benedicte Raae on 19.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationViewController.h"
#import "DetailViewController.h"


@implementation LocationViewController

@synthesize activityIndicator;
CLLocationManager *locationManager;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    locationManager.distanceFilter = 1000.0f; 
    [locationManager startUpdatingLocation];
    
    [activityIndicator startAnimating];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate; 
        
        
        [[segue destinationViewController] setDetailItem:[appDelegate.emergencyNumbers objectAtIndex:0]];

    }
}

#pragma Location Manager

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location Error: %@", [error description]);
    NSString *errorMessage;
    
    switch ([error code]) {
        case kCLErrorDenied:
            errorMessage = NSLocalizedString(@"location_service_off",  nil);
            break;
        case kCLErrorLocationUnknown:
            errorMessage = NSLocalizedString(@"location_unavailable",  nil);
            break;
        default:
            errorMessage = NSLocalizedString(@"location_standard",  nil);
            break;
    }
    
    [self performSegueWithIdentifier:@"listCountries" sender:self];    
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if((sizeof placemarks) > 0 && error == nil) {
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            NSString *currentISOCountryCode = [placemark ISOcountryCode];
            
            NSLog(@"iPhone is in country: %@", currentISOCountryCode);
            
            [self performSegueWithIdentifier:@"showDetail" sender:self];
            
        } else {
            
            NSLog(@"Location Error: %@", [error description]);
            
        }
        
    }];
}


@end

