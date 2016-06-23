//
//  PaymentWaitingViewController.h
//  DectarDriver
//
//  Created by Aravind Natarajan on 17/02/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseViewController.h"
#import "DectarCustomColor.h"
#import "ReceiveCashViewController.h"
#import "RiderRecords.h"
#import "RatingsViewController.h"

@interface PaymentWaitingViewController : RootBaseViewController<UIAlertViewDelegate>
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *waitLbl;
@property (weak, nonatomic) IBOutlet UILabel *messageLbl;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UILabel *hint_lbl;


@property(strong,nonatomic)NSString * rideIdPay;
- (IBAction)didClickBackBtn:(id)sender;
- (IBAction)didClickCheckStatusBtn:(id)sender;

@end
