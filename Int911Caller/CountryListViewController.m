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
#import "BGSearchBar.h"


@implementation CountryListViewController

CLLocationManager *locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *numbers = [[delegate emergencyNumbers] allValues];
    
    self.emergencyNumbers = [[NSMutableArray alloc] initWithArray:numbers];
    [self.emergencyNumbers sortUsingSelector:@selector(compare:)];
    
    BGSearchBar *searchBarBG = (BGSearchBar *) self.searchDisplayController.searchBar;
    searchBarBG.borderColor = self.tableView.separatorColor;
    searchBarBG.placeholder = NSLocalizedString(@"search_placeholder", nil);
    
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.emergencyNumbers count]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = NSLocalizedString(@"tab_title_directory", nil);

    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationIsPortrait(interfaceOrientation));
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
    
    [self performSegueWithIdentifier:@"showDetail" sender:tableView];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        UITableView *senderView = (UITableView*) sender;
        
        NSIndexPath *indexPath = [senderView indexPathForSelectedRow];
        CountryListing *countryListing = nil;
        
        if (senderView == self.searchDisplayController.searchResultsTableView){
            countryListing = [self.searchResults objectAtIndex:indexPath.row];
        }
        else{
            countryListing = [self.emergencyNumbers objectAtIndex:indexPath.row];
        }
        
        DetailViewController *view = [segue destinationViewController];
        view.detailItem = countryListing;
        view.title = countryListing.localizedCountryName;
    }
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	
	[self.searchResults removeAllObjects];	

    
	for (CountryListing *countryListing in self.emergencyNumbers){

        NSComparisonResult result = [countryListing.localizedCountryName 
                                     compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) 
                                     range:NSMakeRange(0, [searchText length])];
        
        if (result == NSOrderedSame){
            [self.searchResults addObject:countryListing];
        }

	}
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}


#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    [controller.searchResultsTableView setBackgroundView:[self.tableView backgroundView]];
    [controller.searchResultsTableView setSeparatorColor:[self.tableView separatorColor]];
    [controller.searchResultsTableView setSeparatorStyle:[self.tableView separatorStyle]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    BGSearchBar *searchBar = (BGSearchBar *) controller.searchBar;
    searchBar.borderView.hidden = YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    BGSearchBar *searchBar = (BGSearchBar *) controller.searchBar;
    searchBar.borderView.hidden = NO;
}

@end
