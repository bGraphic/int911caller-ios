//
//  DetailViewController.m
//  Int911Caller
//
//  Created by Benedicte Raae on 19.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"  
#import "TestFlight.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize callButtonOne = _callButtonOne;
@synthesize calButtonTwo = _calButtonTwo;
@synthesize callButtonThree = _callButtonThree;
@synthesize callButtons = _callButtons;
@synthesize singleNumberButton = _singleNumberButton;


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
    for (UIButton *button in self.callButtons) {
        button.hidden = true;
    }
    
    self.singleNumberButton.hidden = true;
    
    if (self.detailItem) {
        [self configureCallButtons];
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
    
    if(numbers.count == 1) {
        [self setButtonTitle:[numbers objectForKey:@"general"] button:self.singleNumberButton];
        self.singleNumberButton.hidden = false;
        return;
    }
    
    int i = 0;
    for (NSString *numberKey in numbers) {
        
        NSString *number = [numbers objectForKey:numberKey];
        NSString *buttonTitle = [[NSString alloc] initWithFormat:@"%@\n%@", number, NSLocalizedString(numberKey,  nil)];

        CallButton *button = [self.callButtons objectAtIndex:i];
        button.emergencyNumber = number;
        button.emergencyNumberKey = numberKey;
        [self setButtonTitle:buttonTitle button:button];
        button.hidden = false;
        
        i++;
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
    CallButton *selectedButton = (CallButton *)sender;
    
    NSLog(@"Calling %@ (%@)", selectedButton.emergencyNumber, selectedButton.emergencyNumberKey);

    [TestFlight passCheckpoint:@"CALLED"];
    
    #ifdef RELEASE
    [self placeCallTo:selectedButton.emergencyNumber];
    #else
    [self showAlertFor:selectedButton.emergencyNumber];      
    #endif
}

#pragma mark lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.callButtons = [[NSArray alloc] initWithObjects:self.callButtonOne, self.calButtonTwo, self.callButtonThree, nil];
    
    [self configureView];
}

- (void)viewDidUnload
{
    [self setSingleNumberButton:nil];
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
