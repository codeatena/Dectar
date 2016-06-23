//
//  DEMONavigationController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMONavigationController.h"

@interface DEMONavigationController ()

@end

@implementation DEMONavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
   
    if([self.visibleViewController.restorationIdentifier isEqualToString:@"MyRideVCID"]||[self.visibleViewController.restorationIdentifier isEqualToString:@"RateCardVCID"]||[self.visibleViewController.restorationIdentifier isEqualToString:@"MyMoneyID"]||[self.visibleViewController.restorationIdentifier isEqualToString:@"InviteVCID"]||[self.visibleViewController.restorationIdentifier isEqualToString:@"EmergencyVCID"]||[self.visibleViewController.restorationIdentifier isEqualToString:@"AboutVCID"]||[self.visibleViewController.restorationIdentifier isEqualToString:@"ProfileVCID"]){
        [self.view endEditing:YES];
        [self.frostedViewController.view endEditing:YES];
        
        // Present the view controller
        //
        [self.frostedViewController panGestureRecognized:sender];
        
    }
}

@end
