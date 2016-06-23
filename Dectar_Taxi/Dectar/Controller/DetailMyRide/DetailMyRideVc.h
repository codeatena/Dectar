//
//  DetailMyRideVc.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/26/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRideRecord.h"
#import <GoogleMaps/GoogleMaps.h>
#import "RootBaseVC.h"


@interface DetailMyRideVc : RootBaseVC
@property (strong, nonatomic) IBOutlet UILabel *CarDetailsLabel;
@property (strong, nonatomic) IBOutlet UILabel *RideIDlabel;
@property (strong, nonatomic) IBOutlet UILabel *StatusLabl;
@property (strong, nonatomic) IBOutlet UIView *mapBGView;
@property (strong, nonatomic) IBOutlet UILabel *Addresslabel;
@property (strong, nonatomic) IBOutlet UILabel *dateandtime_label;
@property (strong, nonatomic) IBOutlet UILabel *distancelabel;
@property (strong, nonatomic) IBOutlet UILabel *durationlbl;
@property (strong, nonatomic) IBOutlet UILabel *waitinglbl;
@property (strong, nonatomic) IBOutlet UILabel *totalbill;
@property (strong, nonatomic) IBOutlet UILabel *totalpaid;
@property (strong, nonatomic) IBOutlet UIView *DetailsView;
@property (strong, nonatomic) IBOutlet UIButton *PayBTn;
@property (strong, nonatomic) IBOutlet UILabel *Drop_label;
@property (strong, nonatomic) IBOutlet UIButton *favourite;
@property (strong, nonatomic) IBOutlet UIScrollView *Scrolling;
@property (strong, nonatomic) IBOutlet UIButton *Mail_Btn;
@property (strong, nonatomic) IBOutlet UIButton *Repprt_btn;

@property (strong,nonatomic) MyRideRecord* addressObj;
@property CGFloat Latitude;
@property CGFloat longitude;

@property CGFloat Drop_Latitude;
@property CGFloat Drop_longitude;
@property(strong ,nonatomic) GMSMapView * googlemap;
@property (strong ,nonatomic) GMSCameraPosition*camera;
@property (strong,nonatomic) NSString * StatusPay;

@property(strong,nonatomic)NSMutableArray * paymentArry;
@property(strong,nonatomic)IBOutlet UITableView * paymnetTabel;
@property(strong,nonatomic) IBOutlet UIButton * Submit;
@property(strong,nonatomic) IBOutlet UIView * paymentView;
@property (strong, nonatomic) IBOutlet UIWebView *PaymentWebView;
@property (strong, nonatomic) IBOutlet UIButton *cancel_btn;
@property (strong, nonatomic) IBOutlet UILabel *TitleView;
@property (strong, nonatomic) IBOutlet UIButton *TrackCab;
@property (weak, nonatomic) IBOutlet UILabel *Coupon_Label;
@property (weak, nonatomic) IBOutlet UILabel *Wallet_usage;
@property (strong, nonatomic) IBOutlet UIButton *shareMyRide_btn;

@property (strong, nonatomic)  NSString *Status_Track;
@property (strong, nonatomic)  NSString *Status_Favour;
@property (strong, nonatomic) IBOutlet UIView *AddindTip_View;
@property (strong, nonatomic) IBOutlet UIView *RemoveTip_View;
@property (strong, nonatomic) IBOutlet UILabel *AmountTip_lbl;
@property (strong, nonatomic) IBOutlet UIButton *remove_btn;
@property (strong, nonatomic) IBOutlet UITextField *Amount_txtFld;
@property (strong, nonatomic) IBOutlet UIButton *Apply_tip;
@property (weak, nonatomic) IBOutlet UILabel *TipsAmount_lbl;

@property (strong, nonatomic) IBOutlet UIButton *PanicBtn;
@property (strong, nonatomic) IBOutlet UIView *Option_View;

@property (strong, nonatomic) IBOutlet UILabel *heading;

@property (strong, nonatomic) IBOutlet UILabel *hint_ride_distance;
@property (strong, nonatomic) IBOutlet UILabel *hint_time_taken;
@property (strong, nonatomic) IBOutlet UILabel *hint_wait_time;
@property (strong, nonatomic) IBOutlet UILabel *hint_totalbill;
@property (strong, nonatomic) IBOutlet UILabel *hint_totaloaid;

@end
