//
//  AddressDetailsViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/8/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleInfoViewController.h"
#import "RegistrationRecords.h"
#import "RootBaseViewController.h"
#import "CountryStateRecords.h"
#import "CountryStateViewController.h"

@interface AddressDetailsViewController : RootBaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressHeaderLbl;
@property (weak, nonatomic) IBOutlet UITextField *addressTxtField;
@property (weak, nonatomic) IBOutlet UILabel *countryLbl;
@property (weak, nonatomic) IBOutlet UITextField *stateTxtField;
@property (weak, nonatomic) IBOutlet UITextField *cityTxtField;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeTxtField;
@property (weak, nonatomic) IBOutlet UITextField *countryCodeTxtField;
@property (weak, nonatomic) IBOutlet UITextField *mobileNoTxtField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic)RegistrationRecords * objRegRecs;
@property (weak, nonatomic) IBOutlet UITextField *OTPTxtField;
@property (strong,nonatomic)NSString * otpStr;

@property(strong,nonatomic)NSMutableArray * countryNameArr;
@property(strong,nonatomic)NSMutableArray * countryMainArr;

- (IBAction)didClickSelectCountryBtn:(id)sender;

- (IBAction)didClickRewindBtn:(id)sender;
- (IBAction)didClickNextBtn:(id)sender;

@end
