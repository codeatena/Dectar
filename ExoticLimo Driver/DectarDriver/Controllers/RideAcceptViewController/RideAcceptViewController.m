//
//  RideAcceptViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/24/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "RideAcceptViewController.h"

@interface RideAcceptViewController (){
   
     CLLocation *location;
    NSInteger pushTag;
}

@end

@implementation RideAcceptViewController
@synthesize countValue,acceptHeaderLbl,rideAcceptScrollView,setMaximumValue,custIndicatorView,objRideAccRec,requestArray,requestTableView,badgeBtn,isBooked;

- (void)viewDidLoad {
    countValue=0;
    [super viewDidLoad];
    pushTag=1;
    [requestTableView registerNib:[UINib nibWithNibName:@"RequestAcceptTableViewCell" bundle:nil] forCellReuseIdentifier:@"RequestAcceptCellIdentifier"];
    requestTableView.estimatedRowHeight=168;
    requestTableView.rowHeight=UITableViewAutomaticDimension;
    [self setFontAndColor];
     [self playAudio];
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
    [requestTableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTableRefreshNotification:)
                                                 name:kDriverReceiveNotif
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveReturnNotification:)
                                                 name:kDriverReturnNotif
                                               object:nil];
    requestTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
}
- (void)receiveReturnNotification:(NSNotification *) notification
{
    
    if(self.view.window){
        isBooked=NO;
        [self stopAudioAndMoveToHome];
    }
}
- (void)receiveTableRefreshNotification:(NSNotification *) notification
{
    NSLog(@"Received APNS with userInfo %@", notification.userInfo);
    NSDictionary * dict=notification.userInfo;
    if(self.view.window){
        
        if([requestArray count]>0&&[requestArray count]<5){
            RideAcceptRecord * objRideAcceptRec=[[RideAcceptRecord alloc]init];
            objRideAcceptRec.LocationName=[Theme checkNullValue:[dict objectForKey:@"key3"]];
            objRideAcceptRec.RideId=[Theme checkNullValue:[dict objectForKey:@"key1"]];
            objRideAcceptRec.expiryTime=[Theme checkNullValue:[dict objectForKey:@"key2"]];
            pushTag++;
            NSString * pickuprequest=@"PickUp_Request";
            objRideAcceptRec.headerTxt=[Theme checkNullValue:[NSString stringWithFormat:@"%@ %ld",pickuprequest,(long)pushTag]];
            objRideAcceptRec.rideTag=pushTag;
            NSInteger expValue=[objRideAcceptRec.expiryTime integerValue];
            if(expValue<=5){
                objRideAcceptRec.expiryTime=@"15";
            }
            objRideAcceptRec.currentTimer=0;
            [requestArray addObject:objRideAcceptRec];
            [self playAudioNotif];
            badgeBtn=[self setbadgeToButton:badgeBtn withBadgeCount:[requestArray count]];
        }
         [requestTableView reloadData];
       
        
    }
}
-(void)playAudio{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/audio1.wav", [[NSBundle mainBundle] resourcePath]]];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = -1;
    [audioPlayer play];
}
- (void) stopAudio
{
    [audioPlayer stop];
    [audioPlayer setCurrentTime:0];
}
-(void)playAudioNotif{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Dingdong.wav", [[NSBundle mainBundle] resourcePath]]];
    
    NSError *error;
    audioPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audioPlayer1 play];
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
        
    }
    // NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
}

