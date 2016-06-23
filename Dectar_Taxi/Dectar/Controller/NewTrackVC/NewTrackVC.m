//
//  NewTrackVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 12/30/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import "NewTrackVC.h"
#import <CoreLocation/CoreLocation.h>
#import "Blurview.h"
#import "UrlHandler.h"
#import "Themes.h"
#import "Constant.h"
#import "ASIHTTPRequest.h"
#import "MarkerView.h"
#import "CancelRideVC.h"
#import "UIImageView+Network.h"
#import "RatingVC.h"
#import "NewViewController.h"
#import "Driver_Record.h"
#import "HelpVC.h"
#import "LanguageHandler.h"


@interface NewTrackVC ()<UIScrollViewDelegate>
{
    CLLocationManager * currentLocation;
    BOOL isSelected;
    Blurview* view;
    NSTimer *SerivceHitting;
    GMSMarker*PickUpmarker;
    GMSMarker*Dropmarker;
    GMSMarker*Drivermarker;
    GMSMarker*userMarker;
    Driver_Record*objDriver;
    NSString * PickUpTime_Str;
    UILabel *label ;
    AppDelegate *appDel;
}
@end

@implementation NewTrackVC
@synthesize TrackObj,DriverName,CarModel,CarNumber,Driver_latitude,Driver_longitude,Driver_MobileNumber,GoogleMap,Camera,MapBG,Ride_ID,Reason_ID,Reason_Str,rating,User_latitude,User_longitude,Cancel_Ride,Driver_image,Cap_image;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!appDel) {
        appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    appDel.currentView = @"NewTrackVC";
    
    [GoogleMap setMyLocationEnabled:NO];
    
    Camera = [GMSCameraPosition cameraWithLatitude: User_latitude
                                         longitude: User_longitude
                                              zoom:17];
    [GoogleMap animateToCameraPosition:Camera];
    GoogleMap = [GMSMapView mapWithFrame:CGRectMake(0, 0, MapBG.frame.size.width , MapBG.frame.size.height) camera:Camera];
    [MapBG addSubview:GoogleMap];
    
    
    [_PanicBtn setHidden:YES];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewVc:) name:@"payment_paid" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cabCame:) name:@"cab_arrived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CompleteRide:) name:@"ride_completed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RideStared:) name:@"Ride_start" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateDriverPlace:) name:@"Updatedriver_loc" object:nil];
    
    /*User_latitude= 13.045804;
     User_longitude= 80.276994;
     
     Driver_latitude=  12.967348;
     Driver_longitude= 80.152689;*/
    
    _PanicBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    _PanicBtn.layer.shadowOpacity = 0.5;
    _PanicBtn.layer.shadowRadius = 2;
    _PanicBtn.layer.shadowOffset = CGSizeMake(5.0f,5.0f);
    
    Driver_image.layer.cornerRadius=Driver_image.frame.size.width/2;
    Driver_image.layer.masksToBounds=YES;
    
    Cap_image.layer.cornerRadius=Cap_image.frame.size.width/2;
    Cap_image.layer.masksToBounds=YES;
    
    PickUpmarker=[[GMSMarker alloc]init];
    Dropmarker=[[GMSMarker alloc]init];
    Drivermarker=[[GMSMarker alloc]init];
    userMarker=[[GMSMarker alloc]init];
    
    //[self.parallax_Scroll setDelegate:self];
    // [self.parallax_Scroll setContentSize:CGSizeMake(self.parallax_Scroll.frame.size.width,800)];

    _contact.layer.borderColor = [UIColor whiteColor].CGColor;
    _contact.layer.borderWidth = 1.0f;
    _contact.layer.masksToBounds = YES;
    
    Cancel_Ride.layer.borderColor = [UIColor whiteColor].CGColor;
    Cancel_Ride.layer.borderWidth = 1.0f;
    Cancel_Ride.layer.masksToBounds = YES;
    
    [self setDatasToView];
    
    if (TrackObj.isCancel==YES)
    {
        [self TrackDriver:self];
        [self setTimeOverMarker];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_Title_lbl setText:JJLocalizedString(@"Track_Driver", nil)];
    [_done_btn setTitle:JJLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [Cancel_Ride setTitle:JJLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    //[_contact setTitle:JJLocalizedString(@"Contact", nil) forState:UIControlStateNormal];
    [_contact setTitle:@"Contact Driver" forState:UIControlStateNormal];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)setObjrecFar:(FareRecord *)objrecFar
{
    Ride_ID=objrecFar.ride_id;
    [self UpdateDriverLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)UpdateDriverLocation
{
    NSDictionary * parameters=@{@"ride_id":Ride_ID};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web Track_Driver:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         NSLog(@"%@",responseDictionary);
         
         if ([responseDictionary count]>0)
         {
             responseDictionary=[Themes writableValue:responseDictionary];
             NSString * comfiramtion=[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"status"]];
             [Themes StopView:self.view];
             
             if ([comfiramtion isEqualToString:@"1"])
             {
                 NSDictionary * drivDict=[[responseDictionary objectForKey:@"response"]objectForKey:@"driver_profile"];
                 
                 DriverName.text=[Themes checkNullValue:[drivDict objectForKey:@"driver_name"]];
                 CarNumber.text=[Themes checkNullValue:[drivDict valueForKey:@"vehicle_model"]];
                 CarModel.text=[Themes checkNullValue:[drivDict valueForKey:@"vehicle_number"]];
                 Driver_MobileNumber=[Themes checkNullValue:[drivDict valueForKey:@"phone_number"]];
                 Driver_longitude=[[drivDict valueForKey:@"driver_lon"] doubleValue];
                 Driver_latitude=[[drivDict valueForKey:@"driver_lat"] doubleValue];
                 User_longitude=[[drivDict valueForKey:@"rider_lon"] doubleValue];
                 User_latitude=[[drivDict valueForKey:@"rider_lat"]doubleValue];
                 PickUpTime_Str=[Themes checkNullValue:[drivDict valueForKey:@"min_pickup_duration"]];
                 rating.text=[NSString stringWithFormat:@"%@",[Themes checkNullValue:[drivDict valueForKey:@"driver_review"]]];
                 Ride_ID=[Themes checkNullValue:[[responseDictionary valueForKey:@"response"]valueForKey:@"ride_id"]];
                 
                 NSString * Imageurl=[Themes checkNullValue:[drivDict valueForKey:@"driver_image"]];
                 NSString *trimmedString=[Imageurl substringFromIndex:MAX((int)[Imageurl length]-15, 0)];
                 NSString * cacheStr=[NSString stringWithFormat:@"MyRiDAct_%@",trimmedString];
                 [Driver_image loadImageFromURL:[NSURL URLWithString:Imageurl] placeholderImage:[UIImage imageNamed:@"driverSample.png"] cachingKey:cacheStr];
                 
                 NSString * Status=[drivDict valueForKey:@"ride_status"];
                 NSArray *dropStatus=[drivDict valueForKey:@"drop"] ;
                 if(dropStatus.count>0)
                 {
                     self.dr_Lat=[Themes checkNullValue:[[dropStatus valueForKey:@"latlong"] objectForKey:@"lat"]];
                     self.dr_Lon=[Themes checkNullValue:[[dropStatus valueForKey:@"latlong"] valueForKey:@"lon"]];
                 }
                 
                 if ([Status isEqualToString:JJLocalizedString(@"Arrived", nil)]) {
                     [_Title_lbl setText:JJLocalizedString(@"Cab_Arrived", nil)];
                     [GoogleMap clear];
                     
                     Drivermarker.position = CLLocationCoordinate2DMake(Driver_latitude, Driver_longitude);
                     Drivermarker.appearAnimation=kGMSMarkerAnimationPop;
                     UIImage *markerIcon = [UIImage imageNamed:@"pointer"];
                     Drivermarker.icon = markerIcon;
                     Drivermarker.map = GoogleMap;
                     
                     userMarker.position=CLLocationCoordinate2DMake(Driver_latitude, Driver_longitude);
                     userMarker.appearAnimation=kGMSMarkerAnimationPop;
                     UIImage *markerIcon2 = [UIImage imageNamed:@"pin"];
                     userMarker.icon = markerIcon2;
                     userMarker.map = GoogleMap;
                     
                     Camera = [GMSCameraPosition cameraWithLatitude: Driver_latitude
                                                          longitude:Driver_longitude
                                                               zoom:17];
                     
                     [GoogleMap animateToCameraPosition:Camera];
                 }
                 else if ([Status isEqualToString:JJLocalizedString(@"Onride", nil)])
                 {
                     [_Title_lbl setText:JJLocalizedString(@"Enjoy_Your_Ride", nil) ];
                     [GoogleMap clear];
                     [_PanicBtn setHidden:NO];
                     
                     PickUpmarker.position = CLLocationCoordinate2DMake(User_latitude, User_longitude);
                     PickUpmarker.appearAnimation=kGMSMarkerAnimationPop;
                     UIImage *markerIcon = [UIImage imageNamed:@"pin"];
                     PickUpmarker.icon = markerIcon;
                     PickUpmarker.map = GoogleMap;
                     
                     Dropmarker.position=CLLocationCoordinate2DMake([self.dr_Lat doubleValue], [self.dr_Lon doubleValue]);
                     Dropmarker.appearAnimation=kGMSMarkerAnimationPop;
                     UIImage *markerIcon2 = [UIImage imageNamed:@"pin"];
                     Dropmarker.icon = markerIcon2;
                     Dropmarker.map = GoogleMap;
                     
                     [self Droplocation:Driver_latitude userlng:Driver_longitude drop:[self.dr_Lat doubleValue] droplng:[self.dr_Lon doubleValue]];
                     
                 }
                 else if ([Status isEqualToString:JJLocalizedString(@"Finished", nil)])
                     
                 {
                     [_Title_lbl setText:JJLocalizedString(@"Ride_Completed", nil)];
                     
                     Drivermarker.position = CLLocationCoordinate2DMake(Driver_latitude, Driver_longitude);
                     Drivermarker.appearAnimation=kGMSMarkerAnimationPop;
                     UIImage *markerIcon = [UIImage imageNamed:@"pointer"];
                     Drivermarker.icon = markerIcon;
                     Drivermarker.map = GoogleMap;
                     
                     userMarker.position=CLLocationCoordinate2DMake(Driver_latitude, Driver_longitude);
                     userMarker.appearAnimation=kGMSMarkerAnimationPop;
                     UIImage *markerIcon2 = [UIImage imageNamed:@"pin"];
                     userMarker.icon = markerIcon2;
                     userMarker.map = GoogleMap;
                     
                     Camera = [GMSCameraPosition cameraWithLatitude: Driver_latitude
                                                          longitude:Driver_longitude
                                                               zoom:17];
                     
                     [GoogleMap animateToCameraPosition:Camera];
                     
                     //[self Droplocation:User_latitude userlng:User_longitude drop:[self.dr_Lat doubleValue] droplng:[self.dr_Lon doubleValue]];
                     
                     [self changeCompleteStatus];

                 }
                 /* else
                  {
                  [self TrackDriver:self];
                  [self setTimeOverMarker];
                  
                  }*/
                 [Cancel_Ride setHidden:YES];
                 
             }
         }
         
         
     }
     
              failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
    
    
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

///////////////////////////////////////////
-(void)UpdateDriverPlace:(NSNotification*)notification
{
    if (self.view.window)
    {
        objDriver=[notification object];
        if ([objDriver.RideID isEqualToString:Ride_ID])
        {
            Drivermarker.position=CLLocationCoordinate2DMake([objDriver.Driver_latitude doubleValue], [objDriver.Driver_longitude doubleValue]);
            
            Drivermarker.appearAnimation=kGMSMarkerAnimationPop;
            Drivermarker.map = GoogleMap;
            UIImage *mapicon=[UIImage imageNamed:@"pointer"];
            Drivermarker.icon = mapicon;
            
            
            
            /* CLLocation *locA = [[CLLocation alloc] initWithLatitude:User_latitude longitude:User_latitude];
             
             CLLocation *locB = [[CLLocation alloc] initWithLatitude:[objDriver.Driver_latitude doubleValue] longitude:[objDriver.Driver_longitude doubleValue]];
             
             CLLocationDistance distance = [locA distanceFromLocation:locB];
             
             NSLog(@"%f",distance);
             double kilometers=  [locA  distanceFromLocation: locB]/1000;
             float speed = 45.0;
             
             NSLog(@"Estimate time %f",(kilometers/speed));
             
             double timez;
             double minutes;
             double seconds;
             int hours;
             
             timez = kilometers / speed;
             timez = timez * 3600; // time duration in seconds
             minutes = floor(timez / 60);
             timez -= minutes * 60;
             seconds = floor(timez);
             hours = minutes/60;
             
             NSString *estimatedtime   = [NSString stringWithFormat:@"%@:%@:%@",hours > 9 ? [@(hours) stringValue] : [NSString stringWithFormat:@"0%@",[@(hours) stringValue]], minutes > 9 ? [@(minutes) stringValue] : [NSString stringWithFormat:@"0%@",[@(minutes) stringValue]], seconds > 9 ? [@(seconds) stringValue] : [NSString stringWithFormat:@"0%@",[@(seconds) stringValue]]];
             
             NSLog(@"%@",[NSString stringWithFormat:@"Estimated TIme :%@",estimatedtime]);*/
            
        }
        else
        {
            
        }
        
    }
}


-(void)setDatasToView
{
    DriverName.text=TrackObj.Driver_Name;
    CarNumber.text=TrackObj.Car_Number;
    CarModel.text=TrackObj.Car_Name;
    Driver_MobileNumber=TrackObj.Driver_moblNumber;
    Ride_ID=TrackObj.Ride_ID;
    Driver_longitude=TrackObj.longitude_driver;
    Driver_latitude=TrackObj.latitude_driver;
    rating.text=[NSString stringWithFormat:@"%@",TrackObj.rating];
    User_longitude=TrackObj.longitude_User;
    User_latitude=TrackObj.latitude_User;
    PickUpTime_Str=TrackObj.ETA;
    
    if ([TrackObj.Status isEqualToString:JJLocalizedString(@"Arrived", nil)]) {
        [_Title_lbl setText:JJLocalizedString(@"Cab_Arrived", nil)];
        [GoogleMap clear];
        //[self setTimeOverMarker];
        
        Drivermarker.position=CLLocationCoordinate2DMake(Driver_latitude, Driver_longitude);
        Drivermarker.appearAnimation=kGMSMarkerAnimationPop;
        UIImage *markerIcon = [UIImage imageNamed:@"pointer"];
        Drivermarker.icon = markerIcon;
        Drivermarker.map = GoogleMap;
        
        userMarker.position=CLLocationCoordinate2DMake(User_latitude, User_longitude);
        userMarker.appearAnimation=kGMSMarkerAnimationPop;
        UIImage *markerIcon2 = [UIImage imageNamed:@"pin"];
        userMarker.icon = markerIcon2;
        userMarker.map = GoogleMap;
        
        [self DrawDirectionPath:Driver_latitude userlng:Driver_longitude drop:User_latitude  droplng:User_longitude];
        
        
    }
    else if ([TrackObj.Status isEqualToString:JJLocalizedString(@"Onride", nil)])
    {
        [_Title_lbl setText:JJLocalizedString(@"Enjoy_Your_Ride", nil)];
        [GoogleMap clear];
        [_PanicBtn setHidden:NO];
        
        if (!PickUpmarker) {
            
            PickUpmarker = [[GMSMarker alloc] init];
        }
        if (!Dropmarker) {
            
            Dropmarker = [[GMSMarker alloc] init];
        }
        
        PickUpmarker.position = CLLocationCoordinate2DMake(User_latitude, User_longitude);
        PickUpmarker.appearAnimation=kGMSMarkerAnimationPop;
        UIImage *markerIcon = [UIImage imageNamed:@"pin"];
        PickUpmarker.icon = markerIcon;
        PickUpmarker.map = self.GoogleMap;
        
        Dropmarker.position=CLLocationCoordinate2DMake(TrackObj.Drop_latitude_User, TrackObj.Drop_longitude_User);
        Dropmarker.appearAnimation=kGMSMarkerAnimationPop;
        UIImage *markerIcon2 = [UIImage imageNamed:@"pin"];
        Dropmarker.icon = markerIcon2;
        Dropmarker.map = self.GoogleMap;
        
        
        //        PickUpmarker.position = CLLocationCoordinate2DMake(Driver_latitude, Driver_longitude);
        //        PickUpmarker.appearAnimation=kGMSMarkerAnimationPop;
        //        UIImage *markerIcon = [UIImage imageNamed:@"pin"];
        //        PickUpmarker.icon = markerIcon;
        //        PickUpmarker.map = GoogleMap;
        //
        //        Dropmarker.position=CLLocationCoordinate2DMake(TrackObj.Drop_latitude_User, TrackObj.Drop_longitude_User);
        //        Dropmarker.appearAnimation=kGMSMarkerAnimationPop;
        //        UIImage *markerIcon2 = [UIImage imageNamed:@"pin"];
        //        Dropmarker.icon = markerIcon2;
        //        Dropmarker.map = GoogleMap;
        
        [self Droplocation:Driver_latitude userlng:Driver_longitude drop:TrackObj.Drop_latitude_User droplng:TrackObj.Drop_longitude_User];
        
    }
    else if ([TrackObj.Status isEqualToString:JJLocalizedString(@"Finished", nil)])
        
    {
        [_Title_lbl setText:JJLocalizedString(@"Ride_Completed", nil)];
        [self changeCompleteStatus];

        [GoogleMap clear];
        
        userMarker.position=CLLocationCoordinate2DMake(Driver_latitude, Driver_longitude);
        userMarker.appearAnimation=kGMSMarkerAnimationPop;
        UIImage *markerIcon = [UIImage imageNamed:@"pin"];
        userMarker.icon = markerIcon;
        userMarker.map = GoogleMap;
        
        Drivermarker.position=CLLocationCoordinate2DMake(Driver_latitude, Driver_longitude);
        Drivermarker.appearAnimation=kGMSMarkerAnimationPop;
        UIImage *markerIcon2 = [UIImage imageNamed:@"pointer"];
        Drivermarker.icon = markerIcon2;
        Drivermarker.map = GoogleMap;
        
        [self DrawDirectionPath:Driver_latitude userlng:Driver_longitude drop:User_latitude  droplng:User_longitude];
    }
    else
    {
        Drivermarker.position=CLLocationCoordinate2DMake(Driver_latitude, Driver_longitude);
        Drivermarker.appearAnimation=kGMSMarkerAnimationPop;
        UIImage *markerIcon = [UIImage imageNamed:@"pointer"];
        Drivermarker.icon = markerIcon;
        Drivermarker.map = GoogleMap;
        
        UIImageView *pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maping"]];
        UIView *viewMarker = [[UIView alloc] initWithFrame:CGRectMake(0,0,pinImageView.frame.size.width,pinImageView.frame.size.height)];
        label = [UILabel new];
        label.frame=CGRectMake(pinImageView.center.x-20,pinImageView.center.y-30,pinImageView.frame.size.width,pinImageView.frame.size.height);
        //label.text = PickUpTime_Str;
        label.textColor=[UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Avenir-Medium" size:13.0f];
        [label sizeToFit];
        [viewMarker addSubview:pinImageView];
        [viewMarker addSubview:label];
        
        userMarker.position=CLLocationCoordinate2DMake(User_latitude, User_longitude);
        userMarker.appearAnimation=kGMSMarkerAnimationPop;
        UIImage *markerIcon1 = [self imageFromView:viewMarker];
        userMarker.icon = markerIcon1;
        userMarker.map = GoogleMap;
        
        [self DrawDirectionPath:Driver_latitude userlng:Driver_longitude drop:User_latitude  droplng:User_longitude];
    }
    
    if (TrackObj.isCancel==YES)
    {
        [Cancel_Ride setHidden:NO];
        
        
    }
    else
    {
        [Cancel_Ride setHidden:YES];
        
    }
    
    NSString *trimmedString=[TrackObj.DriverImage substringFromIndex:MAX((int)[TrackObj.DriverImage length]-15, 0)];
    NSString * cacheStr=[NSString stringWithFormat:@"MyRiDAct_%@",trimmedString];
    [Driver_image loadImageFromURL:[NSURL URLWithString:TrackObj.DriverImage] placeholderImage:[UIImage imageNamed:@"driverSample.png"] cachingKey:cacheStr];
}

-(void)Droplocation: (CGFloat )userlat userlng:(CGFloat )userlng drop:(CGFloat )droplat droplng:(CGFloat )droplng
{
    //Set Drop Location  PickUpmarker.position = CLLocationCoordinate2DMake(userlat, userlng);
    //Testing
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getGoogleRoute:[self setParametersDrawLocation:userlat withLocLong:userlng withDestLoc:droplat withDestLonf:droplng]
                success:^(NSMutableDictionary *responseDictionary)
     {
         @try {
             
             NSArray * arr=[responseDictionary objectForKey:@"routes"];
             GMSPath * pathDrawn;
             if([arr count]>0){
                 
                 
                 pathDrawn =[GMSPath pathFromEncodedPath:responseDictionary[@"routes"][0][@"overview_polyline"][@"points"]];
                 
                 GMSPolyline * singleLine = [GMSPolyline polylineWithPath:pathDrawn];
                 singleLine.strokeWidth = 10;
                 singleLine.strokeColor = BLUECOLOR;
                 singleLine.map = self.GoogleMap;
                 
                 GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:pathDrawn];
                 GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0f];
                 bounds=[bounds  initWithCoordinate:PickUpmarker.position coordinate:Dropmarker.position];
                 [GoogleMap animateWithCameraUpdate:update];
                 //  [_locationManager stopUpdatingLocation];
                 
             }else{
                 
                 // [self drawRoadRouteBetweenTwoPoints:location];
                 [self Toast:@"can't find route"];
             }
             
             
             
             
         }
         @catch (NSException *exception) {
             
         }
     }
                failure:^(NSError *error)
     {
         
         [self Toast:@"can't find route"];
     }];
}

