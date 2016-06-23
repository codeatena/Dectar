//
//  RideUserViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/25/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RootBaseViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "RiderRecords.h"
#import "ASIHTTPRequest.h"
#import "TripViewController.h"
#import "InfoViewController.h"
#import "RootBaseViewController.h"
//Open Maps
#import "OpenInGoogleMapsController.h"
#import "Enums.h"
#import "MapRequestModel.h"
#import "FBShimmeringView.h"
#import "GlowButton.h"

@interface RideUserViewController : RootBaseViewController<GMSMapViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,SlideButtonDelegat>{
 CLLocation *location;
 CLLocation * oldLocationDriver;
    CLLocation * startLocationDriver;
    
}

@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;

@property(strong,nonatomic)NSMutableArray * points;
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(strong,nonatomic)GMSCameraPosition * Camera;
@property(strong,nonatomic)GMSMapView * GoogleMap;
@property(strong,nonatomic)RiderRecords * objRiderRecords;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UIView *buttonContentView;
@property (weak, nonatomic) IBOutlet GlowButton *arrivedBtn;

@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UIButton *optionBtn;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *riderNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIButton *userImageView;
@property(assign,nonatomic) float riderLattitude;
@property(assign,nonatomic) float riderLongitude;
@property(assign,nonatomic)BOOL isFirstUpdateLoc;
@property(assign,nonatomic)NSInteger isDriverDeviatesStatusNum;
@property(strong,nonatomic)GMSMarker *marker3;
@property (weak, nonatomic) IBOutlet UIButton *openInMapsBtn;
@property(strong,nonatomic)NSMutableArray * wayArray;
@property(strong,nonatomic)NSTimer * locTimer;
@property(assign,nonatomic) BOOL isMapZoomed;

- (IBAction)didClickRefreshBtn:(id)sender;
- (IBAction)didClickCallBtn:(id)sender;
- (IBAction)didClickArrivedBtn:(id)sender;
- (IBAction)didClickOptionBtn:(id)sender;
@end
