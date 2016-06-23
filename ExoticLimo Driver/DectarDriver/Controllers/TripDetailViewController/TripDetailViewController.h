//
//  TripDetailViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/28/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "RTSpinKitView.h"
#import "UrlHandler.h"
#import "Theme.h"
#import "RootBaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "EndTripViewController.h"
#import "FareSummaryViewController.h"
@interface TripDetailViewController : RootBaseViewController<GMSMapViewDelegate,CLLocationManagerDelegate>{
     CLLocation *location;
}
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
@property (weak, nonatomic) IBOutlet UIScrollView *tripDeatilScrollView;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property(strong,nonatomic)GMSCameraPosition * Camera;
@property(strong,nonatomic)GMSMapView * GoogleMap;
@property(strong,nonatomic)NSString * rideId;
@property(strong,nonatomic)NSString * rideOption;
@property(strong,nonatomic)NSString * needCash;
@property (weak, nonatomic) IBOutlet UIView *mapview;
@property (weak, nonatomic) IBOutlet UIView *basicView;
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
@property (weak, nonatomic) IBOutlet UILabel *timerLbl;
@property(strong,nonatomic)NSString * tripId;
@property(assign,nonatomic)float lattitude;
@property(assign,nonatomic)float longitude;
@property (weak, nonatomic) IBOutlet UILabel *rideDistLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeTakenLbl;
@property (weak, nonatomic) IBOutlet UILabel *waitTimeLbl;
@property (weak, nonatomic) IBOutlet UIView *completedView;
@property (weak, nonatomic) IBOutlet UILabel *rideHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *waitHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalBillHeader;
@property (weak, nonatomic) IBOutlet UILabel *paidBillHeader;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *totslPaidLbl;
@property (weak, nonatomic) IBOutlet UIButton *cancelRideBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UILabel *paymentLbl;
@property (weak, nonatomic) IBOutlet UIView *continueRideView;
@property (weak, nonatomic) IBOutlet UIButton *continueRideBtn;
@property (weak, nonatomic) IBOutlet UILabel *walletLbl;
@property (assign, nonatomic) BOOL isLocUpdated;
@property (weak, nonatomic) IBOutlet UIView *paymentView;
- (IBAction)didClickReceiveCashBtn:(id)sender;
- (IBAction)didClickreceivePaymentBtn:(id)sender;


- (IBAction)didClickContinueRideBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *tipsLbl;

@property (weak, nonatomic) IBOutlet UIView *cancelView;
- (IBAction)didClickCancelRideBtn:(id)sender;


- (IBAction)didClickBackBtn:(id)sender;

@end
