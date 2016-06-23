//
//  TripViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/26/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "TripViewController.h"

@interface TripViewController ()<moveToNectVCFromFareSummary,DropLocDelegate>{
     FareSummaryViewController *controller;
     NSTimer *myTimerName;
     long second;
     RCounter *counter;
    int zoompoint;
    GMSPath *pathDrawn;
    GMSPolyline *singleLine;
    
    
}

@end

@implementation TripViewController{
    FBShimmeringView *_shimmeringView;
}

@synthesize headerLbl,cancelTripBtn,mapView,bottomView,rideBtn,objRiderRecs,Camera,
GoogleMap,custIndicatorView,isMapLoaded,totalDistance,currencyCodeAndAmount,isForFareController,marker,rideIdLbl,riderNameLbl,phoneBtn,riderImageView,waitBtn,waitTextLbl,meterView,locTimers,selectDropView,destMarker,startMarker,refreshBtn,isMapZoomed,dropLocLbl;


- (void)viewDidLoad {
    isForFareController=NO;
    zoompoint=15;
    marker=[[GMSMarker alloc]init];
    destMarker=[[GMSMarker alloc]init];
     startMarker=[[GMSMarker alloc]init];
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kDriverCashPaymentNotif
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kDriverPaymentCompletedNotif
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kUserCancelledDrive
                                               object:nil];
    totalDistance=0;
    self.points=[[NSMutableArray alloc]init];
    [self setFontAndColor];
    [self setGlowBtn];
    [self setDatas];
    
    isMapLoaded=NO;
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self showActivityIndicator:YES];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
        
        //[CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways
        ) {
        // Will open an confirm dialog to get user's approval
        [_locationManager requestWhenInUseAuthorization];
        //[_locationManager requestAlwaysAuthorization];
    } else {
        [_locationManager startUpdatingLocation]; //Will update location immediately
    }
    waitTextLbl.hidden=YES;
    locTimers = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                target:self
                                              selector:@selector(updateLocUsingTimerOnRide)
                                              userInfo:nil
                                               repeats:YES];
    
    if([objRiderRecs.hasDropLocation isEqualToString:@"1"]){
         [self showAddressOrEnterAddress:YES];
       // float lat1 = [objRiderRecs.dropLat floatValue];
      //  float lon1 = [objRiderRecs.dropLong floatValue];
        
         dropSelLocation =  [[CLLocation alloc] initWithLatitude:[objRiderRecs.dropLat doubleValue] longitude:[objRiderRecs.dropLong doubleValue]];
    }else{
         [self showAddressOrEnterAddress:NO];
    }
   
    
    selectDropView.layer.masksToBounds = NO;
    selectDropView.layer.shadowOffset = CGSizeMake(-15, 20);
    selectDropView.layer.shadowRadius = 5;
    selectDropView.layer.shadowOpacity = 0.5;
    

}
-(void)showAddressOrEnterAddress:(BOOL)isAddress{
    if(isAddress==YES){
        self.addressView.hidden=NO;
        self.selectDropView.hidden=YES;
        rideBtn.hidden=NO;
        refreshBtn.hidden=NO;
        GoogleMap.frame=CGRectMake(0,0, mapView.frame.size.width, self.view.frame.size.height-(_addressView.frame.size.height+70));
        mapView.frame=CGRectMake(mapView.frame.origin.x, _addressView.frame.origin.y+_addressView.frame.size.height, mapView.frame.size.width, self.view.frame.size.height-(_addressView.frame.size.height+70));
        
    }else{
        self.addressView.hidden=YES;
        self.selectDropView.hidden=NO;
        rideBtn.hidden=YES;
        refreshBtn.hidden=YES;
        GoogleMap.frame=CGRectMake(mapView.frame.origin.x, _addressView.frame.origin.y, mapView.frame.size.width, self.view.frame.size.height-70);
        mapView.frame=CGRectMake(mapView.frame.origin.x, _addressView.frame.origin.y, mapView.frame.size.width, self.view.frame.size.height-70);
        
    }
    [mapView addSubview:GoogleMap];
}
-(void)updateLocUsingTimerOnRide{
    if(location!=nil){
          [self updateLoc:location];
    }
    
}
-(void)setGlowBtn{
    _shimmeringView = [[FBShimmeringView alloc] init];
    _shimmeringView.shimmering = YES;
    _shimmeringView.shimmeringBeginFadeDuration = 0.2;
    _shimmeringView.shimmeringOpacity = 1;
    [self.view addSubview:_shimmeringView];
    
    rideBtn.delegate=self;
    
    _shimmeringView.contentView = rideBtn;
    CGRect shimmeringFrame = rideBtn.frame;
    shimmeringFrame.origin.y= self.view.frame.size.height-70;
    shimmeringFrame.origin.x= 22;
    shimmeringFrame.size.height=50;
    shimmeringFrame.size.width=self.view.frame.size.width-44;
    _shimmeringView.frame = shimmeringFrame;
}
-(void)viewDidDisappear:(BOOL)animated{
    [self stopActivityIndicator];
    
}
-(void)setFontAndColor{
   // rideBtn=[Theme setBoldFontForButton:rideBtn];
   // [rideBtn setBackgroundColor:SetBlueColor];
    //rideBtn.layer.cornerRadius=2;
   // rideBtn.layer.masksToBounds=YES;
    headerLbl=[Theme setHeaderFontForLabel:headerLbl];
    [headerLbl setText:JJLocalizedString(@"Current_Ride", nil)];
    [dropLocLbl setText:JJLocalizedString(@"please_enter_drop_location_to_start_the_trip", nil)];
    riderImageView.layer.cornerRadius=riderImageView.frame.size.width/2;
    riderImageView.layer.masksToBounds=YES;
    phoneBtn=[Theme setBoldFontForButton:phoneBtn];
    rideIdLbl=[Theme setNormalFontForLabel:rideIdLbl];
    riderNameLbl=[Theme setNormalFontForLabel:riderNameLbl];
    
    [waitBtn setTitle:JJLocalizedString(@"Start_Wait", nil) forState:UIControlStateNormal];
    waitBtn=[Theme setNormalFontForButton:waitBtn];
     waitTextLbl=[Theme setLargeBoldFontForLabel:waitTextLbl];
}
- (void)receiveNotification:(NSNotification *) notification
{
    NSDictionary * dict=notification.userInfo;
    if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[dict objectForKey:@"action"]]] isEqualToString:@"receive_cash"]){
        [self stopActivityIndicator];
        if(self.view.window){
            ReceiveCashViewController * objReceiveCashVC=[self.storyboard  instantiateViewControllerWithIdentifier:@"ReceiveCashVCSID"];
            [objReceiveCashVC setRideId:objRiderRecs.RideId];
            
            NSString * str=[NSString stringWithFormat:@"%@ %@",[Theme checkNullValue:[Theme findCurrencySymbolByCode:[dict objectForKey:@"key4"]]],[Theme checkNullValue:[dict objectForKey:@"key3"]]];
            [objReceiveCashVC setFareAmt:str];
            [self.navigationController pushViewController:objReceiveCashVC animated:YES];
        }
    }
    if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[dict objectForKey:@"action"]]] isEqualToString:@"payment_paid"]){
        [self stopActivityIndicator];
        if(self.view.window){
            [self.view makeToast:@"Payment_Received"];
            [self performSelector:@selector(moveToHome) withObject:self afterDelay:0];
        }
    }
    if(self.view.window){
        if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[dict objectForKey:@"action"]]] isEqualToString:@"ride_cancelled"]){
            NSString *ridercancrelled=JJLocalizedString(@"Rider_Cancelled_the_ride", nil);
            
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Sorry !!" message:ridercancrelled delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag=103;
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(alertView.tag==103){
        BOOL isHome=NO;
        BOOL isRootSkip=NO;
        for (UIViewController *controller1 in self.navigationController.viewControllers) {
            
            if ([controller1 isKindOfClass:[HomeViewController class]]) {
                
                [self.navigationController popToViewController:controller1
                                                      animated:YES];
                isHome=YES;
                isRootSkip=YES;
                
                break;
            }
        }
        if(isHome==NO){
            for (UIViewController *controller1 in self.navigationController.viewControllers) {
                
                if ([controller1 isKindOfClass:[StarterViewController class]]) {
                    
                    [self.navigationController popToViewController:controller1
                                                          animated:YES];
                    isRootSkip=YES;
                    break;
                }
            }
        }
        if(isRootSkip==NO){
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }
    else if (alertView.tag==102){
        
        if (buttonIndex==[alertView cancelButtonIndex]) {
            
        }else {
            [self drawRoadRouteBetweenTwoPoints:location];
        }
        
    }
}

-(void)moveToHome{
    RatingsViewController * objRatingsVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingsVCSID"];
    [objRatingsVc setRideid:objRiderRecs.RideId];
    [self.navigationController pushViewController:objRatingsVc animated:YES];
//    for (UIViewController *controller1 in self.navigationController.viewControllers) {
//        
//        if ([controller1 isKindOfClass:[HomeViewController class]]) {
//            
//            [self.navigationController popToViewController:controller1
//                                                  animated:YES];
//            break;
//        }
//    }
}
-(void)dealloc{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_locationManager stopUpdatingLocation];
    if (_locationManager)
    {
        _locationManager = nil;
    }
}
-(void)setDatas{
    NSString * rideid=JJLocalizedString(@"RideId", nil);
    
    rideIdLbl.text=[NSString stringWithFormat:@"%@ : %@",rideid,objRiderRecs.RideId];
    riderNameLbl.text=objRiderRecs.userName;
    [phoneBtn setTitle:objRiderRecs.userPhoneNumber forState:UIControlStateNormal];
    phoneBtn.imageEdgeInsets = UIEdgeInsetsMake(0., phoneBtn.frame.size.width - (20 + 15.), 0., 0.);
    phoneBtn.titleEdgeInsets = UIEdgeInsetsMake(0., 0., 0., 0);

    [riderImageView sd_setImageWithURL:[NSURL URLWithString:objRiderRecs.userImage] placeholderImage:[UIImage imageNamed:@"PlaceHolderImg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    [rideBtn setTitle:JJLocalizedString(@"SLIDE_TO_BEGIN_TRIP", nil) forState:UIControlStateNormal];
}
- (IBAction)didClickRideOptionBtn:(id)sender{
  //  UIButton * btn=sender;
    
    
}
- (void) slideActive{
    if([rideBtn.currentTitle isEqualToString:JJLocalizedString(@"SLIDE_TO_BEGIN_TRIP", nil)]){
        
        oldLocationDriver=location;
        [self beginTrip];
        // [self.view makeToast:@"started distance"];
        [[PSLocationManager sharedLocationManager] prepLocationUpdates];
        [[PSLocationManager sharedLocationManager] startLocationUpdates];
        [_locationManager startUpdatingLocation];
    }else if ([rideBtn.currentTitle isEqualToString:JJLocalizedString(@"SLIDE_TO_END_TRIP", nil)]){
        [timerWaitLabel pause];
        
        [waitBtn setTitle:JJLocalizedString(@"Start_Wait", nil) forState:UIControlStateNormal];
        [[PSLocationManager sharedLocationManager] stopLocationUpdates];
        [self EndTrip];
        [self performSelector:@selector(enableRideBtn) withObject:nil afterDelay:30];
    }
}
-(void)beginTrip{
     if(location.coordinate.latitude!=0){
         isForFareController=NO;
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web DriverStartedRide:[self setParametersDriverBeginRide]
                   success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
//             counter = [[RCounter alloc] initWithFrame:CGRectMake(0, 0, 160, 70) andNumberOfDigits:3];
//             [meterView addSubview:counter];
//             meterView.hidden=NO;
             [rideBtn setTitle:JJLocalizedString(@"SLIDE_TO_END_TRIP", nil) forState:UIControlStateNormal];
             [rideBtn setBackgroundColor:setRedColor];
             waitBtn.hidden=NO;
             cancelTripBtn.hidden=YES;
         }else{
             
             [self.view makeToast:kErrorMessage];
         }
     }
                   failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [self.view makeToast:kErrorMessage];
         
     }];
     }
}
-(NSDictionary *)setParametersDriverBeginRide{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSString * latitude=@"";
    NSString * longitude=@"";
    NSString * droplatitude=@"";
    NSString * droplongitude=@"";
    if(location.coordinate.latitude!=0){
        latitude=[Theme checkNullValue:[NSString stringWithFormat:@"%f",location.coordinate.latitude]];
        longitude=[Theme checkNullValue:[NSString stringWithFormat:@"%f",location.coordinate.longitude]];
         droplatitude=[Theme checkNullValue:[NSString stringWithFormat:@"%f",dropSelLocation.coordinate.latitude]];
         droplongitude=[Theme checkNullValue:[NSString stringWithFormat:@"%f",dropSelLocation.coordinate.longitude]];
        
    }
  
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"ride_id":objRiderRecs.RideId,
                                  @"pickup_lat":latitude,
                                  @"pickup_lon":longitude,
                                  @"drop_lat":droplatitude,
                                  @"drop_lon":droplongitude
                                  };
    return dictForuser;
}

