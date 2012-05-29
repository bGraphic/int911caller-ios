//
//  DetailViewController.m
//  Int911Caller
//
//  Created by Benedicte Raae on 19.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"    

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize countryListButton = _countryListButton;
@synthesize callButtonOne = _callButtonOne;
@synthesize calButtonTwo = _calButtonTwo;
@synthesize callButtonThree = _callButtonThree;

NSArray *buttons;

#pragma mark - Managing the detail item

- (void)setDetailItem:(CountryListing *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)setButtonTitle:(NSString *)number button:(UIButton *)button
{
    [button setTitle:number forState:UIControlStateNormal];
    [button setTitle:number forState:UIControlStateHighlighted];
}

- (IBAction)callEmergencyNumberAction:(id)sender {
    UIButton *selectedButton = (UIButton *)sender;
    int i = 0;
    for(UIButton *button in buttons) {
        if(selectedButton == button) {
            NSString *number = [[self.detailItem.embergencyNumbers allValues] objectAtIndex:i];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:number message:@"No calling since this is testing" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        i++;
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    

    if (self.detailItem) {
        NSDictionary *numbers = self.detailItem.embergencyNumbers;
        
        int i = 0;
        
        for (NSString *numberKey in numbers) {
            UIButton *button = [buttons objectAtIndex:i];
            NSString *number = [numbers objectForKey:numberKey];
            
            button.hidden = false;
            [self setButtonTitle:number button:button];
            
            i++;
        }

        
        self.title = [self.detailItem localizedCountryName];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    buttons = [[NSArray alloc] initWithObjects:self.callButtonOne, self.calButtonTwo, self.callButtonThree, nil];
    
    for (UIButton *button in buttons) {
        button.hidden = true;
    }
    
    [self configureView];
}

- (void)viewDidUnload
{
    [self setCountryListButton:nil];
    [self setCallButtonOne:nil];
    [self setCalButtonTwo:nil];
    [self setCallButtonThree:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
