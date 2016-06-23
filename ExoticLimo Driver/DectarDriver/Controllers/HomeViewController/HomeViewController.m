//
//  HomeViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/24/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "HomeViewController.h"



@interface HomeViewController ()<RideAcceptDelegate,NewJobsDelegate>{
    int ZoomPoint;
  
}

@end

@implementation HomeViewController



@synthesize mapView,Camera,GoogleMap,lattitude,longitude,DriverNameHeaderLbl,
goOffLineBtn,marker,custIndicatorView,pendingLbl,tripId,VehicleNumber,refreshTimer,custIndicatorViewUrl,isMapZoomed,ReservedJobId,isnotVerified;

- (void)viewDidLoad {
    [super viewDidLoad];
    ZoomPoint=17;
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self setFont];
   
    marker=[[GMSMarker alloc]init];
    [self loadGoogleMap];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kDriverCashPaymentNotifWhenQuit
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTableRefreshNotification:)
                                                 name:kDriverReceiveNotif
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNewJobNotif:)
                                                 name:kNewTripKey
                                               object:nil];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveToPendingTransaction)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [pendingLbl addGestureRecognizer:tapGestureRecognizer];
    pendingLbl.userInteractionEnabled = YES;
    [goOffLineBtn setTitle:JJLocalizedString(@"Go_Offline", nil) forState:UIControlStateNormal];
    goOffLineBtn=[Theme setBoldFontForButton:goOffLineBtn];
   // goOffLineBtn.layer.cornerRadius=16;
   // goOffLineBtn.layer.masksToBounds=YES;
    // Do any additional setup after loading the view.

}