-(void)enableRideBtn{
    rideBtn.userInteractionEnabled=YES;
}
-(void)EndTrip{
    if(location.coordinate.latitude!=0){
        rideBtn.userInteractionEnabled=NO;
        isForFareController=NO;
        [self showActivityIndicator:YES];
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [web DriverEndRide:[self setParametersDriverEndRide]
                       success:^(NSMutableDictionary *responseDictionary)
         {
             
             [self stopActivityIndicator];
             if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
                 waitBtn.hidden=YES;
                 waitTextLbl.hidden=YES;
                 [self.view makeToast:@"Ride_Finished"];
                 NSDictionary * summaryDict=responseDictionary[@"response"][@"fare_details"];
                 FareRecords * objFareRecrds=[[FareRecords alloc]init];
                 objFareRecrds.currency=[Theme findCurrencySymbolByCode:[Theme checkNullValue:[summaryDict objectForKey:@"currency"]]];
                 
                 objFareRecrds.rideDistance=[Theme checkNullValue:[summaryDict objectForKey:@"ride_distance"]];
                 objFareRecrds.rideDuration=[Theme checkNullValue:[summaryDict objectForKey:@"ride_duration"]];
                 objFareRecrds.rideFare=[Theme checkNullValue:[NSString stringWithFormat:@"%.02f",[[summaryDict objectForKey:@"ride_fare"] floatValue]]];
                  objFareRecrds.waitingDuration=[Theme checkNullValue:[summaryDict objectForKey:@"waiting_duration"]];
                 objFareRecrds.needPayment=[Theme checkNullValue:[summaryDict objectForKey:@"need_payment"]];
                 
                 objFareRecrds.needCash = [Theme checkNullValue:[responseDictionary[@"response"] objectForKey:@"receive_cash"]];
                 
                 currencyCodeAndAmount=[NSString stringWithFormat:@"%@ %@",objFareRecrds.currency,objFareRecrds.rideFare];
                controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FareSummaryVCSID"];
                 //controller.view.frame=self.view.frame;
                 controller.objFareRecs=[[FareRecords alloc]init];
                 [controller setObjFareRecs:objFareRecrds];
                 controller.delegate=self;
                 [controller presentInParentViewController:self];
                 [_locationManager stopUpdatingLocation];
                 [locTimers invalidate];
                 locTimers=nil;
                 
             }else{
                 rideBtn.userInteractionEnabled=YES;
                 [self.view makeToast:kErrorMessage];
             }
         }
                       failure:^(NSError *error)
         {
             rideBtn.userInteractionEnabled=YES;
             [self stopActivityIndicator];
             [self.view makeToast:kErrorMessage];
             
         }];
    }
}
-(NSDictionary *)setParametersDriverEndRide{
    NSString * driverId=@"";
    NSString * totalDistanceStr=[Theme checkNullValue:[self stringWithDouble:totalDistance/1000]];
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSString * latitude=@"";
    NSString * longitude=@"";
    if(location.coordinate.latitude!=0){
        latitude=[Theme checkNullValue:[NSString stringWithFormat:@"%f",location.coordinate.latitude]];
        longitude=[Theme checkNullValue:[NSString stringWithFormat:@"%f",location.coordinate.longitude]];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"ride_id":objRiderRecs.RideId,
                                  @"drop_lat":latitude,
                                  @"drop_lon":longitude,
                                  @"distance":totalDistanceStr,
                                  @"wait_time":[Theme checkNullValue:waitTextLbl.text]
                                  };
    return dictForuser;
}
- (IBAction)didClickCancelTripBtn:(id)sender{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    CancelRideViewController * objCancelVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CancelVCSID"];
    [objCancelVC setRideId:objRiderRecs.RideId];
    [self.navigationController pushViewController:objCancelVC animated:YES];
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            //   NSLog(@"User still thinking..");
        } break;
        case kCLAuthorizationStatusDenied: {
            // NSLog(@"User hates you");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [_locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    location = [locations lastObject];
    if(location.coordinate.latitude!=0){
        if(isMapLoaded==NO){
            [PSLocationManager sharedLocationManager].delegate = self;
           [self loadGoogleMap:location];
        }
       
        [self locationManagerUpdate:manager didUpdateToLocation:location fromLocation:oldLocationDriver];
       
    }
    // NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
}
- (void)locationManagerUpdate:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
  
    oldLocationDriver=newLocation;
    if (isMapZoomed==NO) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                                longitude:newLocation.coordinate.longitude
                                                                     zoom:zoompoint];
        [GoogleMap animateToCameraPosition:camera];
    }
    
    marker.position = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    marker.icon = [UIImage imageNamed:@"cartopview"];
    NSString *yourhere=JJLocalizedString(@"You_are_Here", nil);
    marker.snippet = [NSString stringWithFormat:@"%@",yourhere];
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = GoogleMap;
    if(self.view.window){
        AppDelegate* appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [appdelegate xmppUpdateLoc:newLocation.coordinate withReceiver:objRiderRecs.UserId withRideId:objRiderRecs.RideId];
    }
}

