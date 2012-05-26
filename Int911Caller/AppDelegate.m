//
//  AppDelegate.m
//  Int911Caller
//
//  Created by Benedicte Raae on 19.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize emergencyNumbers = _emergencyNumbers;
@synthesize currentISOCountryCode = _currentISOCountryCode;

#ifdef DEBUG
// 1800 seconds = 30 minutes
const double UPDATE_INTERVAL = 5;
#else
const double UPDATE_INTERVAL = 1800;
#endif


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

- (void) loadInitialView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil]; 
    
    if([self locationManagerIsNotAuthorized] ||[self notConnectedToNetwork]) {
        NSLog(@"Load List Of Countries");
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"listOfCountries"];
    } else {
        NSLog(@"Load Locate User");
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"locateUser"];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        
    self.emergencyNumbers = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"Numbers" ofType:@"plist"]];
    
    NSLog(@"Number list: %@", self.emergencyNumbers);
    
    [self loadInitialView];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    didEnterBackgroundDate = [NSDate date];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if([self isTimeToReload]) {
        [self loadInitialView];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
