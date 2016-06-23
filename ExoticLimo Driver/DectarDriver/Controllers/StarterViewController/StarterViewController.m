//
//  StarterViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/21/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "StarterViewController.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"

#import <QuartzCore/QuartzCore.h>
#import "ATAppUpdater.h"

@interface StarterViewController (){
    NSString * vehNumber;
}

@end
@class RootBaseViewController;
@implementation StarterViewController
@synthesize userImageView,userNameLbl,userVehModelLbl,goOnlineBtn,isLocUpdated,custIndicatorView,bottomView,currentMapView,starterScrollView,tipsView,lastTripTimeLbl,
lastTripVehModelLbl,
lastTripNerEarningsLbl,
todaysOnlineLbl,
todaysTripLbl,
todaysEstimateLbl,
tipsLbl,catgLbl,lastTripView,TodaysTotalView,tipsTripsLbl,ratingView,currencyStr,refreshTimer,isRefreshTimerActive;
+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"StarterVCSID"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kDriverCashPaymentNotifWhenQuit
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [self setFont];
    [self setDatasOfUser];
    [self setShadow:tipsView];
    [self setShadow:TodaysTotalView];
    [self setShadow:lastTripView];
    
    
}
-(void)enteredForeground{
    if(self.view.window){
       [[ATAppUpdater sharedUpdater] showUpdateWithForce];
    }
}