-(void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition*)position {
    zoompoint=position.zoom;
    // handle you zoom related logic
}
-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    
    if(gesture==YES){
        isMapZoomed=YES;
    }else{
        isMapZoomed=NO;
    }
}
-(void)updateLoc:(CLLocation *)loc{
    
    
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web UpdateUserLocation:[self setParametersUpdateLocation:loc]
                    success:^(NSMutableDictionary *responseDictionary)
     {
         
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             
             
         }else{
             
             //  [self.view makeToast:kErrorMessage];
         }
     }
                    failure:^(NSError *error)
     {
         //  [self.view makeToast:kErrorMessage];
         
     }];
}
-(NSDictionary *)setParametersUpdateLocation:(CLLocation *)loc{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"latitude":[Theme checkNullValue:[NSString stringWithFormat:@"%f",loc.coordinate.latitude]],
                                  @"longitude":[Theme checkNullValue:[NSString stringWithFormat:@"%f",loc.coordinate.longitude]],
                                  @"ride_id":objRiderRecs.RideId
                                  };
    return dictForuser;
}

-(void)viewWillDisappear:(BOOL)animated{
    
   // [self.locationManager stopUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated{
   // [self.locationManager stopUpdatingLocation];
}



-(void)loadGoogleMap:(CLLocation *)loc{
    [self stopActivityIndicator];
    isMapLoaded=YES;
    if(TARGET_IPHONE_SIMULATOR)
    {
        Camera = [GMSCameraPosition cameraWithLatitude:13.0827
                                             longitude:80.2707
                                                  zoom:15];
    }else{
        Camera = [GMSCameraPosition cameraWithLatitude:loc.coordinate.latitude
                                             longitude:loc.coordinate.longitude
                                                  zoom:zoompoint];
    }
    initialLocation=loc;
    GoogleMap = [GMSMapView mapWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height) camera:Camera];
    startMarker.position = Camera.target;
    
    startMarker.icon = [UIImage imageNamed:@"StartingPin"];
    NSString * Starting_locetion=JJLocalizedString(@"Starting_Location", nil);
    
    startMarker.snippet = [NSString stringWithFormat:@"%@",Starting_locetion];
    startMarker.appearAnimation = kGMSMarkerAnimationPop;
    startMarker.map = GoogleMap;
    
   
    
    GoogleMap.userInteractionEnabled=YES;
    GoogleMap.delegate = self;
    [mapView addSubview:GoogleMap];
    
    if([objRiderRecs.hasDropLocation isEqualToString:@"1"]){
//        float lat1 = [objRiderRecs.dropLat floatValue];
//        float lon1 = [objRiderRecs.dropLong floatValue];
        destMarker.position=CLLocationCoordinate2DMake( [objRiderRecs.dropLat doubleValue],[objRiderRecs.dropLong doubleValue]);
        destMarker.snippet = [NSString stringWithFormat:@"Destination Location"];
        destMarker.icon = [UIImage imageNamed:@"DestinationPin"];
        destMarker.appearAnimation = kGMSMarkerAnimationPop;
        destMarker.map = GoogleMap;
        CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:[objRiderRecs.dropLat doubleValue] longitude:[objRiderRecs.dropLong doubleValue]];
        [self drawRoadRouteBetweenTwoPoints:LocationAtual];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showActivityIndicator:(BOOL)isShow{
    if(isShow==YES){
        if(custIndicatorView==nil){
            custIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStylePulse color:SetThemeColor];
            
        }
        if(isForFareController==YES){
             custIndicatorView.center =controller.view.center;
        }else{
             custIndicatorView.center =self.view.center;
        }
       
        [custIndicatorView startAnimating];
        [self.view addSubview:custIndicatorView];
        [self.view bringSubviewToFront:custIndicatorView];
    }
}
-(void)stopActivityIndicator{
    [custIndicatorView stopAnimating];
    custIndicatorView=nil;
}
#pragma mark PSLocationManagerDelegate