-(void)cabCame:(NSNotification *)notification
{
    _objrecFar=[notification object];
    if ([_objrecFar.ride_id isEqualToString:Ride_ID])
    {
        [_Title_lbl setText:JJLocalizedString(@"Cab_Arrived", nil)];
        label.text = @"";
        [Cancel_Ride setHidden:NO];
        [GoogleMap clear];
        
        Drivermarker.position=CLLocationCoordinate2DMake([_objrecFar.driverLat floatValue], [_objrecFar.driverLong floatValue]);
        Drivermarker.appearAnimation=kGMSMarkerAnimationPop;
        UIImage *markerIcon = [UIImage imageNamed:@"pointer"];
        Drivermarker.icon = markerIcon;
        Drivermarker.map = GoogleMap;
        
        userMarker.position=CLLocationCoordinate2DMake([_objrecFar.driverLat floatValue], [_objrecFar.driverLong floatValue]);
        userMarker.appearAnimation=kGMSMarkerAnimationPop;
        UIImage *markerIcon2 = [UIImage imageNamed:@"pin"];
        userMarker.icon = markerIcon2;
        userMarker.map = GoogleMap;
        
        //[self setTimeOverMarker];
    }
}

- (void)setTimeOverMarker
{
    
    UIImageView *pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maping"]];
    UIView *viewMarker = [[UIView alloc] initWithFrame:CGRectMake(0,0,pinImageView.frame.size.width,pinImageView.frame.size.height)];
    label = [UILabel new];
    label.frame=CGRectMake(pinImageView.center.x-20,pinImageView.center.y-30,pinImageView.frame.size.width,pinImageView.frame.size.height);
    //label.text = PickUpTime_Str;
    label.textColor=[UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Avenir-Medium" size:13.0f];
    [label sizeToFit];
    [viewMarker addSubview:pinImageView];
    [viewMarker addSubview:label];
    
    userMarker.position=CLLocationCoordinate2DMake(User_latitude, User_longitude);
    userMarker.appearAnimation=kGMSMarkerAnimationPop;
    UIImage *markerIcon = [self imageFromView:viewMarker];
    userMarker.icon = markerIcon;
    userMarker.map = GoogleMap;
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:userMarker.position coordinate:Drivermarker.position];
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0f];
    //bounds = [bounds includingCoordinate:PickUpmarker.position   coordinate:Dropmarker.position];
    [GoogleMap animateWithCameraUpdate:update];
    
    
}
- (UIImage *)imageFromView:(UIView *)Customview
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(Customview.frame.size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(Customview.frame.size);
    }
    [Customview.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(void)RideStared:(NSNotification *)notification
{
    _objrecFar=[notification object];
    if ([_objrecFar.ride_id isEqualToString:Ride_ID])
    {
        [_Title_lbl setText:JJLocalizedString(@"Enjoy_Your_Ride", nil)];
        [Cancel_Ride setHidden:YES];
        [GoogleMap clear];
        [_PanicBtn setHidden:NO];
        
        PickUpmarker.position = CLLocationCoordinate2DMake([_objrecFar.driverLat doubleValue], [_objrecFar.driverLong doubleValue]);
        PickUpmarker.appearAnimation=kGMSMarkerAnimationPop;
        UIImage *markerIcon = [UIImage imageNamed:@"pin"];
        PickUpmarker.icon = markerIcon;
        PickUpmarker.map = GoogleMap;
        
        Dropmarker.position=CLLocationCoordinate2DMake([_objrecFar.DropLatitude doubleValue], [_objrecFar.DropLongitude doubleValue]);
        Dropmarker.appearAnimation=kGMSMarkerAnimationPop;
        UIImage *markerIcon2 = [UIImage imageNamed:@"pin"];
        Dropmarker.icon = markerIcon2;
        Dropmarker.map = GoogleMap;
        
        
        [self Droplocation:[_objrecFar.driverLat doubleValue] userlng:[_objrecFar.driverLong doubleValue] drop:[_objrecFar.DropLatitude doubleValue] droplng:[_objrecFar.DropLongitude doubleValue]];
        
    }
}

-(void)CompleteRide:(NSNotification*)notification
{
    _objrecFar=[notification object];
    if ([_objrecFar.ride_id isEqualToString:Ride_ID]) {
        [_Title_lbl setText:JJLocalizedString(@"Ride_Completed", nil)];
        [Cancel_Ride setHidden:YES];
        
        [self changeCompleteStatus];
    }
}

- (void)changeCompleteStatus
{
    
    [_Title_lbl setText:@""];
    _completedView.hidden = NO;
    
//    [_contact setTitle:@"Contact Driver" forState:UIControlStateNormal];
//    [_contact setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    for (UIView *subview in _borders)
    {
        subview.hidden = YES;
    }
    
    _doneBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _doneBtn.layer.borderWidth = 1.0f;
    _doneBtn.layer.masksToBounds = YES;
    _PanicBtn.hidden = YES;
    
}

-(IBAction)Panic_action:(id)sender
{
    HelpVC * ObjHelpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpVCID"];
    [self.navigationController pushViewController:ObjHelpVC animated:YES];
    
}

-(NSDictionary *)setParametersDrawLocation:(CGFloat )loclat withLocLong:(CGFloat)locLong withDestLoc:(CGFloat)destLoc withDestLonf:(CGFloat)destLong{
    
    NSDictionary *dictForuser = @{
                                  @"origin":[NSString stringWithFormat:@"%f,%f",loclat,locLong],
                                  @"destination":[NSString stringWithFormat:@"%f,%f",destLoc,destLong],
                                  @"sensor":@"true",
                                  @"key":GoogleServerKey
                                  };
    return dictForuser;
}


- (IBAction)TrackDriver:(id)sender {
    
    //    Camera = [GMSCameraPosition cameraWithLatitude: Driver_latitude
    //                                         longitude: Driver_longitude
    //                                              zoom:17];
    //
    //    [GoogleMap animateToCameraPosition:Camera];
    
    Drivermarker.position=CLLocationCoordinate2DMake(Driver_latitude, Driver_longitude);
    Drivermarker.map = GoogleMap;
    UIImage *mapicon=[UIImage imageNamed:@"pointer"];
    Drivermarker.icon = mapicon;
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView==_parallax_Scroll){
        float y = scrollView.contentOffset.y;
        CGRect imageFrame = self.MapBG.frame;
        imageFrame.origin.y = y/2.0;
        self.MapBG.frame = imageFrame;
    }
    
}
- (IBAction)cancel_action:(id)sender {
    CancelRideVC * ObjCancelRideVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CancelRideVCID"];
    [ObjCancelRideVC setRide_ID:Ride_ID];
    [self.navigationController pushViewController:ObjCancelRideVC animated:YES];
    
}
- (IBAction)call_Action:(id)sender {
    
    NSString* actionStr = [NSString stringWithFormat:@"telprompt:%@",Driver_MobileNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionStr]];
    
}
- (IBAction)Done_Action:(id)sender {
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [del LogIn];
}
-(void)DrawDirectionPath: (CGFloat )userlat userlng:(CGFloat )userlng drop:(CGFloat )droplat droplng:(CGFloat )droplng
{
    //Testing
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getGoogleRoute:[self setParametersDrawLocation:userlat withLocLong:userlng withDestLoc:droplat withDestLonf:droplng]
                success:^(NSMutableDictionary *responseDictionary)
     {
         @try {
             NSArray * arr=[responseDictionary objectForKey:@"routes"];
             GMSPath *    pathDrawn;
             if([arr count]>0){
                 pathDrawn =[GMSPath pathFromEncodedPath:responseDictionary[@"routes"][0][@"overview_polyline"][@"points"]];
                 GMSPolyline * singleLine = [GMSPolyline polylineWithPath:pathDrawn];
                 singleLine.strokeWidth = 10;
                 singleLine.strokeColor = BLUECOLOR;
                 singleLine.map = self.GoogleMap;
                 
                 GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:pathDrawn];
                 GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0f];
                 bounds = [bounds initWithCoordinate:userMarker.position   coordinate:Drivermarker.position];
                 [GoogleMap animateWithCameraUpdate:update];
                 
             }else{
                 
                 [self Toast:@"can't find route"];
             }
             
             
             
         }
         @catch (NSException *exception) {
             
         }
         
         
     }
                failure:^(NSError *error)
     {
         [self Toast:@"can't find route"];
     }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    appDel.currentView = @"";
    [super viewWillDisappear:animated];
}

@end
