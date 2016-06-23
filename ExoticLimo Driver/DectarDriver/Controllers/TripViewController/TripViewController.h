//
//  TripViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/26/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"
#import "Constant.h"
#import "UrlHandler.h"
#import <CoreLocation/CoreLocation.h>
#import "DectarCustomColor.h"
#import "RiderRecords.h"
#import <GoogleMaps/GoogleMaps.h>
#import "RTSpinKitView.h"
#import "CancelRideViewController.h"
#import "PSLocationManager.h"
#import "FareSummaryViewController.h"
#import "FareRecords.h"
#import "CashOTPViewController.h"
#import "ReceiveCashViewController.h"
#import "RatingsViewController.h"
#import "RootBaseViewController.h"
#import "HomeViewController.h"
#import "MZTimerLabel.h"
#import "RCounter.h"
#import "RatingsViewController.h"
#import "FBShimmeringView.h"
#import "GlowButton.h"
#import "DropLocationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PaymentWaitingViewController.h"


@interface TripViewController : RootBaseViewController<CLLocationManagerDelegate,GMSMapViewDelegate,PSLocationManagerDelegate,UIAlertViewDelegate,MZTimerLabelDelegate,SlideButtonDelegat>{
    CLLocation *location;
     CLLocation *initialLocation;
    CLLocation * oldLocationDriver;
    CLLocation * previousLocationDriver;
   MZTimerLabel *timerWaitLabel;
    CLLocation *dropSelLocation;
   
}
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property(strong,nonatomic)NSMutableArray * points;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
@property(strong,nonatomic)GMSCameraPosition * Camera;
@property(strong,nonatomic)GMSMapView * GoogleMap;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UIButton *cancelTripBtn;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet GlowButton *rideBtn;

@property (weak, nonatomic) IBOutlet UILabel *dropLocLbl;
@property(assign,nonatomic)BOOL isMapLoaded;
@property(assign,nonatomic)CLLocationDistance totalDistance;
@property(strong,nonatomic)NSString * currencyCodeAndAmount;
@property(assign,nonatomic)BOOL isForFareController;
@property(strong,nonatomic)RiderRecords * objRiderRecs;
@property (weak, nonatomic) IBOutlet UILabel *rideIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *riderNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIImageView *riderImageView;
@property (weak, nonatomic) IBOutlet UIButton *waitBtn;
@property (weak, nonatomic) IBOutlet UILabel *waitTextLbl;
@property (weak, nonatomic) IBOutlet UIView *meterView;
@property(strong,nonatomic)GMSMarker *marker;
@property(strong,nonatomic)GMSMarker *destMarker;
@property(strong,nonatomic)GMSMarker *startMarker;
@property(strong,nonatomic)NSTimer * locTimers;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIView *selectDropView;
@property(assign,nonatomic) BOOL isMapZoomed;
- (IBAction)didClickRefreshBtn:(id)sender;

- (IBAction)didClickPhone:(id)sender;
- (IBAction)didClickWaitBtn:(id)sender;
- (IBAction)didClickDropLocationBtn:(id)sender;


- (IBAction)didClickRideOptionBtn:(id)sender;
- (IBAction)didClickCancelTripBtn:(id)sender;
@end
