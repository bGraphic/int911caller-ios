//
//  ErrorViewController.m
//  Int911Caller
//
//  Created by Benedicte Raae on 01.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ErrorViewController.h"
#import "BGCommonGraphics.h"

@implementation ErrorViewController
@synthesize message;
@synthesize searchDirectory;
@synthesize locateAgain;
@synthesize errorMessage;

- (void)viewDidLoad {
    self.locateAgain.text = NSLocalizedString(@"locate_again",  nil);
    self.searchDirectory.text = NSLocalizedString(@"search_directory",  nil);
    self.message.text = errorMessage;
    
    UIView *backgroundView = [BGCommonGraphics backgroundView];
    backgroundView.frame = self.view.bounds;
    
    [BGCommonGraphics addBackgroundToView:self.view];
}

- (void)viewDidUnload {
    [self setMessage:nil];
    [self setSearchDirectory:nil];
    [self setLocateAgain:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationIsPortrait(interfaceOrientation));
}

@end