- (void)receiveNotification:(NSNotification *) notification
{
    if(self.view.window){
        NSDictionary * dict=notification.userInfo;
        if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[dict objectForKey:@"action"]]] isEqualToString:@"receive_cash"]){
            NSString * rideId=[Theme checkNullValue:[dict objectForKey:@"key1"]];
            NSString * CurrId=[Theme findCurrencySymbolByCode:[Theme checkNullValue:[dict objectForKey:@"key4"]]];
            NSString * fareStr=[Theme checkNullValue:[dict objectForKey:@"key3"]];
            NSString * fareAmt=[NSString stringWithFormat:@"%@ %@",CurrId,fareStr];
            
            [self stopActivityIndicator];
            ReceiveCashViewController * objReceiveCashVC=[self.storyboard  instantiateViewControllerWithIdentifier:@"ReceiveCashVCSID"];
            [objReceiveCashVC setRideId:rideId];
            [objReceiveCashVC setFareAmt:fareAmt];
            [self.navigationController pushViewController:objReceiveCashVC animated:YES];
        }
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)moveToPendingTransaction{
    if(isnotVerified==NO){
    TripDetailViewController * objTripDetailVc=[self.storyboard instantiateViewControllerWithIdentifier:@"TripDetailVCSID"];
    [objTripDetailVc setTripId:tripId];
    [self.navigationController pushViewController:objTripDetailVc animated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    pendingLbl.hidden=YES;
    location = [[CLLocation alloc] initWithLatitude:lattitude longitude:longitude];
    [self updateLoc:location];
 [self.locationManager startUpdatingLocation];
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval: 30
                                                    target: self
                                                  selector: @selector(refreshLocation)
                                                  userInfo: nil
                                                   repeats: YES];
   
}
- (void)receiveNewJobNotif:(NSNotification *) notification
{
    NSLog(@"Received APNS with userInfo %@", notification.userInfo);
    NSDictionary * dict=notification.userInfo;
    if(self.view.window){
        RiderRecords * objRideAcceptRec=[[RiderRecords alloc]init];
        objRideAcceptRec.RideId=[Theme checkNullValue:[dict objectForKey:@"key6"]];
        ReservedJobId=objRideAcceptRec.RideId;
        objRideAcceptRec.userImage=[Theme checkNullValue:[dict objectForKey:@"key4"]];
        objRideAcceptRec.userName=[Theme checkNullValue:[dict objectForKey:@"key1"]];
        
        objRideAcceptRec.userTime=[Theme checkNullValue:[dict objectForKey:@"key10"]];
        objRideAcceptRec.userPhoneNumber=[Theme checkNullValue:[dict objectForKey:@"key3"]];
        objRideAcceptRec.userReview=[Theme checkNullValue:[dict objectForKey:@"key5"]];
        
        objRideAcceptRec.userLocation=[Theme checkNullValue:[dict objectForKey:@"key7"]];
        objRideAcceptRec.userLattitude=[Theme checkNullValue:[dict objectForKey:@"key8"]];
        objRideAcceptRec.userLongitude=[Theme checkNullValue:[dict objectForKey:@"key9"]];
        
        if(objRideAcceptRec.RideId.length>0){
            NewJobViewController * objJobPopup=[self.storyboard instantiateViewControllerWithIdentifier:@"NewJobVCSID"];
            objJobPopup.delegate=self;
            
            [objJobPopup setObjRiderRecs:objRideAcceptRec];
            if ([[UIDevice currentDevice].systemVersion integerValue] >= 8)
            {
                //For iOS 8
                objJobPopup.providesPresentationContextTransitionStyle = YES;
                objJobPopup.definesPresentationContext = YES;
                objJobPopup.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            else
            {
                //For iOS 7
                objJobPopup.modalPresentationStyle = UIModalPresentationCurrentContext;
            }
            [self presentViewController:objJobPopup animated:NO completion:nil];
        }
    }
}
-(void)refreshLocation{
   [self updateLoc:location];
}

-(void)setFont{
    NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
    DriverNameHeaderLbl.text=[Theme checkNullValue:[NSString stringWithFormat:@"%@\n%@",[myDictionary objectForKey:@"driver_name"],[Theme checkNullValue:VehicleNumber]]];
    DriverNameHeaderLbl=[Theme setHeaderFontForLabel:DriverNameHeaderLbl];
    goOffLineBtn=[Theme setBoldSmallFontForButton:goOffLineBtn];
    pendingLbl=[Theme setHeaderFontForLabel:pendingLbl];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.userInfo);
    [self stopActivityIndicator];
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"App_Permission_Denied", nil)
                                                               message:JJLocalizedString(@"enable_please_go", nil)
                                                              delegate:nil
                                                     cancelButtonTitle:JJLocalizedString(@"OK", nil)
                                                     otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)receiveTableRefreshNotification:(NSNotification *) notification
{
     NSLog(@"Received APNS with userInfo %@", notification.userInfo);
    NSDictionary * dict=notification.userInfo;
    if(self.view.window){
        RideAcceptViewController *  objRideAcceptVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RideAcceptVCSID"];
        
        RideAcceptRecord * objRideAcceptRec=[[RideAcceptRecord alloc]init];
        objRideAcceptRec.LocationName=[Theme checkNullValue:[dict objectForKey:@"key3"]];
        objRideAcceptRec.RideId=[Theme checkNullValue:[dict objectForKey:@"key1"]];
        objRideAcceptRec.expiryTime=[Theme checkNullValue:[dict objectForKey:@"key2"]];
        objRideAcceptRec.rideTag=1;
        NSString * pickuprequest=JJLocalizedString(@"PickUp_Request", nil);
        
        objRideAcceptRec.headerTxt=[Theme checkNullValue:[NSString stringWithFormat:@"%@ 1",pickuprequest]];
        
        NSInteger expValue=[objRideAcceptRec.expiryTime integerValue];
        if(expValue<=5){
            objRideAcceptRec.expiryTime=@"15";
        }
        objRideAcceptRec.currentTimer=0;
        objRideAcceptVc.requestArray=[[NSMutableArray alloc]init];
        [objRideAcceptVc.requestArray addObject:objRideAcceptRec];
       
        objRideAcceptVc.delegate=self;
        if(objRideAcceptVc!=nil){
            [self.navigationController pushViewController:objRideAcceptVc animated:NO];
        }
    }
}

-(NSDictionary *)setParametersUpdateUserOnOff:(NSString *)OnOffStr{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"availability":OnOffStr
                                  };
    return dictForuser;
}

-(void)loadGoogleMap{
    if(TARGET_IPHONE_SIMULATOR)
    {
        Camera = [GMSCameraPosition cameraWithLatitude:13.0827
                                             longitude:80.2707
                                                  zoom:17];
    }else{
        Camera = [GMSCameraPosition cameraWithLatitude:lattitude
                                             longitude:longitude
                                                  zoom:ZoomPoint];
    }
    
    GoogleMap = [GMSMapView mapWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height) camera:Camera];
    marker.position = Camera.target;
    
    marker.icon = [UIImage imageNamed:@"CarMarker"];
    NSString * youhere=JJLocalizedString(@"You_are_Here", nil);
    marker.snippet = [NSString stringWithFormat:@"%@\n%@",DriverNameHeaderLbl.text,youhere];
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = GoogleMap;
    //GoogleMap.myLocationEnabled = YES;
    GoogleMap.userInteractionEnabled=YES;
    GoogleMap.delegate = self;
    
    [mapView addSubview:GoogleMap];
    