-(void)setShadow:(UIView * )view{
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(5, 5);
    view.layer.shadowRadius = 5;
    view.layer.shadowOpacity = 0.3;
}
-(void)loadData{
    
    [self.view endEditing:YES];
    
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web StarterData:[self setParametersForStarter]
             success:^(NSMutableDictionary *responseDictionary)
     {
         self.view.userInteractionEnabled=YES;
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             NSDictionary * dict=[responseDictionary objectForKey:@"response"];
             catgLbl.text=[Theme checkNullValue:[dict objectForKey:@"driver_category"]];
             NSString * strRate=[Theme checkNullValue:[dict objectForKey:@"driver_review"]];
             vehNumber=[Theme checkNullValue:[dict objectForKey:@"vehicle_number"]];
             if(strRate.length>0){
                 _rateLbl.text=[NSString stringWithFormat:@"( %@ / 5 )",strRate];
             }
             NSString * imgstr=[dict objectForKey:@"driver_image"];
             
             [userImageView sd_setImageWithURL:[NSURL URLWithString:imgstr] placeholderImage:[UIImage imageNamed:@"PlaceHolderImg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                 
             }];

             
             
            
             [self loadRating:[Theme checkNullValue:[dict objectForKey:@"driver_review"]]];
             if([[dict objectForKey:@"last_trip"] count]>0){
                 NSDictionary * dict1=[dict objectForKey:@"last_trip"];
                 NSString * str1=[Theme checkNullValue:[dict1 objectForKey:@"ride_time"]];
                 NSString * str2=[Theme checkNullValue:[dict1 objectForKey:@"ride_date"]];
                 NSString * str3=[Theme checkNullValue:[dict1 objectForKey:@"earnings"]];
                 NSString * str4=[Theme findCurrencySymbolByCode:[Theme checkNullValue:[dict1 objectForKey:@"currency"]]];
                 currencyStr=str4;
                 if(str1.length>0){
                     lastTripTimeLbl.text=str1;
                 }else{
                     lastTripTimeLbl.text=JJLocalizedString(@"No_recent_trips", nil);
                 }
                 if(str2.length>0){
                     lastTripVehModelLbl.text=str2;
                 }
                 else{
                     lastTripVehModelLbl.text=@"";
                 }
                 if(str3.length>0){
                     lastTripNerEarningsLbl.attributedText=[self mainStr:[NSString stringWithFormat:@"%@ %@",str4,str3] withSubStr:str4];
                     
                 }
                 else{
                     lastTripNerEarningsLbl.attributedText=[self mainStr:[NSString stringWithFormat:@"%@ 0.00",str4] withSubStr:str4];
                     
                 }
             }
             if([[dict objectForKey:@"today_earnings"] count]>0){
                 
                 NSDictionary * dict2=[dict objectForKey:@"today_earnings"];
                 NSString * str1=[Theme checkNullValue:[dict2 objectForKey:@"online_hours"]];
                 NSString * str2=[Theme checkNullValue:[dict2 objectForKey:@"trips"]];
                 NSString * str3=[Theme checkNullValue:[dict2 objectForKey:@"earnings"]];
                 NSString * str4=[Theme findCurrencySymbolByCode:[Theme checkNullValue:[dict2 objectForKey:@"currency"]]];
                 currencyStr=str4;
                 if(str1.length>0){
                     todaysOnlineLbl.text=str1;
                 }else{
                     todaysOnlineLbl.text=@"";
                 }
                 if(str2.length>0){
                     todaysTripLbl.text=[NSString stringWithFormat:@"%@ %@",str2,JJLocalizedString(@"Trips", nil)];
                 }
                 else{
                     todaysTripLbl.text=[NSString stringWithFormat:@"0 %@",JJLocalizedString(@"Trips", nil)];
                 }
                 if(str3.length>0){
                     todaysEstimateLbl.attributedText=[self mainStr:[NSString stringWithFormat:@"%@ %@",str4,str3] withSubStr:str4];
                     
                 }
                 else{
                     todaysEstimateLbl.attributedText=[self mainStr:[NSString stringWithFormat:@"%@ 0.00",str4] withSubStr:str4];
                     
                 }
                 
             }else{
                 todaysTripLbl.text=[NSString stringWithFormat:@"0 %@",JJLocalizedString(@"Trips", nil)];
             }
             if([[dict objectForKey:@"today_tips"] count]>0){
                 NSDictionary * dict3=[dict objectForKey:@"today_tips"];
                 NSString * str2=[Theme checkNullValue:[dict3 objectForKey:@"trips"]];
                 NSString * str3=[Theme checkNullValue:[dict3 objectForKey:@"tips"]];
                 NSString * str4=[Theme findCurrencySymbolByCode:[Theme checkNullValue:[dict3 objectForKey:@"currency"]]];
                 currencyStr=str4;
                 if(str2.length>0){
                     tipsTripsLbl.text=[NSString stringWithFormat:@"%@ %@",str2,JJLocalizedString(@"Trips", nil)];
                 }
                 else{
                     tipsTripsLbl.text=[NSString stringWithFormat:@"0 %@",JJLocalizedString(@"Trips", nil)];
                 }
                 if(str3.length>0){
                     tipsLbl.attributedText=[self mainStr:[NSString stringWithFormat:@"%@ %@",str4,str3] withSubStr:str4];
                     
                 }
                 else{
                     tipsLbl.attributedText=[self mainStr:[NSString stringWithFormat:@"%@ 0.00",str4] withSubStr:str4];
                     
                 }
             }else{
                 tipsTripsLbl.text=[NSString stringWithFormat:@"0 %@",JJLocalizedString(@"Trips", nil)];
             }
             
             
             
             
             
         }else{
             self.view.userInteractionEnabled=YES;
             [self.view makeToast:kErrorMessage];
         }
     }
             failure:^(NSError *error)
     {
         self.view.userInteractionEnabled=YES;
         [self stopActivityIndicator];
         [self.view makeToast:kErrorMessage];
         
     }];
    
    
}
-(NSMutableAttributedString *)mainStr:(NSString *)mainStr withSubStr:(NSString *)subStr{
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:mainStr];
    NSRange rangeOfSubstring = [mainStr rangeOfString:subStr];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]
                  range:rangeOfSubstring];
    return hogan;
}
-(NSDictionary *)setParametersForStarter{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  
                                  };
    return dictForuser;
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
-(void)viewWillAppear:(BOOL)animated{
    [self settext];
    [[ATAppUpdater sharedUpdater] showUpdateWithForce];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if(_locationManager==nil){
        _locationManager = [CLLocationManager new];
    }
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
      [_locationManager startUpdatingLocation];
    currentMapView.delegate = self;
    self.currentMapView.showsUserLocation = YES;
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.latitudeDelta = 0.02f;
    region.span.longitudeDelta = 0.02f;
    
    [currentMapView setRegion:region animated:YES];
    CLLocationCoordinate2D newCenter = _locationManager.location.coordinate;
    newCenter.latitude -= currentMapView.region.span.latitudeDelta * 0.35;
    [self.currentMapView setCenterCoordinate:newCenter animated:YES];
    [self loadData];
    starterScrollView.contentSize=CGSizeMake(starterScrollView.frame.size.width, tipsView.frame.origin.y+tipsView.frame.size.height+15);
    
}
-(void)applicationLanguageChangeNotification:(NSNotification*)notification{
    [self settext];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    static NSString * const identifier = @"MyCustomAnnotation";
    
    MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (annotationView)
    {
        annotationView.annotation = annotation;
    }
    else
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:identifier];
    }
    
    annotationView.canShowCallout = NO;
    annotationView.image = [UIImage imageNamed:JJLocalizedString(@"currentLoc_Img", nil)];
    
    return annotationView;
}

