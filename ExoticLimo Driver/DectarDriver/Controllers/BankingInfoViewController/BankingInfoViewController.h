//
//  BankingInfoViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/11/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "Theme.h"
#import "WBErrorNoticeView.h"
#import "RootBaseViewController.h"
#import "BankingRecords.h"

@interface BankingInfoViewController : RootBaseViewController<UITextFieldDelegate,UITextViewDelegate>
+ (instancetype) controller;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *accUserNameLbl;
@property (weak, nonatomic) IBOutlet UITextField *userNameTxtField;
@property (weak, nonatomic) IBOutlet UILabel *accUserAddressLbl;
@property (weak, nonatomic) IBOutlet UITextView *accAddressTxtView;
@property (weak, nonatomic) IBOutlet UILabel *accNumberLbl;
@property (weak, nonatomic) IBOutlet UITextField *accNumberText;
@property (weak, nonatomic) IBOutlet UILabel *branchNameLbl;
@property (weak, nonatomic) IBOutlet UITextField *branchNameTxtField;
@property (weak, nonatomic) IBOutlet UILabel *branchAddressLbl;
@property (weak, nonatomic) IBOutlet UITextView *branchAddressTxtview;
@property (weak, nonatomic) IBOutlet UILabel *ifscLbl;
@property (weak, nonatomic) IBOutlet UITextField *ifscTxtField;
@property (weak, nonatomic) IBOutlet UILabel *routingLbl;
@property (weak, nonatomic) IBOutlet UITextField *routingTxtField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLbl;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTxtField;
@property (weak, nonatomic) IBOutlet UIView *saveView;


- (IBAction)didClickSaveBtn:(id)sender;

- (IBAction)didClickMenuBtn:(id)sender;

@end
