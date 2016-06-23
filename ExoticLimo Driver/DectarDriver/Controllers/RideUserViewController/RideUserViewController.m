//
//  RideUserViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/25/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "RideUserViewController.h"

@interface RideUserViewController ()
//Open Maps
@property(nonatomic, strong) MapRequestModel *model;
@property(nonatomic, assign) LocationGroup pendingLocationGroup;
@end

@implementation RideUserViewController{
    FBShimmeringView *_shimmeringView;
    GMSMarker *  marker;
    GMSMarker *  marker2;
    GMSPath *pathDrawn;
    GMSPolyline *singleLine;
    int zoompoint;
    int wpoint;
}
@synthesize mapView,buttonContentView,arrivedBtn,headerLbl,optionBtn,addressView,riderNameLbl,addressLbl,Camera,GoogleMap,timeLbl,objRiderRecords,userImageView,riderLattitude,riderLongitude,custIndicatorView,isFirstUpdateLoc,marker3,locTimer,wayArray,isDriverDeviatesStatusNum,isMapZoomed;

- (void)viewDidLoad {
    [super viewDidLoad];
    isDriverDeviatesStatusNum=0;
    zoompoint=15;
    wayArray=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kUserCancelledDrive
                           	                    object:nil];
    [self setFontAndColor];
    [self setUserDatas];
    [self setGlowBtn];
    marker3=[[GMSMarker alloc]init];
    self.points=[[NSMutableArray alloc]init];
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
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
    [self showActivityIndicator:YES];
   locTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                     target:self
                                   selector:@selector(updateLocUsingTimer)
                                   userInfo:nil
                                    repeats:YES];
    // Do any additional setup after loading the view.
}
-(void)updateLocUsingTimer{
    if(location!=nil){
         [self updateLoc:location];
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

-(void)setGlowBtn{
    _shimmeringView = [[FBShimmeringView alloc] init];
    _shimmeringView.shimmering = YES;
    _shimmeringView.shimmeringBeginFadeDuration = 0.2;
     _shimmeringView.shimmeringOpacity = 1;
       [self.view addSubview:_shimmeringView];
    
    arrivedBtn.delegate=self;
    [arrivedBtn setTitle:JJLocalizedString(@"SLIDE_TO_ARRIVED", nil) forState:UIControlStateNormal];
    _shimmeringView.contentView = arrivedBtn;
    CGRect shimmeringFrame = arrivedBtn.frame;
    shimmeringFrame.origin.y= self.view.frame.size.height-70;
    shimmeringFrame.origin.x= 22;
    shimmeringFrame.size.height=50;
     shimmeringFrame.size.width=self.view.frame.size.width-44;
    _shimmeringView.frame = shimmeringFrame;
}

- (void)receiveNotification:(NSNotification *) notification
{
    if(self.view.window){
        NSDictionary * dict=notification.userInfo;
        if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[dict objectForKey:@"action"]]] isEqualToString:@"ride_cancelled"]){
            NSString * rideCancelled=JJLocalizedString(@"Rider_Cancelled_the_ride", nil);
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Sorry !!" message:rideCancelled delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag=100;
            [alert show];
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(alertView.tag==100){
        for (UIViewController *controller1 in self.navigationController.viewControllers) {
            
            if ([controller1 isKindOfClass:[HomeViewController class]]) {
                
                [self.navigationController popToViewController:controller1
                                                      animated:YES];
                break;
            }
        }
    }
  else  if(alertView.tag==101){
      if (buttonIndex==[alertView cancelButtonIndex]) {
            
        }else {
            [self drawRoadRouteBetweenTwoPoints:location];
        }
    }
   
}


-(void)dealloc{
    [_locationManager stopUpdatingLocation];
    if (_locationManager)
    {
        _locationManager = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setUserDatas{
    headerLbl.text=[NSString stringWithFormat:@"%@\nID: %@",objRiderRecords.userName,objRiderRecords.RideId];
    
    addressLbl.text=objRiderRecords.userLocation;
    timeLbl.text=objRiderRecords.userTime;
    
   
    riderLattitude=[objRiderRecords.userLattitude floatValue];
    riderLongitude=[objRiderRecords.userLongitude floatValue];
    
}
-(void)drawRoadRouteBetweenTwoPoints:(CLLocation *)currentLocation{
    
    self.openInMapsBtn.hidden=YES;
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
                 // [self drawRoadRouteBetweenTwoPoints:location];
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
              NSString *noroute=JJLocalizedString(@"can't_find_route", nil);
         UIAlertView * alert=[[UIAlertView alloc]initWithTitle:[Theme project_getAppName] message:noroute delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
         alert.tag=101;
         [alert show];
          }
          [self.view makeToast:@"can't_find_route"];
         
     }];
}