-(void)viewDidAppear:(BOOL)animated{
    
}
-(void)viewWillDisappear:(BOOL)animated{
    isRefreshTimerActive=NO;
    [refreshTimer invalidate];
    refreshTimer=nil;
    [self.locationManager stopUpdatingLocation];
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
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.userInfo);
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
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    location = [locations lastObject];
    if(location.coordinate.latitude!=0){
        if(isRefreshTimerActive==NO){
            isRefreshTimerActive=YES;
            refreshTimer = [NSTimer scheduledTimerWithTimeInterval: 30
                                                            target: self
                                                          selector: @selector(refreshLocation)
                                                          userInfo: nil
                                                           repeats: YES];
            [self updateLoc:location];
        }
        
        
        CLLocationCoordinate2D newCenter = _locationManager.location.coordinate;
        newCenter.latitude -= currentMapView.region.span.latitudeDelta * 0.35;
        [self.currentMapView setCenterCoordinate:newCenter animated:YES];
    }
    // NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
}

-(void)refreshLocation{
    [self updateLoc:location];
}
-(void)setDatasOfUser{
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        NSString * imgstr=[myDictionary objectForKey:@"driver_image"];
        [userImageView sd_setImageWithURL:[NSURL URLWithString:imgstr] placeholderImage:[UIImage imageNamed:@"PlaceHolderImg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];

        
        userNameLbl.text=[myDictionary objectForKey:@"driver_name"];
        userVehModelLbl.text=[myDictionary objectForKey:@"vehicle_model"];
        catgLbl.text=@"";
    }
}
-(void)setFont{
    _headerLbl=[Theme setHeaderFontForLabel:_headerLbl];
    _imgCircleLbl.layer.cornerRadius=_imgCircleLbl.frame.size.width/2;
    _imgCircleLbl.layer.borderColor=SetThemeColor.CGColor;
    _imgCircleLbl.layer.borderWidth=1;
    _imgCircleLbl.layer.masksToBounds=YES;
    userImageView.layer.cornerRadius=userImageView.frame.size.width/2;
    userImageView.layer.masksToBounds=YES;
    //    basicInfoView.frame=CGRectMake(basicInfoView.frame.origin.x, userImageView.frame.origin.y+userImageView.frame.size.height+30, basicInfoView.frame.size.width, basicInfoView.frame.size.height);
    //userNameLbl=[Theme setBoldFontForLabel:userNameLbl];
    // userVehModelLbl=[Theme setNormalFontForLabel:userVehModelLbl];
    goOnlineBtn=[Theme setBoldFontForButton:goOnlineBtn];
    // [goOnlineBtn setBackgroundColor:SetBlueColor];
    goOnlineBtn.layer.cornerRadius=5;
    goOnlineBtn.layer.masksToBounds=YES;
    
    tipsView.layer.cornerRadius=5;
    tipsView.layer.masksToBounds=YES;
    
    lastTripView.layer.cornerRadius=5;
    lastTripView.layer.masksToBounds=YES;
    
    TodaysTotalView.layer.cornerRadius=5;
    TodaysTotalView.layer.masksToBounds=YES;
    if(IS_IPHONE_6P){
        lastTripView.frame=CGRectMake(lastTripView.frame.origin.x, 240, lastTripView.frame.size.width, lastTripView.frame.size.height);
        TodaysTotalView.frame=CGRectMake(TodaysTotalView.frame.origin.x, lastTripView.frame.origin.y+lastTripView.frame.size.height+10, TodaysTotalView.frame.size.width, TodaysTotalView.frame.size.height);
        tipsView.frame=CGRectMake(tipsView.frame.origin.x, TodaysTotalView.frame.origin.y+TodaysTotalView.frame.size.height+10, tipsView.frame.size.width, tipsView.frame.size.height);
    }
}

-(void)settext{
    [goOnlineBtn setTitle:JJLocalizedString(@"Go_Online", nil) forState:UIControlStateNormal];
    _lTripLbl.text=JJLocalizedString(@"Last_Trip", nil);
    _nEarningLbl.text=JJLocalizedString(@"NET_EARNINGS", nil);
    _tEarningsLbl.text=JJLocalizedString(@"Today_Earnings", nil);
    _eNetLbl.text=JJLocalizedString(@"ESTIMATED_NET", nil);
    _tTipsLbl.text=JJLocalizedString(@"Today_Tips", nil);
    _tLbl.text=JJLocalizedString(@"TIPS", nil);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateLoc:(CLLocation *)loc{
  
        isLocUpdated=YES;
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [web UpdateUserLocation:[self setParametersUpdateLocation:loc]
                        success:^(NSMutableDictionary *responseDictionary)
         {
             
             if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
                 
             }else{
                 isLocUpdated=NO;
                 [self.view makeToast:kErrorMessage];
             }
         }
                        failure:^(NSError *error)
         {
             isLocUpdated=NO;
            // [self.view makeToast:kErrorMessage];
             
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
                                  };
    return dictForuser;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)didClickGoOnlineBtn:(id)sender {
    if(isLocUpdated==YES){
        [self GoOnline];
        [self performSelector:@selector(enableLoginBtn) withObject:nil afterDelay:30];
    }else{
        UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"Oops", nil)
                                                           message:JJLocalizedString(@"Sorry_cant_able", nil)
                                                          delegate:nil
                                                 cancelButtonTitle:JJLocalizedString(@"OK", nil)
                                                 otherButtonTitles:nil];
        [alert show];
        
    }
    
    //    OpenInMapsViewController * objOpenInMaps=[self.storyboard instantiateViewControllerWithIdentifier:@"OpenInMapsVCSID"];
    //   [self.navigationController pushViewController:objOpenInMaps animated:true];
}
-(void)enableLoginBtn{
    goOnlineBtn.userInteractionEnabled=YES;
}
-(void)GoOnline{
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    goOnlineBtn.userInteractionEnabled=NO;
    [self showActivityIndicator:YES];
    [web UserGoOfflineOnLineUrl:[self setParametersUpdateUserOnOff:@"Yes"]
                        success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             [Theme SaveUSerISOnline:@"1"];
             HomeViewController * objHomeVC=[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVCSID"];
             [objHomeVC setLattitude:location.coordinate.latitude];
             [objHomeVC setLongitude:location.coordinate.longitude];
             [objHomeVC setVehicleNumber:vehNumber];
             [self.navigationController pushViewController:objHomeVC animated:YES];
             goOnlineBtn.userInteractionEnabled=YES;
         }else{
             [self stopActivityIndicator];
             [self.view makeToast:kErrorMessage];
             goOnlineBtn.userInteractionEnabled=YES;
         }
         
         
     }
                        failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [self.view makeToast:kErrorMessage];
         goOnlineBtn.userInteractionEnabled=YES;
         
     }];
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


- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}
#pragma mark -
#pragma mark ITRAirSideMenu Delegate

- (void)sideMenu:(ITRAirSideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(ITRAirSideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(ITRAirSideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(ITRAirSideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if(scrollView==starterScrollView){
//        CGFloat offset=starterScrollView.contentOffset.y;
//        CGFloat percentage=offset/184;
//        CGFloat value=184*percentage; // negative when scrolling up more than the top
//        // driven animation
//        currentMapView.frame=CGRectMake(0, value, currentMapView.bounds.size.width, 184-value);
//    }
//}
-(void)loadRating:(NSString *)ratingCount{
    float rateCount=[ratingCount floatValue];
    
    self.ratingView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
    self.ratingView.fullSelectedImage = [UIImage imageNamed:@"StarFill"];
    self.ratingView.contentMode = UIViewContentModeScaleAspectFill;
    self.ratingView.maxRating = 5;
    self.ratingView.minRating = 1;
    self.ratingView.rating = rateCount;
    self.ratingView.editable = NO;
    self.ratingView.halfRatings = YES;
    self.ratingView.floatRatings = YES;
}
@end