-(void)setDatasToView{

    setMaximumValue=[objRideAccRec.expiryTime floatValue];
    
}
-(void)setFontAndColor{
    acceptHeaderLbl.text=JJLocalizedString(@"Tap_to_accept_the_ride", nil);
    acceptHeaderLbl=[Theme setHeaderFontForLabel:acceptHeaderLbl];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(NSDictionary *)setParametersForAcceptRide:(NSString *)acceptRideId{
    NSString * latitude=@"";
    NSString * longitude=@"";
    if(location.coordinate.latitude!=0){
        latitude=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
        longitude=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
    }
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"ride_id":acceptRideId,
                                  @"driver_lat":latitude,
                                  @"driver_lon":longitude
                                  };
    return dictForuser;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillDisappear:(BOOL)animated{
    [self stopAudio];
    for (UIView *view in requestTableView.subviews) {
        for (RequestAcceptTableViewCell *cell in view.subviews) {
            if([cell isKindOfClass:[RequestAcceptTableViewCell class]]){
                [cell.spinTimer stop];
                [cell.countDownTimerLbl pause];
            }
        }
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [requestArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RequestAcceptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RequestAcceptCellIdentifier"];
    if (cell == nil) {
        cell = [[RequestAcceptTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:@"RequestAcceptCellIdentifier"];
    }
   
    cell.delegate=self;
    [cell setIndexpath:indexPath];
    RideAcceptRecord * objAcceptRecs=[[RideAcceptRecord alloc]init];
    objAcceptRecs =[requestArray objectAtIndex:indexPath.row];
    [cell setDatasToAcceptCell:objAcceptRecs];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
     [cell layoutIfNeeded];
    return cell;
}

-(void)updateRecordCellWhenSpinnerStarts:(NSInteger)riderTag withIndex:(NSIndexPath *)index{
    for (int i=0; i<[requestArray count]; i++) {
        RideAcceptRecord * objAcceptRecs=[[RideAcceptRecord alloc]init];
        objAcceptRecs =[requestArray objectAtIndex:i];
        if(objAcceptRecs.rideTag==riderTag){
            objAcceptRecs.rideCountStart=YES;
        }
        [requestArray setObject:objAcceptRecs atIndexedSubscript:i];
    }
    badgeBtn=[self setbadgeToButton:badgeBtn withBadgeCount:[requestArray count]];
    if([requestArray count]==0){
        [self stopAudioAndMoveToHome];
    }
    
}

-(void)RemoveCellWhenRequestExpired:(NSInteger)riderTag withIndex:(NSIndexPath *)index{
    if([requestArray count]>0){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [requestArray removeObjectAtIndex:indexPath.row];
        
        
        [requestTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
    }
    [requestTableView reloadData];
    badgeBtn=[self setbadgeToButton:badgeBtn withBadgeCount:[requestArray count]];
    if([requestArray count]==0){
        [self stopAudioAndMoveToHome];
    }
}

-(void)rejectParticularRide:(NSInteger)riderTag withIndex:(NSIndexPath *)index{
    
    for (int i=0; i<[requestArray count]; i++) {
        RideAcceptRecord * objAcceptRecs=[[RideAcceptRecord alloc]init];
        objAcceptRecs =[requestArray objectAtIndex:i];
        if(objAcceptRecs.rideTag==riderTag){
            [requestArray removeObject:objAcceptRecs];
            [requestTableView reloadData];
        }
    }
    badgeBtn=[self setbadgeToButton:badgeBtn withBadgeCount:[requestArray count]];
    if([requestArray count]==0){
        [self stopAudioAndMoveToHome];
    }
}
-(void)AcceptRide:(NSInteger)riderTag withIndex:(NSIndexPath *)index{
    requestTableView.userInteractionEnabled=NO;
    [self showActivityIndicator:YES];
    if([requestArray count]>0){
        
        RequestAcceptTableViewCell *cell = [requestTableView cellForRowAtIndexPath:index];
        [cell.spinTimer stop];
        [cell.countDownTimerLbl pause];
        
        RideAcceptRecord * objAcceptRecs=[[RideAcceptRecord alloc]init];
        objAcceptRecs =[requestArray objectAtIndex:index.row];
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [web DriverAccept:[self setParametersForAcceptRide:objAcceptRecs.RideId]
                  success:^(NSMutableDictionary *responseDictionary)
         {
             requestTableView.userInteractionEnabled=YES;
             [self stopActivityIndicator];
             
             if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
                 isBooked=YES;
                 [self stopAudio];
                 NSDictionary * dict=responseDictionary[@"response"][@"user_profile"];
                 RiderRecords * objRiderRecords=[[RiderRecords alloc]init];
                 objRiderRecords.RideId=[Theme checkNullValue:[dict objectForKey:@"ride_id"]];
                  objRiderRecords.UserId=[Theme checkNullValue:[dict objectForKey:@"user_id"]];
                 objRiderRecords.userEmail=[Theme checkNullValue:[dict objectForKey:@"user_email"]];
                 objRiderRecords.userImage=[Theme checkNullValue:[dict objectForKey:@"user_image"]];
                 objRiderRecords.userName=[Theme checkNullValue:[dict objectForKey:@"user_name"]];
                 objRiderRecords.userLocation=[Theme checkNullValue:[dict objectForKey:@"pickup_location"]];
                 objRiderRecords.userLattitude=[Theme checkNullValue:[dict objectForKey:@"pickup_lat"]];
                 objRiderRecords.userLongitude=[Theme checkNullValue:[dict objectForKey:@"pickup_lon"]];
                 objRiderRecords.userReview=[Theme checkNullValue:[dict objectForKey:@"user_review"]];
                 objRiderRecords.userTime=[Theme checkNullValue:[dict objectForKey:@"pickup_time"]];
                 objRiderRecords.userPhoneNumber=[Theme checkNullValue:[dict objectForKey:@"phone_number"]];
                 
                 objRiderRecords.hasDropLocation=[Theme checkNullValue:[dict objectForKey:@"drop_location"]];
                 objRiderRecords.dropAddress=[Theme checkNullValue:[dict objectForKey:@"drop_loc"]];
                 objRiderRecords.dropLat=[Theme checkNullValue:[dict objectForKey:@"drop_lat"]];
                 objRiderRecords.dropLong=[Theme checkNullValue:[dict objectForKey:@"drop_lon"]];
                 RideUserViewController * objRideUserVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RideUserVCSID"];
                 [objRideUserVc setObjRiderRecords:objRiderRecords];
                 [self.navigationController pushViewController:objRideUserVc animated:YES];
             }else{
                 isBooked=NO;
                 requestTableView.userInteractionEnabled=YES;
                 [self stopActivityIndicator];
                 [self.view makeToast:@"Ride_not_accepted"];
                 [self.delegate ridecancelled];
                 [self rejectParticularRide:objAcceptRecs.rideTag withIndex:index];
                 
                 
             }
         }
                  failure:^(NSError *error)
         {
              isBooked=NO;
             requestTableView.userInteractionEnabled=YES;
             [self stopActivityIndicator];
             [self rejectParticularRide:objAcceptRecs.rideTag withIndex:index];
         }];
    }
    
    
   
    
    
    
    if([requestArray count]==0){
        [self stopAudioAndMoveToHome];
    }
    badgeBtn=[self setbadgeToButton:badgeBtn withBadgeCount:[requestArray count]];
}

-(void)stopAudioAndMoveToHome{
    [self stopAudio];
    if(isBooked==NO){
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(UIButton *)setbadgeToButton:(UIButton *)btnName withBadgeCount:(NSInteger)badgeCount{
    [btnName.badgeView setBadgeValue:badgeCount];
    [btnName.badgeView setIsTop:NO];
    [btnName.badgeView setPosition:MGBadgePositionTopRight];
    [btnName.badgeView setBadgeColor:[UIColor redColor]];
    return btnName;
}

@end