-(NSDictionary *)setParametersDrawLocation:(CLLocation *)loc{

    NSDictionary *dictForuser = @{
                                  @"origin":[NSString stringWithFormat:@"%f,%f",loc.coordinate.latitude,loc.coordinate.longitude],
                                  @"destination":[NSString stringWithFormat:@"%f,%f",riderLattitude,riderLongitude],
                                  @"sensor":@"true",
                                   @"key":kGoogleServerKey
                                  };
    return dictForuser;
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
        if(isFirstUpdateLoc==NO){
            startLocationDriver=location;
            [self loadGoogleMap:location];
            [self drawRoadRouteBetweenTwoPoints:location];
        }else{
           // [self performSelector:@selector(UpdateAlternativeroutBetweenTwoPoints) withObject:self afterDelay:10];
            if(pathDrawn!=nil && location!=nil){
                BOOL isOutOfPath=GMSGeometryIsLocationOnPathTolerance(location.coordinate, pathDrawn, YES, 80);
                if(isOutOfPath==NO){
//                    NSString * str =[NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
//                    if(![wayArray containsObject:str]){
//                        if(wayArray.count>=23){
//                            [wayArray removeLastObject];
//                        }
//                       [wayArray addObject:str];
//                        [self UpdateAlternativeroutBetweenTwoPoints];
//                    }
                    
                    
                    
                    ////// send message to user that driver went away from path
                    
                    //isDriverDeviatesStatus=YES;
                    if(isDriverDeviatesStatusNum==0){
                        //alert to driver
                        isDriverDeviatesStatusNum=1;
                    }
                   
                }else{
                    
                    if(isDriverDeviatesStatusNum==1){
                         isDriverDeviatesStatusNum=0;
                    }
                }
            }
        }
        [self locationManagerUpdate:manager didUpdateToLocation:location fromLocation:oldLocationDriver];
    }
    // NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
}


- (void)locationManagerUpdate:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
//    NSString *pointString=[NSString    stringWithFormat:@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
//    [self.points addObject:pointString];
//    GMSMutablePath *path = [GMSMutablePath path];
    oldLocationDriver=newLocation;
    
//    for (int i=0; i<self.points.count; i++)
//    {
//        NSArray *latlongArray = [[self.points   objectAtIndex:i]componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
//        
//        [path addLatitude:[[latlongArray objectAtIndex:0] doubleValue] longitude:[[latlongArray objectAtIndex:1] doubleValue]];
//    }
   
        if(isMapZoomed==NO){
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                                longitude:newLocation.coordinate.longitude
                                                                     zoom:zoompoint];
        [GoogleMap animateToCameraPosition:camera];
        }
    
   
    
    
    
    marker3.position = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    marker3.icon = [UIImage imageNamed:@"cartopview"];
    NSString * youhere=JJLocalizedString(@"You_are_Here", nil);
    marker3.snippet = [NSString stringWithFormat:@"%@",youhere];
    marker3.appearAnimation = kGMSMarkerAnimationPop;
    marker3.map = GoogleMap;
     if(self.view.window){
     AppDelegate* appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appdelegate xmppUpdateLoc:newLocation.coordinate withReceiver:objRiderRecords.UserId withRideId:objRiderRecords.RideId];
     }
//    if (self.points.count>2)
//    {
//        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
//        polyline.strokeColor = setRedColor;
//        polyline.strokeWidth = 4.f;
//        polyline.map = GoogleMap;
//        mapView = GoogleMap;
//    }
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
                                  @"ride_id":objRiderRecords.RideId
                                  };
    return dictForuser;
}

