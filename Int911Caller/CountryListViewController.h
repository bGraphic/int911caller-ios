//
//  MasterViewController.h
//  Int911Caller
//
//  Created by Benedicte Raae on 19.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryListViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *emergencyNumbers;
@property (strong, nonatomic) NSMutableArray *searchResults;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;

@end
