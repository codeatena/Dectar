//
//  CashOTPViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/2/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlHandler.h"
#import "Theme.h"
#import "RTSpinKitView.h"
#import "UIView+Toast.h"
#import "ReceiveCashViewController.h"
#import "RootBaseViewController.h"

@interface CashOTPViewController : RootBaseViewController<UITextFieldDelegate>
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *otpHeaderLbl;
@property (weak, nonatomic) IBOutlet UITextField *OTPTextField;
@property (weak, nonatomic) IBOutlet UILabel *otpTextLbl;
@property (weak, nonatomic) IBOutlet UIButton *requestBtn;
@property(strong,nonatomic)NSString * rideId;
@property(strong,nonatomic)NSString * rateAmount;
@property(strong,nonatomic)NSString * OTPStr;
- (IBAction)didClickRequestBtn:(id)sender;
- (IBAction)didClickBackBtn:(id)sender;

@end
