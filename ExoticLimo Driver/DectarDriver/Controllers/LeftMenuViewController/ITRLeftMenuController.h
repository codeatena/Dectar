//
//  LeftMenuController.h
//  ITRAirSideMenu
//
//  Created by kirthi on 12/08/15.
//  Copyright (c) 2015 kirthi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"
#import "UrlHandler.h"
#import "RTSpinKitView.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "BankingInfoViewController.h"
#import "PaymentSummaryListViewController.h"
#import "ChangePasswordCabViewController.h"


@interface ITRLeftMenuController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *tapBtn;
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
- (IBAction)didSwipeRight:(id)sender;
+ (instancetype) controller;
@end
