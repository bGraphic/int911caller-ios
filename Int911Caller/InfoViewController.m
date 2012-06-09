//
//  ViewController.m
//  Int911Caller
//
//  Created by Benedicte Raae on 05.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()
-(BOOL)openUrl:(NSString *)urlString;
@end

@implementation InfoViewController

@synthesize infoDict = _infoDict;
@synthesize rateAppButton = _rateAppButton;
@synthesize shareButton = _shareButton;
@synthesize supportButton = _supportButton;
@synthesize twitterButton = _twitterButton;
@synthesize blogButton = _blogButton;
@synthesize moreAppsButton = _moreAppsButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.infoDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"InfoPage" ofType:@"plist"]];
}
    
- (void)viewDidUnload
{
    [self setRateAppButton:nil];
    [self setShareButton:nil];
    [self setSupportButton:nil];
    [self setBlogButton:nil];
    [self setMoreAppsButton:nil];

    [self setTwitterButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)rateAppAction:(id)sender {
    NSString *rateAppUrl = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", [self.infoDict objectForKey:@"app_id"]];
    
    [self openUrl:rateAppUrl];
}

- (IBAction)shareAction:(id)sender {
    NSString *shareAppUrl = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", [self.infoDict objectForKey:@"app_id"]];
    NSString *body = [NSString stringWithFormat:NSLocalizedString(@"share_mail_body", nil), shareAppUrl]; 
    
    [self sendMailTo:nil withTitle:NSLocalizedString(@"share_mail_title", nil) andBody:body];
}

- (IBAction)supportAction:(id)sender {
    [self sendMailTo:[self.infoDict objectForKey:@"support_mail"] withTitle:NSLocalizedString(@"support_mail_title", nil) andBody:nil];
}

- (IBAction)blogAction:(id)sender {
    [self openUrl:[self.infoDict objectForKey:@"blog_link"]];
}

- (IBAction)moreAppsAction:(id)sender {
    NSString *moreAppsUrl
    = [NSString stringWithFormat:@"itms-apps://itunes.com/apps/%@", [self.infoDict objectForKey:@"store_id"]];

    [self openUrl:moreAppsUrl];    
}

- (IBAction)twitterAction:(id)sender {
    NSString *twitterUrl = [NSString stringWithFormat:@"twitter:///user?screen_name=%@", [self.infoDict objectForKey:@"twitter_user"]];
    
    if(![self openUrl:twitterUrl]) {
        twitterUrl = [NSString stringWithFormat:@"http://twitter.com/%@", [self.infoDict objectForKey:@"twitter_user"]];
        [self openUrl:twitterUrl];
    }
}

- (IBAction)closeInfoAction:(id)sender {
    [self dismissModalViewControllerAnimated:TRUE];
}

-(BOOL)openUrl:(NSString *)urlString {
    UIApplication *appDelegate = [UIApplication sharedApplication];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    if ([appDelegate openURL:url]) {
        NSLog(@"%@%@",@"Opened url:", [url description]);
        return true;
    } else {
        NSLog(@"%@%@",@"Could not open url:", [url description]);
        return false;
    }
}

-(void)sendMailTo:(NSString *)recipient withTitle:(NSString *)title andBody:(NSString *)body  {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	
    picker.mailComposeDelegate = self;
    
    if(recipient != nil) {
        [picker setToRecipients:[[NSArray alloc] initWithObjects:recipient, nil]];
    }
    
    if(title != nil) {
        [picker setSubject:title];
    }
    
    if(body != nil) {
    	[picker setMessageBody:body isHTML:YES];
    }
	

	
	[self presentViewController:picker animated:true completion:^{
        NSLog(@"Mail composer has been presented.");
    }];
    
    picker = nil;
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"e-mail_error_alert_title", nil) message:NSLocalizedString(@"e-mail_error_alert_message", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
            [controller dismissModalViewControllerAnimated:YES];
			break;
		case MFMailComposeResultSaved:
            [controller dismissModalViewControllerAnimated:YES];
			break;
		case MFMailComposeResultSent:
            [controller dismissModalViewControllerAnimated:YES];
			break;
		default:
            [alert show];
			break;
	}

}


@end
