//
//  ErrorViewController.h
//  Int911Caller
//
//  Created by Benedicte Raae on 01.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorViewController : UIViewController

@property (strong, nonatomic) NSString *errorMessage;

@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UILabel *searchDirectory;
@property (strong, nonatomic) IBOutlet UILabel *locateAgain;

@end
