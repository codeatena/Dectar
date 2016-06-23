//
//  DEMONavigationController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMONavigationController.h"
#import "HomeViewController.h"

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
    // Dismiss keyboard (optional)
    //
   
     
    if([self.visibleViewController.restorationIdentifier isEqualToString:@"StarterVCSID"]||[self.visibleViewController.restorationIdentifier isEqualToString:@"PaymentListVCSID"]||[self.visibleViewController.restorationIdentifier isEqualToString:@"BankingInfoVCSID"]||[self.visibleViewController.restorationIdentifier isEqualToString:@"TripListVCSID"]||[self.visibleViewController.restorationIdentifier isEqualToString:@"ChangePasswordVCSID"]||[self.visibleViewController.restorationIdentifier isEqualToString:@"ChangeLanguageVCSID"]){
        [self.view endEditing:YES];
        [self.frostedViewController.view endEditing:YES];
        
        // Present the view controller
        //
        [self.frostedViewController panGestureRecognized:sender];
        
    }
    
}

@end
