//
//  ViewController.h
//  Int911Caller
//
//  Created by Benedicte Raae on 05.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface InfoViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSDictionary *infoDict;

@property (strong, nonatomic) IBOutlet UIButton *rateAppButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *supportButton;

@property (strong, nonatomic) IBOutlet UIButton *blogButton;
@property (strong, nonatomic) IBOutlet UIButton *moreAppsButton;

- (IBAction)rateAppAction:(id)sender;
- (IBAction)shareAction:(id)sender;
- (IBAction)supportAction:(id)sender;
- (IBAction)blogAction:(id)sender;
- (IBAction)moreAppsAction:(id)sender;

- (IBAction)closeInfoAction:(id)sender;

@end
