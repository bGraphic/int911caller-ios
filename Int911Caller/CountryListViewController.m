//
//  MasterViewController.m
//  Int911Caller
//
//  Created by Benedicte Raae on 19.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CountryListViewController.h"

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "CountryListing.h"


@implementation CountryListViewController

@synthesize emergencyNumbers;

CLLocationManager *locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"911 Caller";
    
    UIImage *backgroundImage = [UIImage imageNamed:@"GUI-911_background.png"];
    UIColor *backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
                    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    backgroundView.backgroundColor = backgroundColor;
    
    [self.tableView setBackgroundView:backgroundView];
    
//    [self.tableView setBackgroundColor:backgroundColor];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *numbers = [[delegate emergencyNumbers] allValues];
    
    self.emergencyNumbers = [[NSMutableArray alloc] initWithArray:numbers];
    [self.emergencyNumbers sortUsingSelector:@selector(compare:)];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table View/Users/raae/bGraphic/APPS/Int911Caller/src/Int911Caller/MasterViewController.m

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.emergencyNumbers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    CountryListing *countryListing = [self.emergencyNumbers objectAtIndex:indexPath.row];
    cell.textLabel.text = [countryListing localizedCountryName];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CountryListing *countryListing = [self.emergencyNumbers objectAtIndex:indexPath.row];
        
        [[segue destinationViewController] setDetailItem:countryListing];
    }
}

@end
