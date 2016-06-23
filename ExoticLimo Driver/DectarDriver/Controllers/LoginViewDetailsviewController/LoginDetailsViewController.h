//
//  LoginDetailsViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/8/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressDetailsViewController.h"
#import "Theme.h"
#import "RegistrationRecords.h"

@interface LoginDetailsViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UILabel *loginDetHeaderLbl;
@property (weak, nonatomic) IBOutlet UITextField *driverNameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (weak, nonatomic) IBOutlet UITextField *conFirmPasswordTxtField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic)RegistrationRecords * objRegRecs;


- (IBAction)didClickRewindBtn:(id)sender;
- (IBAction)didClickNextBtn:(id)sender;

@end
