//
//  ChangePasswordCabViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 12/21/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RootBaseViewController.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "Theme.h"
#import "WBErrorNoticeView.h"

@interface ChangePasswordCabViewController : RootBaseViewController
+ (instancetype) controller;
//@property (weak, nonatomic) IBOutlet UITextField *newPassTxtField;
@property (weak, nonatomic) IBOutlet UITextField *oldPassTxtField;

@property (weak, nonatomic) IBOutlet UITextField *retypePassTxtField;
@property (weak, nonatomic) IBOutlet UIScrollView *changePasswordScrollView;

@property (weak, nonatomic) IBOutlet HeaderLabelHandler *headerlbl;
@property (weak, nonatomic) IBOutlet ButtonColorHandler *changebtn;

@end