//    
//    GMSMutablePath *poly = [GMSMutablePath path];
//    [poly addCoordinate:CLLocationCoordinate2DMake(13.054894, 80.237541)];
//    [poly addCoordinate:CLLocationCoordinate2DMake(13.055145, 80.243034)];
//    [poly addCoordinate:CLLocationCoordinate2DMake(13.052365, 80.245319)];
//    [poly addCoordinate:CLLocationCoordinate2DMake(13.050776, 80.244439)];
//    [poly addCoordinate:CLLocationCoordinate2DMake(13.050745, 80.242755)];
//    [poly addCoordinate:CLLocationCoordinate2DMake(13.051978, 80.241339)];
//    [poly addCoordinate:CLLocationCoordinate2DMake(13.054288, 80.241543)];
//    
//    GMSPolygon *polygon = [GMSPolygon polygonWithPath:poly];
//    polygon.fillColor = [UIColor colorWithRed:0 green:0.25 blue:0 alpha:0.3];
//    polygon.strokeColor = [UIColor greenColor];
//    polygon.strokeWidth = 5;
//    polygon.map = self.GoogleMap;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didClickGoOfflineBtn:(id)sender {
    goOffLineBtn.userInteractionEnabled=NO;
    [self showActivityIndicatorForURl:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web UserGoOfflineOnLineUrl:[self setParametersUpdateUserOnOff:@"No"]
                        success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicatorForUrl];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
            //[self.view makeToast:@"you are offline"];
         }else{
            // [self.view makeToast:@"Some error occured"];
         }
         [Theme SaveUSerISOnline:@"0"];
          [self.navigationController popViewControllerAnimated:YES];
          goOffLineBtn.userInteractionEnabled=YES;
     }
                        failure:^(NSError *error)
     {
         [self stopActivityIndicatorForUrl];
         [Theme SaveUSerISOnline:@"0"];
         [self.navigationController popViewControllerAnimated:YES];
         [self.view makeToast:kErrorMessage];
           goOffLineBtn.userInteractionEnabled=YES;
         
     }];
  //  [self navigateToLatitude:12.9856 longitude:80.2614 ];
}
//- (void) navigateToLatitude:(double)latitude
//                  longitude:(double)longitude
//{
//    if ([[UIApplication sharedApplication]
//         canOpenURL:[NSURL URLWithString:@"waze://"]]) {
//        
//        // Waze is installed. Launch Waze and start navigation
//        NSString *urlStr =
//        [NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes",
//         latitude, longitude];
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//        
//    } else {
//        
//        // Waze is not installed. Launch AppStore to install Waze app
//        [[UIApplication sharedApplication] openURL:[NSURL
//                                                    URLWithString:@"http://itunes.apple.com/us/app/id323229106"]];
//    }
//}



-(void)viewWillDisappear:(BOOL)animated{
    [refreshTimer invalidate];
  [self.locationManager stopUpdatingLocation];
}

- (IBAction)didClickUpdateLocation:(id)sender {
    //GoogleMap.myLocationEnabled = YES;
    [self showActivityIndicator:YES];
    isMapZoomed=NO;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self stopActivityIndicator];
 Newlocation=newLocation;
    location=newLocation;
    lattitude=newLocation.coordinate.latitude;
    longitude=newLocation.coordinate.longitude;
    
    if(isMapZoomed==NO){
        Camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                             longitude:newLocation.coordinate.longitude
                                                  zoom:ZoomPoint];
        [GoogleMap animateToCameraPosition:Camera];
    }
    
   // marker.rotation = [self DegreeBearing:oldLocation locationB:newLocation];
    marker.position = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    marker.icon = [UIImage imageNamed:@"CarMarker"];
    NSString * youhere=JJLocalizedString(@"You_are_Here", nil);

    marker.snippet = [NSString stringWithFormat:@"%@",youhere];
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = GoogleMap;
    
   
}
-(void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition*)position {
    ZoomPoint=position.zoom;
    
}
-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    
    if(gesture==YES){
        isMapZoomed=YES;
    }else{
         isMapZoomed=NO;
    }
}

