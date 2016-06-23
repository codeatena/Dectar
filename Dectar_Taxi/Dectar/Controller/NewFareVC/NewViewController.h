//
//  NewViewController.h
//  Dectar
//
//  Created by Aravind Natarajan on 12/21/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FareRecord.h"
#import "RootBaseVC.h"
#import "CustomButton.h"

@interface NewViewController : RootBaseVC

@property (strong, nonatomic) IBOutlet UIView *mapBGView;
@property (strong, nonatomic) IBOutlet UILabel *heading;
@property (strong, nonatomic) IBOutlet UIScrollView *scrolling;
@property (strong, nonatomic) IBOutlet UIView *driverImage;
@property (strong, nonatomic) IBOutlet UILabel *driverName;
@property (strong, nonatomic) IBOutlet UILabel *contact;
@property (strong, nonatomic) IBOutlet UILabel *title_Basefare;
@property (strong, nonatomic) IBOutlet UILabel *title_servicetax;
@property (strong, nonatomic) IBOutlet UILabel *title_sub_total;
@property (strong, nonatomic) IBOutlet UILabel *title_amount;
@property (strong, nonatomic) IBOutlet UILabel *hint_tipadriver;

@property (strong, nonatomic) IBOutlet UILabel *cab;
@property (strong, nonatomic) IBOutlet UILabel *cab_type;

@property (strong, nonatomic) IBOutlet UILabel *date;

@property (strong, nonatomic) IBOutlet UIButton *makePayMent;

@property (strong, nonatomic) IBOutlet UILabel *totalAmount;
@property (strong, nonatomic) IBOutlet UILabel *rideminutes;
@property (strong, nonatomic) IBOutlet UILabel *miniutesAmount;

@property (strong, nonatomic) IBOutlet UILabel *rideDistance;
@property (strong, nonatomic) IBOutlet UILabel *distanceAmount;
@property (strong, nonatomic) IBOutlet UILabel *basefare;

@property (strong, nonatomic) IBOutlet UIView *addView;
@property (strong, nonatomic) IBOutlet UIView *reoveTip;
@property (strong, nonatomic) IBOutlet UITextField *amount_fld;
@property (strong, nonatomic) IBOutlet UIButton *add_btn;

@property (strong, nonatomic) IBOutlet UIButton *tipsView_btn;
@property (strong, nonatomic) IBOutlet UIButton *remove_btn;
@property (strong, nonatomic) IBOutlet UILabel *added_lbl;

@property (strong, nonatomic) IBOutlet UILabel *FulTotal_Amount;

@property (strong, nonatomic) IBOutlet UILabel *HeadingTips_Amount;
@property (strong, nonatomic) IBOutlet UILabel *title_tips;

@property (strong, nonatomic) IBOutlet UILabel *coupon_amount;
@property (strong, nonatomic) IBOutlet UILabel *service_Amount;
@property (strong, nonatomic) IBOutlet UILabel *title_coupon;

@property (strong, nonatomic) IBOutlet UIView *driver_View;

@property (strong, nonatomic) FareRecord * ObjRc;
@property (strong, nonatomic) IBOutlet UIImageView *image_driver;
@property (strong, nonatomic) IBOutlet UIButton *goBack;

@property (weak, nonatomic) IBOutlet CustomButton *retryButton;
- (IBAction)didClickRetry:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *retryView;
@property (strong, nonatomic) IBOutlet UILabel *hint_processing;
@property (strong, nonatomic) IBOutlet UILabel *wait;

@end