- (void)locationManager:(PSLocationManager *)locationManager signalStrengthChanged:(PSLocationManagerGPSSignalStrength)signalStrength {
    
    if (signalStrength == PSLocationManagerGPSSignalStrengthWeak) {
        [self.view makeToast:@"Signal_is_too_weak"];
    } else if (signalStrength == PSLocationManagerGPSSignalStrengthStrong) {
      //  [self.view makeToast:@"Strong"];
    } else {
       //  [self.view makeToast:@"....."];
    }
    
  // [self.view makeToast:strengthText];
}

- (void)locationManagerSignalConsistentlyWeak:(PSLocationManager *)locationManager {
     [self.view makeToast:@"Signal_is_Consistently_Weak"];
}

- (void)locationManager:(PSLocationManager *)locationManager distanceUpdated:(CLLocationDistance)distance {
    totalDistance=distance;
    
    //[counter updateCounter:totalDistance animate:YES];
   //  [self.view makeToast:[NSString stringWithFormat:@"%.2f", distance]];
}
- (void)locationManager:(PSLocationManager *)locationManager waypoint:(CLLocation *)waypoint calculatedSpeed:(double)calculatedSpeed{
    // [self.view makeToast:[NSString stringWithFormat:@"%.2f", calculatedSpeed]];
}
- (void)locationManager:(PSLocationManager *)locationManager error:(NSError *)error {
    // location services is probably not enabled for the app
     [self.view makeToast:@"Unable_to_determine_location"];
}

