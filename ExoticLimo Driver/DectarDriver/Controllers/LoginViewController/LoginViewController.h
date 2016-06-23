//
//  LoginViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/21/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RootBaseViewController.h"
#import "Theme.h"
#import "DectarCustomColor.h"
#import "UrlHandler.h"
#import "DriverInfoRecords.h"
#import "StarterViewController.h"

#import "ITRAirSideMenu.h"
#import "ITRLeftMenuController.h"
#import "ForgotPasswordCabViewController.h"


@interface LoginViewController : RootBaseViewController
@property ITRAirSideMenu *itrAirSideMenu;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordbtn;

- (IBAction)didClickBackBtn:(id)sender;
- (IBAction)didClickSigninBtn:(id)sender;

@end
