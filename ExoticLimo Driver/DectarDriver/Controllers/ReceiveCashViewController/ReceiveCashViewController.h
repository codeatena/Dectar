//
//  ReceiveCashViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/2/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripViewController.h"
#import "UrlHandler.h"
#import "Constant.h"
#import "HomeViewController.h"
#import "RatingsViewController.h"
#import "RootBaseViewController.h"

@interface ReceiveCashViewController : RootBaseViewController
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *receiveCashHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *fareLbl;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property(strong,nonatomic)NSString * fareAmt;
@property(strong,nonatomic)NSString * RideId;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *textLbl;


- (IBAction)didClickReceiveBtn:(id)sender;
- (IBAction)didClickBackBtn:(id)sender;

@end
