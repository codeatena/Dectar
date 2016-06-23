//
//  StarterViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/21/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Theme.h"
#import "DriverInfoRecords.h"

#import "DectarCustomColor.h"
#import "RootBaseViewController.h"
#import "UrlHandler.h"
#import "UIView+Toast.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import <MapKit/MapKit.h>
#import "TPFloatRatingView.h"
#import "OpenInMapsViewController.h"


@class RootBaseViewController;
@interface StarterViewController : RootBaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>{
    CLLocation *location;
}
+ (instancetype) controller;
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *userVehModelLbl;
@property (weak, nonatomic) IBOutlet UIButton *goOnlineBtn;
@property (weak, nonatomic) IBOutlet MKMapView *currentMapView;
@property (weak, nonatomic) IBOutlet UILabel *rateLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *starterScrollView;
@property (weak, nonatomic) IBOutlet UIView *tipsView;
@property (weak, nonatomic) IBOutlet UIView *lastTripView;
@property (weak, nonatomic) IBOutlet UIView *TodaysTotalView;
@property (weak, nonatomic) IBOutlet UILabel *tipsTripsLbl;
@property (weak, nonatomic) IBOutlet TPFloatRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *imgCircleLbl;

@property (assign, nonatomic) BOOL isLocUpdated;
@property (assign, nonatomic) BOOL hasPushNotification;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *catgLbl;

- (IBAction)didClickGoOnlineBtn:(id)sender;
- (IBAction)didClickMenuBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lastTripTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastTripVehModelLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastTripNerEarningsLbl;

@property (weak, nonatomic) IBOutlet UILabel *todaysOnlineLbl;
@property (weak, nonatomic) IBOutlet UILabel *todaysTripLbl;
@property (weak, nonatomic) IBOutlet UILabel *todaysEstimateLbl;
@property (weak, nonatomic) IBOutlet UILabel *tipsLbl;
@property(strong,nonatomic)NSString * currencyStr;

@property (weak, nonatomic) IBOutlet LabelThemeColor *lTripLbl;
@property (weak, nonatomic) IBOutlet UILabel *nEarningLbl;
@property (weak, nonatomic) IBOutlet LabelThemeColor *tEarningsLbl;
@property (weak, nonatomic) IBOutlet UILabel *eNetLbl;
@property (weak, nonatomic) IBOutlet LabelThemeColor *tTipsLbl;
@property (weak, nonatomic) IBOutlet UILabel *tLbl;
@property(strong,nonatomic) NSTimer * refreshTimer;
@property (assign, nonatomic) BOOL isRefreshTimerActive;


@end
