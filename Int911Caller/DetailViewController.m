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
- (void)configureCallButtons;
- (void)configureExtraButtons;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize callButtonOne = _callButtonOne;
@synthesize calButtonTwo = _calButtonTwo;
@synthesize callButtonThree = _callButtonThree;
@synthesize countryListButton = _countryListButton;
@synthesize locateButton = _locateButton;
@synthesize showCountryListButton = _showCountryListButton;
@synthesize showLocateMeButton = _showLocateMeButton;

NSArray *callButtons;

#pragma mark - Managing the detail item

- (void)setDetailItem:(CountryListing *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailItem) {
        [self configureCallButtons];
        self.title = [self.detailItem localizedCountryName];
    }
    
}

#pragma mark - Configure the buttons


- (void)setButtonTitle:(NSString *)number button:(UIButton *)button
{
    [button setTitle:number forState:UIControlStateNormal];
    [button setTitle:number forState:UIControlStateHighlighted];
}

- (void)configureCallButtons
{
    NSDictionary *numbers = self.detailItem.embergencyNumbers;
    
    int i = 0;
    for (NSString *numberKey in numbers) {
        
        NSString *number = [numbers objectForKey:numberKey];
        NSString *buttonTitle = [[NSString alloc] initWithFormat:@"%@ - %@", number, numberKey];

        UIButton *button = [callButtons objectAtIndex:i];
        [self setButtonTitle:buttonTitle button:button];
        button.hidden = false;
        
        i++;
    }
}


#pragma mark extra buttons

- (void)setShowCountryListButton:(BOOL)showCountryListButton {
    if (_showCountryListButton != showCountryListButton) {
        _showCountryListButton = showCountryListButton;
        
        [self configureExtraButtons];
    }
}

- (void)setShowLocateMeButton:(BOOL)showLocateMeButton {
    if (_showLocateMeButton != showLocateMeButton) {
        _showLocateMeButton = showLocateMeButton;
        
        [self configureExtraButtons];
    }
}

- (void)configureExtraButtons {
    self.countryListButton.hidden = !self.showCountryListButton;
    
    if(!self.showLocateMeButton) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.navigationItem.rightBarButtonItem = self.locateButton;

    }
}

#pragma mark call action

- (void)showAlertFor:(NSString *)number {
    NSString *title = [[NSString alloc] initWithFormat:@"Calling %@", number];
    NSString *message = @"The app will not call the emergency number during testing";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (void)placeCallTo:(NSString *)number {

    NSString *urlString = [[NSString alloc] initWithFormat:@"tel:%@", number];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) 
        [[UIApplication sharedApplication] openURL:url];
    else
        NSLog(@"Could not call the number: %@", number);    
}

- (IBAction)callEmergencyNumberAction:(id)sender {
    UIButton *selectedButton = (UIButton *)sender;
    
    int i = 0;
    for(UIButton *button in callButtons) {
        
        if(selectedButton == button) {
            NSString *number = [[self.detailItem.embergencyNumbers allValues] objectAtIndex:i];
            
            #ifdef RELEASE
            [self placeCallTo:number];
            #else
            [self showAlertFor:number];      
            #endif
            break;
        }
        i++;
    }
}

#pragma mark lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    callButtons = [[NSArray alloc] initWithObjects:self.callButtonOne, self.calButtonTwo, self.callButtonThree, nil];
    
    for (UIButton *button in callButtons) {
        button.hidden = true;
    }
    
    [self configureView];
    [self configureExtraButtons];
}

- (void)viewDidUnload
{
    [self setCountryListButton:nil];
    [self setLocateButton:nil];
    [super viewDidUnload];
    
    [self setCallButtonOne:nil];
    [self setCalButtonTwo:nil];
    [self setCallButtonThree:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