-(void)viewWillDisappear:(BOOL)animated{
    //[self.locationManager stopUpdatingLocation];
}
-(void)loadGoogleMap:(CLLocation *)loc{
    isFirstUpdateLoc=YES;
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
    
    GoogleMap = [GMSMapView mapWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height) camera:Camera];
   // GoogleMap.myLocationEnabled = YES;
    marker=[[GMSMarker alloc]init];
    marker.position=Camera.target;
    NSString * youhere=JJLocalizedString(@"You_are_Here", nil);
    marker.snippet =youhere;
    marker.icon = [UIImage imageNamed:@"StartingPin"];
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = GoogleMap;
    
    
    marker2=[[GMSMarker alloc]init];
    marker2.position=CLLocationCoordinate2DMake(riderLattitude,riderLongitude);;
    marker2.snippet =headerLbl.text;
    marker2.icon = [UIImage imageNamed:@"UserLocationImg"];
    marker2.appearAnimation = kGMSMarkerAnimationPop;
    marker2.map = GoogleMap;
    GoogleMap.userInteractionEnabled=YES;
    GoogleMap.delegate = self;
    [mapView addSubview:GoogleMap];
    
}

-(void)setFontAndColor{
   
   // [arrivedBtn setBackgroundColor:setRedColor];
   // arrivedBtn.layer.cornerRadius=2;
    //arrivedBtn.layer.masksToBounds=YES;
    userImageView.layer.cornerRadius=userImageView.frame.size.width/2;
    userImageView.layer.masksToBounds=YES;
    headerLbl=[Theme setHeaderFontForLabel:headerLbl];
    addressLbl=[Theme setNormalSmallFontForLabel:addressLbl];
    timeLbl=[Theme setNormalSmallFontForLabel:timeLbl];
  //  riderNameLbl=[Theme setBoldFontForLabel:riderNameLbl];
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

- (IBAction)didClickRefreshBtn:(id)sender {
    isMapZoomed=NO;
     [_locationManager startUpdatingLocation];
    if(pathDrawn==nil){
        [self drawRoadRouteBetweenTwoPoints:location];
    }
}

- (IBAction)didClickCallBtn:(id)sender {
    NSString * phoneNum=[NSString stringWithFormat:@"tel:%@",objRiderRecords.userPhoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
}

- (IBAction)didClickArrivedBtn:(id)sender {
//    UIButton * btn=sender;
//    btn.userInteractionEnabled=NO;
//     [self showActivityIndicator:YES];
//    UrlHandler *web = [UrlHandler UrlsharedHandler];
//    [web DriverArrLocation:[self setParametersDriverArrived]
//                    success:^(NSMutableDictionary *responseDictionary)
//     {
//         [self stopActivityIndicator];
//         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
//             TripViewController * objTripVc=[self.storyboard instantiateViewControllerWithIdentifier:@"TripVCSID"];
//             [objTripVc setObjRiderRecs:objRiderRecords];
//             [self.navigationController pushViewController:objTripVc animated:YES];
//         }else{
//              btn.userInteractionEnabled=YES;
//             [self.view makeToast:kErrorMessage];
//         }
//     }
//                    failure:^(NSError *error)
//     {
//         [self stopActivityIndicator];
//          btn.userInteractionEnabled=YES;
//         [self.view makeToast:kErrorMessage];
//         
//     }];
}
- (void) slideActive{
    @try {
        arrivedBtn.userInteractionEnabled=NO;
        [self showActivityIndicator:YES];
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [web DriverArrLocation:[self setParametersDriverArrived]
                       success:^(NSMutableDictionary *responseDictionary)
         {
             [self stopActivityIndicator];
             if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
                 TripViewController * objTripVc=[self.storyboard instantiateViewControllerWithIdentifier:@"TripVCSID"];
                 [objTripVc setObjRiderRecs:objRiderRecords];
                 [_locationManager stopUpdatingLocation];
                 [locTimer invalidate];
                 locTimer=nil;
                 [self.navigationController pushViewController:objTripVc animated:YES];
             }else{
                 arrivedBtn.userInteractionEnabled=YES;
                 [self.view makeToast:kErrorMessage];
             }
         }
                       failure:^(NSError *error)
         {
             [self stopActivityIndicator];
             arrivedBtn.userInteractionEnabled=YES;
             [self.view makeToast:kErrorMessage];
             
         }];
    }
    @catch (NSException *exception) {
        
    }
}

-(NSDictionary *)setParametersDriverArrived{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"ride_id":objRiderRecords.RideId
                                  };
    return dictForuser;
}

