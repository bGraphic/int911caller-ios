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
#import "TestFlight.h"
#import "ErrorViewController.h"

#ifdef DEBUG
const double UPDATE_INTERVAL = 10;
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
@synthesize message = _message;

NSString *errorMessage;

NSString *currentISOCountryCode;
NSDate *currentISOCountryCodeDate;
CountryListing *currentCountryListing;

- (BOOL) isTimeToReload
{
    return currentISOCountryCodeDate == nil || [currentISOCountryCodeDate timeIntervalSinceNow] < -UPDATE_INTERVAL;
}

- (void) willEnterForeground:(NSNotification*)notification {
    
    if([self isTimeToReload]){
        [self.tabBarController setSelectedViewController:self.navigationController];
        [self.tabBarController dismissModalViewControllerAnimated:FALSE];
        [self.navigationController popToRootViewControllerAnimated:FALSE];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    self.locationManager.distanceFilter = 1000.0f;
}

- (void)viewDidUnload
{
    self.locationManager.delegate = nil;
    [self setMessage:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.title = NSLocalizedString(@"tab_bar_local", nil);
    self.navigationItem.title = NSLocalizedString(@"tab_title_local", nil);
    self.message.text = NSLocalizedString(@"locating_message", nil);
    
    errorMessage = nil;
    
    self.locationManager.delegate = self;
    
    [self.activityIndicator startAnimating];
    [self.locationManager startUpdatingLocation];
}

- (void) viewDidDisappear:(BOOL)animated {
    
    self.locationManager.delegate = nil;
    
    [self.locationManager stopUpdatingLocation];
    [self.activityIndicator stopAnimating];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *view = [segue destinationViewController];
    view.navigationItem.hidesBackButton = true;
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        DetailViewController *view = [segue destinationViewController];
        view.detailItem = currentCountryListing;
        view.title = currentCountryListing.localizedCountryName;
        
    } else if ([[segue identifier] isEqualToString:@"showError"]) {
        
        ErrorViewController *view = [segue destinationViewController];
        view.errorMessage = errorMessage;
    }
}

#pragma Location Manager

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    
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
    
    NSLog(@"Location Error: %@", [error description]);
    [TestFlight passCheckpoint:@"LOCATION ERROR"];
    
    [self performSegueWithIdentifier:@"showError" sender:self];
    
    
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
            currentISOCountryCodeDate = [NSDate date];
            
            NSLog(@"iPhone is in country: %@", currentISOCountryCode);
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate; 
            currentCountryListing = [appDelegate.emergencyNumbers objectForKey:currentISOCountryCode];
            
            if(currentCountryListing != nil) {
                [self performSegueWithIdentifier:@"showDetail" sender:self];
            } else {
                errorMessage = [NSString stringWithFormat:NSLocalizedString(@"country_missing", nil), [CountryListing localizedCountryNameFromCountryKey:currentISOCountryCode]];
                [TestFlight passCheckpoint:[NSString stringWithFormat:@"COUNTRY MISSING: %@", currentISOCountryCode]];
                [self performSegueWithIdentifier:@"showError" sender:self];
            }
                
        } else {
            
            NSLog(@"Geocode error: %@", [error description]);
            [TestFlight passCheckpoint:@"GEOCODE ERROR"];
            errorMessage = NSLocalizedString(@"geocode_standard",  nil);
            
            [self performSegueWithIdentifier:@"showError" sender:self];   
            
        }
        
    }];
}


@end

