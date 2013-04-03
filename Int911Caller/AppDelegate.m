//
//  AppDelegate.m
//  Int911Caller
//
//  Created by Benedicte Raae on 19.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "CountryListing.h"
#import "TestFlight.h"

@interface AppDelegate ()
- (void) loadEmergencyNumbersFor: (NSString *) continent;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize emergencyNumbers = _emergencyNumbers;

- (void) loadEmergencyNumbersFor: (NSString *) continent {
    
    NSDictionary *emergencyNumbersFromFile = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: continent ofType:@"plist"]];
    
    for(NSString *countryKey in emergencyNumbersFromFile) {
        NSDictionary *countryNumbers = [[emergencyNumbersFromFile objectForKey:countryKey] objectForKey:@"numbers"];
        
        CountryListing *countryListing = [[CountryListing alloc] initWithKey:countryKey andNumbers:countryNumbers];
        
        NSDictionary *landlineNumbers = [[emergencyNumbersFromFile objectForKey:countryKey] objectForKey:@"landline"];
        
        if(landlineNumbers) {
            countryListing.landlineNumbers = landlineNumbers;
        }
        
        [self.emergencyNumbers setObject:countryListing forKey:countryKey];
    }
    
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UINavigationController *tabLocation = [tabBarController.viewControllers objectAtIndex:0];
    UINavigationController *tabDirectory = [tabBarController.viewControllers objectAtIndex:1];

    [[tabLocation tabBarItem] setTitle:NSLocalizedString(@"tab_bar_local", nil)];
    [[tabDirectory tabBarItem] setTitle:NSLocalizedString(@"tab_bar_directory", nil)];
    
    tabLocation.delegate = self;
    tabDirectory.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(infoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    infoButton.contentEdgeInsets = (UIEdgeInsets){.right=10, .left=-10};
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
}

- (void)infoButtonAction {
    [self.window.rootViewController performSegueWithIdentifier:@"showInfo" sender:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.emergencyNumbers = [[NSMutableDictionary alloc] init];
    
    [self loadEmergencyNumbersFor:@"Europe"];
    [self loadEmergencyNumbersFor:@"Africa"];
    [self loadEmergencyNumbersFor:@"Asia"];
    [self loadEmergencyNumbersFor:@"SouthAmerica"];
    [self loadEmergencyNumbersFor:@"NorthAmerica"];
    [self loadEmergencyNumbersFor:@"CentralAmerica"];
    [self loadEmergencyNumbersFor:@"AustraliaOceania"];
    
    #ifdef RELEASE
        [TestFlight takeOff:@"d632f498-ad90-481b-be2c-8b7914844622"];
    #endif
    
    #ifdef ADHOC
        [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
        [TestFlight takeOff:@"6b463fa6-a72e-43c5-8408-2353fae7c4f7"];
    #endif
    
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
