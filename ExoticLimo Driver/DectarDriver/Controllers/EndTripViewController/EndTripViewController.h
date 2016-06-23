//
//  EndTripViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/23/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"
#import "RootBaseViewController.h"
#import "DectarCustomColor.h"
#import "IQActionSheetPickerView.h"
#import "IQActionSheetViewController.h"
#import "BSKeyboardControls.h"
#import "LocationSearchViewController.h"
#import "WBErrorNoticeView.h"
#import "FareSummaryViewController.h"
#import "CashOTPViewController.h"
#import "LocationSearchViewController.h"
#import "PaymentWaitingViewController.h"


@interface EndTripViewController : RootBaseViewController<UITextFieldDelegate,IQActionSheetPickerViewDelegate,BSKeyboardControlsDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *locHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *dropTimeHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *waitHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *disHeaderLbl;

@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *waitingTimeLbl;
@property (weak, nonatomic) IBOutlet UITextField *distanceTxtField;
@property (weak, nonatomic) IBOutlet UITextField *hourWaitTxtField;
@property (weak, nonatomic) IBOutlet UITextField *minWaitTxtField;
@property (weak, nonatomic) IBOutlet UIButton *endTripBtn;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property(strong,nonatomic)NSString * rideID;
@property(strong,nonatomic)NSString * currencyCodeAndAmount;
- (IBAction)didClickLocationBtn:(id)sender;
- (IBAction)didClickDropTimeBtn:(id)sender;
- (IBAction)didClickWaitTimeBtn:(id)sender;
- (IBAction)didClickEndTrip:(id)sender;


- (IBAction)didClickBackBtn:(id)sender;

@end
