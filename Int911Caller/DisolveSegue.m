//
//  DisolveSegue.m
//  Int911Caller
//
//  Created by Benedicte Raae on 31.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DisolveSegue.h"

@implementation DisolveSegue

-(void)perform{
    UIViewController *destinationViewController = [self destinationViewController];
    UIViewController *sourceViewController = [self sourceViewController];
    destinationViewController.navigationItem.hidesBackButton = TRUE;
    
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [sourceViewController.navigationController pushViewController:destinationViewController animated:YES];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:sourceViewController.navigationController.view cache:NO];
    [UIView commitAnimations];
}

@end