- (NSString *)stringWithDouble:(double)value {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
}
-(void)moveToNextVc:(NSInteger )index{
    if(index==1){
        CashOTPViewController * objCashOtpController=[self.storyboard instantiateViewControllerWithIdentifier:@"CashOTPVCSID"];
        [objCashOtpController setRideId:objRiderRecs.RideId];
        [self.navigationController pushViewController:objCashOtpController animated:YES];
    }else if (index==0){
        [controller.view makeToast:@"Please_wait_until_transaction"];
        [self sendrequestForPayment];
    }else if (index==2){
        [self sendrequestForNoPayment];
    }
}

-(void)sendrequestForPayment{
    isForFareController=YES;
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web requestForPayment:[self setParametersForPaymentRequest]
        success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
           //  [controller.view makeToast:@"Please wait until transaction is complete. Don't minimize or go back"];
             PaymentWaitingViewController * objPayWait=[self.storyboard instantiateViewControllerWithIdentifier:@"PaymentWaitingVCSID"];
             [objPayWait setRideIdPay:objRiderRecs.RideId];
             [self.navigationController pushViewController:objPayWait animated:YES];
             
         }else{
             [self stopActivityIndicator];
             [controller.view makeToast:kErrorMessage];
         }
     }
        failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [controller.view makeToast:kErrorMessage];
         
     }];
}

