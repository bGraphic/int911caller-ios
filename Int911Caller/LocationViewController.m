//
//  LocationViewController.m
//  Int911Caller
//
//  Created by Benedicte Raae on 19.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"

#ifdef DEBUG
const double UPDATE_INTERVAL = 1;
#endif

#ifdef ADHOC
// 600 seconds = 5 minutes
const double UPDATE_INTERVAL = 600;
#endif

#ifdef RELEASE
// 1800 seconds = 30 minutes
const double UPDATE_INTERVAL = 1800;
#endif

@implementation LocationViewController

@synthesize activityIndicator = _activityIndicator;
@synthesize locationManager = _locationManager;

NSString *currentISOCountryCode;
NSDate *didEnterBackgroundDate;

- (BOOL) locationManagerIsNotAuthorized {
    return  [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || 
    [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted;
}

- (BOOL) notConnectedToNetwork
{
	Reachability *reachability = [Reachability reachabilityForInternetConnection];  
    NetworkStatus networkStatus = [reachability currentReachabilityStatus]; 
    return (networkStatus == NotReachable);
} 

- (BOOL) isTimeToReload
{
    return didEnterBackgroundDate == nil || [didEnterBackgroundDate timeIntervalSinceNow] < -UPDATE_INTERVAL;
}

- (void) didEnterBackground:(NSNotification*)notification
{
    didEnterBackgroundDate = [NSDate date];
}

- (void) updateLocation {
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void) willEnterForeground:(NSNotification*)notification
{
    if([self isTimeToReload]){  
        [self.navigationController popToRootViewControllerAnimated:FALSE];
        [self updateLocation];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"load");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    self.locationManager.distanceFilter = 1000.0f;

    [self.activityIndicator startAnimating];
    [self updateLocation];
    
    self.title = @"911 Caller";
}

- (void)viewDidUnload
{
    self.locationManager.delegate = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void) viewDidDisappear:(BOOL)animated {
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate; 
        CountryListing *countryListing = [appDelegate.emergencyNumbers objectForKey:currentISOCountryCode];
        
        DetailViewController *view = [segue destinationViewController];
        [view setDetailItem:countryListing];

    }
}

#pragma Location Manager

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location Error: %@", [error description]);
    
    [self.locationManager stopUpdatingLocation];
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
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if((sizeof placemarks) > 0 && error == nil) {
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            currentISOCountryCode = [placemark ISOcountryCode];
            
            NSLog(@"iPhone is in country: %@", currentISOCountryCode);
            
            [self performSegueWithIdentifier:@"showDetail" sender:self];
            
        } else {
            
            NSLog(@"Location Error: %@", [error description]);
            
            [self performSegueWithIdentifier:@"listCountries" sender:self];   
            
        }
        
    }];
}


@end

