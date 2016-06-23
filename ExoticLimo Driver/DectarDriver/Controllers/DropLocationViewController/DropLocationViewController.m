//
//  DropLocationViewController.m
//  DectarDriver
//
//  Created by Aravind Natarajan on 13/02/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import "DropLocationViewController.h"

@interface DropLocationViewController (){
    CLLocationCoordinate2D finalDestLocation;
}

@end

@implementation DropLocationViewController

@synthesize filteredContentList,locSearchBar,locTableView,locationStr,Camera,GoogleMap,marker,mapView,lattitude,
longitude,Destmarker,doneBtn,custIndicatorView,selLocStr,msgView;

- (void)viewDidLoad {
    [super viewDidLoad];
    doneBtn.hidden=YES;
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [_headerlbl setText:JJLocalizedString(@"Select_Drop_Location", nil)];
    [doneBtn setTitle:JJLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [locSearchBar setPlaceholder:JJLocalizedString(@"Select_Drop_Location", nil)];
    [_hint_lbl setText:JJLocalizedString(@"Long_press_on_the_map", nil)];
    
    marker=[[GMSMarker alloc]init];
     Destmarker=[[GMSMarker alloc]init];
    [self loadGoogleMap];
 [locSearchBar setReturnKeyType:UIReturnKeyDone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name: UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide) name: UIKeyboardDidHideNotification object:nil];
    
    msgView.layer.masksToBounds = NO;
    msgView.layer.shadowOffset = CGSizeMake(-15, 20);
    msgView.layer.shadowRadius = 5;
    msgView.layer.shadowOpacity = 0.5;
    [_locationManager startUpdatingLocation];
    // Do any additional setup after loading the view.
}
-(void)keyboardDidShow{
    locTableView.hidden=NO;
}
-(void)keyboardDidHide{
   locTableView.hidden=YES;
}
- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    [locSearchBar resignFirstResponder];
  //  locTableView.hidden=YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [locSearchBar resignFirstResponder];
   // locTableView.hidden=YES;
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
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
        }
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self stopActivityIndicator];
    lattitude=newLocation.coordinate.latitude;
    longitude=newLocation.coordinate.longitude;
    
    marker.position = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    marker.icon = [UIImage imageNamed:@"CarMarker"];
    NSString * youHere=JJLocalizedString(@"You_are_Here", nil);
    
    marker.snippet = [NSString stringWithFormat:@"%@",youHere];
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = GoogleMap;
    [self.locationManager stopUpdatingLocation];
   
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
                                                  zoom:17];
    }
    
    GoogleMap = [GMSMapView mapWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height) camera:Camera];
    marker.position = Camera.target;
    NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
   
    
    marker.icon = [UIImage imageNamed:@"CarMarker"];
    NSString * youHere=JJLocalizedString(@"You_are_Here", nil);

    marker.snippet = [NSString stringWithFormat:@"%@\n%@", [myDictionary objectForKey:@"driver_name"],youHere];
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = GoogleMap;
    //GoogleMap.myLocationEnabled = YES;
    GoogleMap.userInteractionEnabled=YES;
    GoogleMap.delegate = self;
    [mapView addSubview:GoogleMap];
}
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
    if(coordinate.latitude!=0){
        
        Destmarker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        Destmarker.icon = [UIImage imageNamed:@"DestinationPin"];
        NSString * yourDestination=JJLocalizedString(@"Your_Destination", nil);

        Destmarker.snippet = [NSString stringWithFormat:@"%@",yourDestination];
        Destmarker.appearAnimation = kGMSMarkerAnimationPop;
        Destmarker.map = GoogleMap;
        [self getGoogleAdrressFromLatLong:coordinate.latitude lon:coordinate.longitude];
    }else{
        [self.view makeToast:@"Cant_able_to_get_location"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [filteredContentList count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.text = [filteredContentList objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    return cell;
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *text1=[searchBar.text stringByAppendingString:text];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web SearchGoogleLocation:[self setParametersForLocation:text1]
                      success:^(NSMutableDictionary *responseDictionary)
     {
         NSLog(@"%@",responseDictionary);
         NSMutableArray *results = (NSMutableArray *) responseDictionary[@"predictions"];
         //filteredContentList=[[NSMutableArray alloc]init];
         filteredContentList  = (NSMutableArray *) [results valueForKey:@"description"];
         [locTableView reloadData];
         if(filteredContentList.count>0){
             locTableView.hidden=NO;
            
         }else{
              locTableView.hidden=YES;
         }
         if(searchBar.text.length>0){
          // [searchBar setShowsCancelButton:YES animated:YES];
             
         }else{
             doneBtn.hidden=YES;
            // [searchBar setShowsCancelButton:NO animated:YES];
         }
     }
                      failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [self.view makeToast:kErrorMessage];
         
     }];
    
    return YES;
}

-(NSDictionary *)setParametersForLocation:(NSString *)str{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"input":str,
                                  @"key":kGoogleServerKey,
                                  };
    return dictForuser;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [locSearchBar resignFirstResponder];
    locSearchBar.text=[filteredContentList objectAtIndex:indexPath.row];
    selLocStr =  locSearchBar.text;
   
    [self getGoogleAdrressFromStr:locSearchBar.text];
    
    //locTableView.hidden=YES;
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)didClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickDoneBtn:(id)sender {
    
     [self stopActivityIndicator];
    if(finalDestLocation.latitude!=0){
        [self.delegate sendDropLocation:finalDestLocation];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.view makeToast:@"Cant_able_to_get_location"];
        
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
   // [searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar setText:@""];
    [filteredContentList removeAllObjects];
    [locTableView reloadData];
  //  locTableView.hidden=YES;
      doneBtn.hidden=YES;
}


