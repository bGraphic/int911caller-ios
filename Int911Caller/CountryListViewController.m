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
@synthesize searchBar;
@synthesize searchDisplayController;
@synthesize searchResults;

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
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *numbers = [[delegate emergencyNumbers] allValues];
    
    self.emergencyNumbers = [[NSMutableArray alloc] initWithArray:numbers];
    [self.emergencyNumbers sortUsingSelector:@selector(compare:)];
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.emergencyNumbers count]];
    
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setSearchDisplayController:nil];
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
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return self.searchResults.count;
    }
    else{
        return self.emergencyNumbers.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

    CountryListing *countryListing = nil;
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        countryListing = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        countryListing = [self.emergencyNumbers objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = [countryListing localizedCountryName];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        CountryListViewController *senderView = (CountryListViewController*) sender;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CountryListing *countryListing = nil;
        
        if (senderView.tableView == senderView.searchDisplayController.searchResultsTableView){
            countryListing = [senderView.searchResults objectAtIndex:indexPath.row];
        }
        else{
            countryListing = [senderView.emergencyNumbers objectAtIndex:indexPath.row];
        }
        
        DetailViewController *view = [segue destinationViewController];
        [view setShowLocateMeButton:TRUE];
        [view setDetailItem:countryListing];
    }
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.searchResults removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (CountryListing *countryListing in self.emergencyNumbers)
	{

        NSComparisonResult result = [countryListing.localizedCountryName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
        {
            [self.searchResults addObject:countryListing];
        }

	}
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}





@end