- (IBAction)didClickOptionBtn:(id)sender {
    InfoViewController * objInfoVc=[self.storyboard instantiateViewControllerWithIdentifier:@"InfoVCSID"];
    [objInfoVc setRideId:objRiderRecords.RideId];
    [self.navigationController pushViewController:objInfoVc animated:YES];
}
- (IBAction)didClickMoveToGoogleMapsBtn:(id)sender {
    //Open maps
    if (![[OpenInGoogleMapsController sharedInstance] isGoogleMapsInstalled]) {
        
    }
    [self openDirectionsInGoogleMaps];
}
//Open Maps
- (void)openDirectionsInGoogleMaps {
    GoogleDirectionsDefinition *directionsDefinition = [[GoogleDirectionsDefinition alloc] init];
    if (self.model.startCurrentLocation) {
        directionsDefinition.startingPoint = nil;
    } else {
        GoogleDirectionsWaypoint *startingPoint = [[GoogleDirectionsWaypoint alloc] init];
        startingPoint.queryString = self.model.startQueryString;
        startingPoint.location = self.model.startLocation;
        directionsDefinition.startingPoint = startingPoint;
    }
    if (self.model.destinationCurrentLocation) {
        directionsDefinition.destinationPoint = nil;
    } else {
        GoogleDirectionsWaypoint *destination = [[GoogleDirectionsWaypoint alloc] init];
        destination.queryString = self.model.destinationQueryString;
        destination.location = self.model.desstinationLocation;
        directionsDefinition.destinationPoint = destination;
    }
    
    directionsDefinition.travelMode = [self travelModeAsGoogleMapsEnum:self.model.travelMode];
    [[OpenInGoogleMapsController sharedInstance] openDirections:directionsDefinition];
}
// Convert our app's "travel mode" to the official Google Enum
- (GoogleMapsTravelMode)travelModeAsGoogleMapsEnum:(TravelMode)appTravelMode {
    switch (appTravelMode) {
        case kTravelModeBicycling:
            return kGoogleMapsTravelModeBiking;
        case kTravelModeDriving:
            return kGoogleMapsTravelModeDriving;
        case kTravelModePublicTransit:
            return kGoogleMapsTravelModeTransit;
        case kTravelModeWalking:
            return kGoogleMapsTravelModeWalking;
        case kTravelModeNotSpecified:
            return 0;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


////////////////////////////////////////////////////////////////////////////////////////////

-(void)UpdateAlternativeroutBetweenTwoPoints{
    NSString *joinedString=@"";
    if(wayArray.count>0){
        joinedString = [wayArray componentsJoinedByString:@"|"];
    }
    wpoint++;
    NSString * wayscount=JJLocalizedString(@"ways_count", nil);
    
    [self.view makeToast:[NSString stringWithFormat:@"%d %@",wpoint,wayscount ]];
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@?origin=%f,%f&destination=%f,%f&waypoints=%@&sensor=true",
                           @"https://maps.googleapis.com/maps/api/directions/json",
                           startLocationDriver.coordinate.latitude,
                           startLocationDriver.coordinate.longitude,
                           riderLattitude,
                           riderLongitude,joinedString];
    NSURL *directionsURL = [NSURL URLWithString:urlString];
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:directionsURL];
    [request startSynchronous];
    NSError *error = [request error];
    [self stopActivityIndicator];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@" %@",response);
        NSDictionary *json =[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"%@",json);
        NSArray * arr=[json objectForKey:@"routes"];
        if([arr count]>0){
            if(singleLine!=nil){
                [singleLine setMap:nil];
            }
            pathDrawn =[GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
            singleLine = [GMSPolyline polylineWithPath:pathDrawn];
            singleLine.strokeWidth = 10;
            singleLine.strokeColor = SetBlueColor;
            singleLine.map = self.GoogleMap;
            GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:pathDrawn];
            GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0f];
            //bounds = [bounds includingCoordinate:PickUpmarker.position   coordinate:Dropmarker.position];
            [GoogleMap animateWithCameraUpdate:update];
            [_locationManager stopUpdatingLocation];
        }else{
          //  [self UpdateAlternativeroutBetweenTwoPoints];
            // [self.view makeToast:@"can't find route"];
        }
        
        // }
        
    }
}

@end
