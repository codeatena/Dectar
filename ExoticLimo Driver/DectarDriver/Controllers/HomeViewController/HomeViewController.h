//
//  HomeViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/24/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "UrlHandler.h"
#import "RideAcceptViewController.h"
#import "RideAcceptRecord.h"
#import "RootBaseViewController.h"
#import "TripDetailViewController.h"
#import "NewJobViewController.h"

@interface HomeViewController : RootBaseViewController<GMSMapViewDelegate,CLLocationManagerDelegate>{
  CLLocation *location;  
 CLLocation *Newlocation;
}
@property(strong,nonatomic)NSString * ReservedJobId;
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
@property(strong,nonatomic)RTSpinKitView * custIndicatorViewUrl;
- (IBAction)didClickGoOfflineBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property(strong,nonatomic)GMSCameraPosition * Camera;
@property(strong,nonatomic)GMSMapView * GoogleMap;
@property(strong,nonatomic)GMSMarker *marker;
@property(assign,nonatomic)float lattitude;
@property(assign,nonatomic)float longitude;
- (IBAction)didClickUpdateLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *DriverNameHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *pendingLbl;
@property (weak, nonatomic) IBOutlet UIButton *goOffLineBtn;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property(strong,nonatomic)NSString * tripId;//VehicleNumber
@property(strong,nonatomic)NSString * VehicleNumber;
@property(strong,nonatomic) NSTimer * refreshTimer;
@property(assign,nonatomic) BOOL isMapZoomed;
@property(assign,nonatomic) BOOL isnotVerified;
@end