-(void)showActivityIndicator:(BOOL)isShow{
    if(isShow==YES){
        if(custIndicatorView==nil){
            custIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStylePulse color:SetThemeColor];
            
        }
        custIndicatorView.center =self.view.center;
        [custIndicatorView startAnimating];
        [self.view addSubview:custIndicatorView];
        [self.view bringSubviewToFront:custIndicatorView];
    }
}
-(void)stopActivityIndicator{
    [custIndicatorView stopAnimating];
    custIndicatorView=nil;
}



-(void)showActivityIndicatorForURl:(BOOL)isShow{
    if(isShow==YES){
        if(custIndicatorViewUrl==nil){
            custIndicatorViewUrl = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStylePulse color:SetThemeColor];
            
        }
        custIndicatorViewUrl.center =self.view.center;
        [custIndicatorViewUrl startAnimating];
        [self.view addSubview:custIndicatorViewUrl];
        [self.view bringSubviewToFront:custIndicatorViewUrl];
    }
}
-(void)stopActivityIndicatorForUrl{
    [custIndicatorViewUrl stopAnimating];
    custIndicatorViewUrl=nil;
}


-(void)updateLoc:(CLLocation *)loc{
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web UpdateUserLocation:[self setParametersUpdateLocation:loc]
                    success:^(NSMutableDictionary *responseDictionary)
     {
         
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             NSString * str=[Theme checkNullValue:responseDictionary[@"response"][@"availability"]];
             NSString * verifyStr=[Theme checkNullValue:responseDictionary[@"response"][@"verify_status"]];
              NSString * showMsgStr=[Theme checkNullValue:responseDictionary[@"response"][@"errorMsg"]];
             if(![verifyStr isEqualToString:@"Yes"]){
                 isnotVerified=YES;
                 if(showMsgStr.length>0){
                      pendingLbl.text=showMsgStr;
                 }else{
                     pendingLbl.text=JJLocalizedString(@"You_are_not_yet_verified", nil);
                 }
                 
                 pendingLbl.hidden=NO;
                
                 [pendingLbl setBackgroundColor:setRedColor];
                 pendingLbl.alpha=0.7;
                 
             }else if ([str isEqualToString:@"Unavailable"]){
                 isnotVerified=NO;
                 if(showMsgStr.length>0){
                     pendingLbl.text=showMsgStr;
                 }
                 tripId=[Theme checkNullValue:responseDictionary[@"response"][@"ride_id"]];
                 pendingLbl.hidden=NO;
                 [pendingLbl setBackgroundColor:[UIColor blackColor]];
                 pendingLbl.alpha=0.6;
             }else{
                 pendingLbl.text=@"";
                 isnotVerified=NO;
                 pendingLbl.hidden=YES;
                 [self stopActivityIndicator];
             }
             
         }
     }
                    failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         
         //      [self.view makeToast:kErrorMessage];
         
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
                                  @"ride_id":@""
                                  };
    return dictForuser;
}

-(void)ridecancelled{
    [self.view makeToast:@"You_are_too_late"];
}
- (void) didClickNewJobsOk{
    if(ReservedJobId.length>0){
        tripId=ReservedJobId;
        [ self moveToPendingTransaction];
    }
}
-(double) DegreeBearing:(CLLocation*) A locationB: (CLLocation*)B{
    double dlon = [self ToRad:(B.coordinate.longitude - A.coordinate.longitude)];
    double dPhi = log(tan([self ToRad:B.coordinate.latitude ] / 2 + M_PI / 4) / tan([self ToRad:A.coordinate.latitude] / 2 + M_PI / 4));
    if  (fabs(dlon) > M_PI){
        dlon = (dlon > 0) ? (dlon - 2*M_PI) : (2*M_PI + dlon);
    }
    
    return [self ToBearing:atan2(dlon, dPhi)];
}

-(double) ToRad: (double)degrees{
    return degrees*(M_PI/180);
}

-(double) ToBearing:(double)radians{
    return [self ToDegrees:radians] + 360 % 360;
}

-(double) ToDegrees: (double)radians{
    return radians * 180 / M_PI;
}
@end
