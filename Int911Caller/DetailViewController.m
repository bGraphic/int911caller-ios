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
- (void)configureCallButtons;
- (void)configureNoteText;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize callButtonOne = _callButtonOne;
@synthesize calButtonTwo = _calButtonTwo;
@synthesize callButtonThree = _callButtonThree;
@synthesize callButtonFour = _callButtonFour;
@synthesize callButtonFive = _callButtonFive;
@synthesize noteTextLabel = _noteTextLabel;
@synthesize callButtons = _callButtons;
@synthesize singleNumberButton = _singleNumberButton;

#pragma mark lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.callButtons = [[NSArray alloc] initWithObjects:self.callButtonOne, self.calButtonTwo, self.callButtonThree, self.callButtonFour, self.callButtonFive, nil];
    
    [self configureView];
}

- (void)viewDidUnload
{
    [self setSingleNumberButton:nil];
    [self setCallButtonFour:nil];
    [self setCallButtonFive:nil];
    [self setNoteTextLabel:nil];
    [self setCallButtonOne:nil];
    [self setCalButtonTwo:nil];
    [self setCallButtonThree:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationIsPortrait(interfaceOrientation));
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(CountryListing *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

#pragma mark - Configure the view

- (void)configureView
{
    for (UIButton *button in self.callButtons) {
        button.hidden = true;
    }
    
    self.singleNumberButton.hidden = true;
    self.noteTextLabel.text = @"";

    
    if (self.detailItem) {
        [self configureNoteText];
        [self configureCallButtons];
    }
    
}

- (void)configureNoteText
{
    NSDictionary *landlineNumbers = self.detailItem.landlineNumbers;
    
    if(landlineNumbers) 
    {
        NSString *landlineString = [CountryListing landlineStringFrom:landlineNumbers];
        
        self.noteTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"landline_note", nil), landlineString];
    }
}

- (void)configureCallButtons
{
    NSDictionary *emergencyNumbers = self.detailItem.embergencyNumbers;
    [self configureNoteText];
    
    if(emergencyNumbers.count == 1) 
    {
        [self.singleNumberButton setTitle:[emergencyNumbers objectForKey:@"general"] forState:UIControlStateNormal];
        
        self.singleNumberButton.emergencyNumber = [emergencyNumbers.allValues objectAtIndex:0];
        self.singleNumberButton.emergencyNumberKey = @"general";
        self.singleNumberButton.hidden = false;
        return;
    }
    
    int space = 95.f;
    int initY = 159.f;
    
    if(emergencyNumbers.count > 3) {
        space = 80.f;
        initY = 139.f;
    } 
    
    if(emergencyNumbers.count > 4) {
        space = 70.f;
        initY = 119.f;
    }
    
    
    int i = 0;
    for (NSString *numberKey in emergencyNumbers) {
        
        NSString *number = [emergencyNumbers objectForKey:numberKey];
        NSString *buttonTitle = [[NSString alloc] initWithFormat:@"%@\n%@", NSLocalizedString(numberKey,  nil), number];

        CallButton *button = [self.callButtons objectAtIndex:i];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        
        button.emergencyNumber = number;
        button.emergencyNumberKey = numberKey;
        
        CGRect frame = button.frame;
        frame.origin.y = space*i + initY;
        
        button.frame = frame;
        
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

@end
