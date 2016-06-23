//
//  DEMOViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMORootViewController.h"
#import "DEMOMenuViewController1.h"
#import "BookARideVC.h"

@interface DEMORootViewController ()

@end

@implementation DEMORootViewController

- (void)awakeFromNib
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    self.contentViewController = [storyboard instantiateViewControllerWithIdentifier:@"StarterNavVCSID"];
    //self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StarterNavVCSID"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController1"];
}

@end