-(void)sendrequestForNoPayment{
    
    isForFareController=YES;
    RatingsViewController * objRatingsVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingsVCSID"];
    [objRatingsVc setRideid:objRiderRecs.RideId];
    [self.navigationController pushViewController:objRatingsVc animated:YES];
//    [self showActivityIndicator:YES];
//    UrlHandler *web = [UrlHandler UrlsharedHandler];
//    [web NoNeedPayment:[self setParametersForPaymentRequest]
//                   success:^(NSMutableDictionary *responseDictionary)
//     {
//         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
//             RatingsViewController * objRatingsVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingsVCSID"];
//             [objRatingsVc setRideid:objRiderRecs.RideId];
//             [self.navigationController pushViewController:objRatingsVc animated:YES];
//         }else{
//             [self stopActivityIndicator];
//             [controller.view makeToast:kErrorMessage];
//         }
//     }
//                   failure:^(NSError *error)
//     {
//         [self stopActivityIndicator];
//         [controller.view makeToast:kErrorMessage];
//         
//     }];
}

-(NSDictionary *)setParametersForPaymentRequest{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"ride_id":objRiderRecs.RideId
                                  };
    return dictForuser;
}
- (IBAction)didClickRefreshBtn:(id)sender {
    isMapZoomed=NO;
  //  if(![rideBtn.currentTitle isEqualToString:@"SLIDE TO BEGIN TRIP"]){
        [_locationManager startUpdatingLocation];
   // }
}


