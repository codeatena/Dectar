//
//  ViewFleetVC.m
//  Dectar
//
//  Created by AnCheng on 6/24/16.
//  Copyright © 2016 CasperonTechnologies. All rights reserved.
//

#import "ViewFleetVC.h"
#import "REFrostedViewController.h"

@interface ViewFleetVC ()

@end

@implementation ViewFleetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_btnMenu createTitle:@"MENU" withIcon:[UIImage imageNamed:@"Menu"]
                     font:[UIFont fontWithName:@"RobotoCondensed-Bold" size:17.0f]
               iconHeight:24
              iconOffsetY:-6];
    _btnMenu.bgColor = [UIColor clearColor];
    _btnMenu.borderWidth = 0.0f;
    _btnMenu.iconColor = [UIColor grayColor];
    _btnMenu.titleColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

@end