-(void)getGoogleAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon{
    
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getGoogleLatLongToAddress:[self setParameters:lat withLon:lon]
                success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         
         @try {
              NSArray* jsonResults = [[responseDictionary valueForKey:@"results"] valueForKey:@"formatted_address"];
             
             if([jsonResults count]>0){
                 if(jsonResults.count>=2){
                     selLocStr=[Theme checkNullValue: [jsonResults objectAtIndex:1]];
                     [locSearchBar setText:selLocStr];
                     finalDestLocation.latitude = (CLLocationDegrees)lat;
                     finalDestLocation.longitude = (CLLocationDegrees)lon;
                     doneBtn.hidden=NO;
                 }else{
                     selLocStr=[Theme checkNullValue: [jsonResults objectAtIndex:0]];
                     [locSearchBar setText:selLocStr];
                     finalDestLocation.latitude = (CLLocationDegrees)lat;
                     finalDestLocation.longitude = (CLLocationDegrees)lon;
                     doneBtn.hidden=NO;
                 }
                 
             }else{
                 [self.view makeToast:@"can't_find_address"];
             }
         }
         @catch (NSException *exception) {
           [self.view makeToast:@"can't_find_address"];
         }
        
     }
                failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [self.view makeToast:@"can't_find_address"];
         
     }];

}

-(NSDictionary *)setParameters:(float )lat withLon:(float)lon{
    
    NSDictionary *dictForuser = @{
                                  @"latlng":[NSString stringWithFormat:@"%f,%f",lat,lon],
                                  @"sensor":@"false",
                                  @"key":kGoogleServerKey
                                  };
    return dictForuser;
}



-(void)getGoogleAdrressFromStr:(NSString *)addrStr{
    
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getGoogleLatLongToAddress:[self setParametersToaddr:addrStr]
                           success:^(NSMutableDictionary *responseDictionary)
     {
         @try {
             [self stopActivityIndicator];
             NSArray* jsonResults = [responseDictionary valueForKey:@"results"][0][@"geometry"][@"location"];
             if([jsonResults count]>0){
                 double latitude1 = 0, longitude1 = 0;
                 
                 latitude1 = [[jsonResults valueForKey:@"lat"] doubleValue];
                 longitude1 = [[jsonResults valueForKey:@"lng"] doubleValue];
                 CLLocationCoordinate2D center;
                 center.latitude=latitude1;
                 center.longitude = longitude1;
                 Destmarker.position = CLLocationCoordinate2DMake(center.latitude, center.longitude);
                 
                 Destmarker.icon = [UIImage imageNamed:@"DestinationPin"];
                 NSString * yourDestination=JJLocalizedString(@"Your_Destination", nil);

                 Destmarker.snippet = [NSString stringWithFormat:@"%@",yourDestination];
                 Destmarker.appearAnimation = kGMSMarkerAnimationPop;
                 Destmarker.map = GoogleMap;
                 finalDestLocation.latitude = (CLLocationDegrees)latitude1;
                 finalDestLocation.longitude = (CLLocationDegrees)longitude1;
                 doneBtn.hidden=NO;
                
                  GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:marker.position coordinate:Destmarker.position];
                 GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0f];
                
                 [GoogleMap animateWithCameraUpdate:update];
                 
             }else{
                 [self.view makeToast:@"can't_find_address"];
             }
         }
         @catch (NSException *exception) {
             
         }
         
        
     }
                           failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [self.view makeToast:@"can't_find_address"];
         
     }];
    
}

-(NSDictionary *)setParametersToaddr:(NSString *)addr{
    
    NSDictionary *dictForuser = @{
                                  @"address":addr,
                                  @"sensor":@"false",
                                   @"key":kGoogleServerKey
                                  };
    return dictForuser;
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