- (IBAction)didClickPhone:(id)sender {
    NSString * phoneNum=[NSString stringWithFormat:@"tel:%@",objRiderRecs.userPhoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
}
- (IBAction)didClickWaitBtn:(id)sender {
    UIButton * btn=(UIButton *)sender;
     waitTextLbl.hidden=NO;
    if(timerWaitLabel==nil){
        timerWaitLabel = [[MZTimerLabel alloc] initWithLabel:waitTextLbl andTimerType:MZTimerLabelTypeStopWatch];
        timerWaitLabel.timeFormat = @"HH:mm:ss";
        
    }
    if([timerWaitLabel counting]){
        [timerWaitLabel pause];
        [btn setTitle:JJLocalizedString(@"Start_Wait", nil) forState:UIControlStateNormal];
    }else{
        [timerWaitLabel start];
        [btn setTitle:JJLocalizedString(@"End_Wait", nil) forState:UIControlStateNormal];
    }
}

- (IBAction)didClickDropLocationBtn:(id)sender {
    DropLocationViewController * objDropLocVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DropLocationVCSID"];
    [objDropLocVC setLattitude:location.coordinate.latitude];
    [objDropLocVC setLongitude:location.coordinate.longitude];
    objDropLocVC.delegate=self;
    [self.navigationController pushViewController:objDropLocVC animated:YES];
}


-(void)sendDropLocation:(CLLocationCoordinate2D )locSelected{
    if(locSelected.latitude!=0){
       dropSelLocation = [[CLLocation alloc] initWithLatitude:locSelected.latitude longitude:locSelected.longitude];
        [self showAddressOrEnterAddress:YES];
        destMarker.position=CLLocationCoordinate2DMake(locSelected.latitude,locSelected.longitude);
        NSString * destination=JJLocalizedString(@"Destination_Location", nil);
         destMarker.snippet = [NSString stringWithFormat:@"%@",destination];
        destMarker.icon = [UIImage imageNamed:@"DestinationPin"];
        destMarker.appearAnimation = kGMSMarkerAnimationPop;
        destMarker.map = GoogleMap;
        CLLocation *loca = [[CLLocation alloc] initWithLatitude:locSelected.latitude longitude:locSelected.longitude];
        [self drawRoadRouteBetweenTwoPoints:loca];
    }else{
        [self.view makeToast:@"Cant_able_to_get_location"];
    }
    
}


-(void)drawRoadRouteBetweenTwoPoints:(CLLocation *)currentLocation{
    
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getGoogleRoute:[self setParametersDrawLocation:currentLocation]
                success:^(NSMutableDictionary *responseDictionary)
     {
         @try {
             NSArray * arr=[responseDictionary objectForKey:@"routes"];
             if([arr count]>0){
                 [self stopActivityIndicator];
                 
                 pathDrawn =[GMSPath pathFromEncodedPath:responseDictionary[@"routes"][0][@"overview_polyline"][@"points"]];
                 singleLine = [GMSPolyline polylineWithPath:pathDrawn];
                 singleLine.strokeWidth = 10;
                 singleLine.strokeColor = SetBlueColor;
                 singleLine.map = self.GoogleMap;
                 GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:pathDrawn];
                 GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0f];
                 //bounds = [bounds includingCoordinate:PickUpmarker.position   coordinate:Dropmarker.position];
                 [GoogleMap animateWithCameraUpdate:update];
                 //  [_locationManager stopUpdatingLocation];
             }else{
                 [self stopActivityIndicator];
                 [self.view makeToast:@"can't_find_route"];
             }
         }
         @catch (NSException *exception) {
             
         }
         
     }
                failure:^(NSError *error)
     {
         [self stopActivityIndicator];
          if(self.view.window){
         UIAlertView * alert=[[UIAlertView alloc]initWithTitle:[Theme project_getAppName] message:JJLocalizedString(@"Cant_able_to_get_location", nil) delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
         alert.tag=102;
         [alert show];
          }
         [self.view makeToast:@"can't_find_route"];
         
     }];
}

-(NSDictionary *)setParametersDrawLocation:(CLLocation *)loc{
    
    NSDictionary *dictForuser = @{
                                  @"origin":[NSString stringWithFormat:@"%f,%f", initialLocation.coordinate.latitude,initialLocation.coordinate.longitude],
                                  @"destination":[NSString stringWithFormat:@"%f,%f",loc.coordinate.latitude,loc.coordinate.longitude],
                                  @"sensor":@"true",
                                   @"key":kGoogleServerKey
                                  };
    return dictForuser;
}
@end
