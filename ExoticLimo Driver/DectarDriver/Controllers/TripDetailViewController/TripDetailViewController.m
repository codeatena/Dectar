//
//  TripDetailViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/28/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "TripDetailViewController.h"

@interface TripDetailViewController ()<moveToNectVCFromFareSummary>{
    NSString * currencys;
    NSDictionary * summaryDict;
    NSDictionary * FareDict;
     FareSummaryViewController *controller;
}

@end

@implementation TripDetailViewController
@synthesize mapview,basicView,locationLbl,timerLbl,Camera,GoogleMap,custIndicatorView,tripId,lattitude,headerLbl,tripDeatilScrollView,longitude,rideDistLbl,timeTakenLbl,waitTimeLbl,completedView,rideHeaderLbl,timeHeaderLbl,waitHeaderLbl,totalBillHeader,paidBillHeader,totalAmountLbl,totslPaidLbl,cancelRideBtn,walletLbl,tipsLbl,
cancelView,rideId,statusLbl,paymentLbl,continueRideView,continueRideBtn,rideOption,isLocUpdated,needCash;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kDriverCashPaymentNotifWhenQuit
                                               object:nil];
 [self setFont];
   
    // Do any additional setup after loading the view.
}

- (void)receiveNotification:(NSNotification *) notification
{
    if(self.view.window){
        NSDictionary * dict=notification.userInfo;
        if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[dict objectForKey:@"action"]]] isEqualToString:@"receive_cash"]){
           
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
-(void)viewWillAppear:(BOOL)animated{
    cancelRideBtn.userInteractionEnabled=YES;
    continueRideBtn.userInteractionEnabled=YES;
    cancelView.hidden=YES;
   
    [self getTripDetail];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setFont{
    tripDeatilScrollView.hidden=YES;
    headerLbl=[Theme setHeaderFontForLabel:headerLbl];
    locationLbl=[Theme setNormalFontForLabel:locationLbl];
    timerLbl=[Theme setNormalFontForLabel:timerLbl];
    rideDistLbl=[Theme setNormalFontForLabel:rideDistLbl];
    timeTakenLbl=[Theme setNormalFontForLabel:timeTakenLbl];
    waitTimeLbl=[Theme setNormalFontForLabel:waitTimeLbl];
    rideHeaderLbl=[Theme setNormalSmallFontForLabel:rideHeaderLbl];
    timeHeaderLbl=[Theme setNormalSmallFontForLabel:timeHeaderLbl];
    waitHeaderLbl=[Theme setNormalSmallFontForLabel:waitHeaderLbl];
    totalBillHeader=[Theme setNormalFontForLabel:totalBillHeader];
    paidBillHeader=[Theme setNormalFontForLabel:paidBillHeader];
    totalAmountLbl=[Theme setNormalFontForLabel:totalAmountLbl];
    totslPaidLbl=[Theme setNormalFontForLabel:totslPaidLbl];
    cancelRideBtn=[Theme setBoldFontForButton:cancelRideBtn];
    [cancelRideBtn setBackgroundColor:SetThemeColor];
    cancelRideBtn.layer.cornerRadius=2;
    cancelRideBtn.layer.masksToBounds=YES;
    statusLbl.layer.cornerRadius=6;
    statusLbl.layer.masksToBounds=YES;
    paymentLbl.layer.cornerRadius=6;
    paymentLbl.layer.masksToBounds=YES;
    paymentLbl=[Theme setNormalFontForLabel:paymentLbl];
    statusLbl=[Theme setNormalFontForLabel:statusLbl];
    
    continueRideBtn=[Theme setBoldFontForButton:continueRideBtn];
    continueRideBtn.layer.cornerRadius=2;
    continueRideBtn.layer.masksToBounds=YES;
    
    [headerLbl setText:JJLocalizedString(@"Trip_Detail", nil)];
    [rideHeaderLbl setText:JJLocalizedString(@"ride_distance", nil)];
    [timeHeaderLbl setText:JJLocalizedString(@"time_taken", nil)];
    [waitHeaderLbl setText:JJLocalizedString(@"wait_time", nil)];
    [totalBillHeader setText:JJLocalizedString(@"Total_Bill", nil)];
    [paidBillHeader setText:JJLocalizedString(@"Total_Paid", nil)];

    [continueRideBtn setTitle:JJLocalizedString(@"Continue_Ride", nil) forState:UIControlStateNormal];
    [cancelRideBtn setTitle:JJLocalizedString(@"Cancel_Ride", nil) forState:UIControlStateNormal];
    
    
}
-(void)loadGoogleMap{
    if(TARGET_IPHONE_SIMULATOR)
    {
        Camera = [GMSCameraPosition cameraWithLatitude:13.0827
                                             longitude:80.2707
                                                  zoom:15];
    }else{
        Camera = [GMSCameraPosition cameraWithLatitude:lattitude
                                             longitude:longitude
                                                  zoom:15];
    }
    GoogleMap = [GMSMapView mapWithFrame:CGRectMake(0, 0, mapview.frame.size.width, mapview.frame.size.height) camera:Camera];
    GMSMarker * marker=[[GMSMarker alloc]init];
    marker.position = Camera.target;
    
    marker.icon = [UIImage imageNamed:@"LocMarker"];
    marker.snippet = [NSString stringWithFormat:@"%@",locationLbl.text];
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = GoogleMap;
   // GoogleMap.myLocationEnabled = YES;
    GoogleMap.userInteractionEnabled=YES;
    GoogleMap.delegate = self;
    [mapview addSubview:GoogleMap];
}
-(void)getTripDetail{
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getDriverTripDetail:[self setParametersDriverTripDetail]
                     success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             tripDeatilScrollView.hidden=NO;
             completedView.hidden=YES;
              needCash = [Theme checkNullValue:responseDictionary[@"response"][@"receive_cash"]];
             NSDictionary * reasonDetailDict = responseDictionary[@"response"][@"details"];
             NSDictionary * latLongDict=reasonDetailDict[@"pickup"][@"latlong"];
             NSDictionary * tipsDict=reasonDetailDict[@"tips"];
             summaryDict=reasonDetailDict[@"summary"];
              FareDict=reasonDetailDict[@"fare"];
             rideId=[Theme checkNullValue:reasonDetailDict[@"ride_id"]];
             headerLbl.text=[NSString stringWithFormat:@"ID : %@",rideId];
              currencys=[Theme findCurrencySymbolByCode:[Theme checkNullValue:reasonDetailDict[@"currency"]]];
             NSString * rideStatus=[Theme checkNullValue:reasonDetailDict[@"ride_status"]];
             NSString * ride=JJLocalizedString(@"Ride", nil);
             
             statusLbl.text=[NSString stringWithFormat:@"%@ %@",ride,rideStatus];
             timerLbl.text=[Theme checkNullValue:[reasonDetailDict objectForKey:@"pickup_date"]];
             locationLbl.text=[Theme checkNullValue:reasonDetailDict[@"pickup"][@"location"]];
             lattitude=[[NSString stringWithFormat:@"%@",latLongDict[@"lat"]] doubleValue];
             longitude=[[NSString stringWithFormat:@"%@",latLongDict[@"lon"]] doubleValue];
             NSString * str=[Theme checkNullValue:reasonDetailDict[@"distance_unit"]];
             [Theme saveDistanceString:str];
             if([str isEqualToString:@""]){
                 str=@"km";
             }
             if([rideStatus isEqualToString:@"Finished"]||[rideStatus isEqualToString:@"Completed"]){
                 completedView.hidden=NO;
                 paymentLbl.hidden=NO;
                 NSString * payment=JJLocalizedString(@"Payment", nil);
                 paymentLbl.text=[NSString stringWithFormat:@"%@ %@",payment,[Theme checkNullValue:reasonDetailDict[@"pay_status"]]];
                 if(summaryDict!=nil&&[summaryDict count]>0){
                    
                     
                     rideDistLbl.text=[NSString stringWithFormat:@"%@ %@",[Theme checkNullValue:summaryDict[@"ride_distance"]],str];
                    
                     timeTakenLbl.text=[NSString stringWithFormat:@"%@ mins",[Theme checkNullValue:summaryDict[@"ride_duration"]]];
                     waitTimeLbl.text=[NSString stringWithFormat:@"%@ mins",[Theme checkNullValue:summaryDict[@"waiting_duration"]]];
                 }
                 if(FareDict!=nil&&[FareDict count]>0){
                     totalAmountLbl.text=[NSString stringWithFormat:@"%@ %@",currencys,[Theme checkNullValue:FareDict[@"grand_bill"]]];
                     totslPaidLbl.text=[NSString stringWithFormat:@"%@ %@",currencys,[Theme checkNullValue:FareDict[@"total_paid"]]];
                 }
                 tipsLbl.text=@"";
                 NSString * tipsStatusStr=[Theme checkNullValue:tipsDict[@"tips_status"]];
                 if([tipsStatusStr isEqualToString:@"1"]){
                     tipsLbl.text=[NSString stringWithFormat:@"Tips : %@ %@",currencys,[Theme checkNullValue:tipsDict[@"tips_amount"]]];
                 }
                 if([rideStatus isEqualToString:@"Finished"]){
                     self.paymentView.hidden=NO;
                     
                 }else{
                      self.paymentView.hidden=YES;
                 }
             }
             if([[Theme checkNullValue:FareDict[@"wallet_usage"]] integerValue]>0){
                 walletLbl.hidden=NO;
                 NSString* byWallet=JJLocalizedString(@"Paid_by_Wallet_money", nil);
                 
                 walletLbl.text=[NSString stringWithFormat:@"%@ %@%@",byWallet,currencys,[Theme checkNullValue:FareDict[@"wallet_usage"]]];
             }
             if([[Theme checkNullValue:FareDict[@"coupon_discount"]] integerValue]>0){
                 walletLbl.hidden=NO;
                 NSString* bycoupon=JJLocalizedString(@"Paid_by_Coupon_offer", nil);

                 walletLbl.text=[NSString stringWithFormat:@"%@ %@%@",bycoupon,currencys,[Theme checkNullValue:FareDict[@"coupon_discount"]]];
             }
             if([[Theme checkNullValue:reasonDetailDict[@"do_cancel_action"]]isEqualToString:@"1"]){
                 cancelView.hidden=NO;
                 tripDeatilScrollView.contentSize=CGSizeMake(tripDeatilScrollView.frame.size.width, completedView.frame.origin.y+completedView.frame.size.height+130);
             }else{
                 tripDeatilScrollView.contentSize=CGSizeMake(tripDeatilScrollView.frame.size.width, completedView.frame.origin.y+completedView.frame.size.height+80);
             }
             rideOption=[Theme checkNullValue:reasonDetailDict[@"continue_ride"]];
             if([rideOption isEqualToString:@"arrived"]||[rideOption isEqualToString:@"begin"]){
                 continueRideView.hidden=NO;
                 
             }else if ([rideOption isEqualToString:@"end"]){
                 continueRideView.hidden=NO;
                 continueRideView.frame=cancelView.frame;
             }
             else{
                 continueRideView.hidden=YES;
             }
             [self loadGoogleMap];
             
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
-(NSDictionary *)setParametersDriverTripDetail{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"ride_id":tripId
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

- (IBAction)didClickCancelRideBtn:(id)sender {
   
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    CancelRideViewController * objCancelVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CancelVCSID"];
    [objCancelVC setRideId:rideId];
    [self.navigationController pushViewController:objCancelVC animated:YES];
}

- (IBAction)didClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)didClickReceiveCashBtn:(id)sender {
    
}

- (IBAction)didClickreceivePaymentBtn:(id)sender {
    
    FareRecords * objFareRecrds=[[FareRecords alloc]init];
    objFareRecrds.currency=[Theme checkNullValue:currencys];
    NSString * str=[Theme checkNullValue:[Theme getCurrentDistanceString]];
    if([str isEqualToString:@""]){
        str=@"km";
    }
    NSString * str1=[NSString stringWithFormat:@"%@ %@",[Theme checkNullValue:[summaryDict objectForKey:@"ride_distance"]],str];
    objFareRecrds.rideDistance=str1;
    objFareRecrds.rideDuration=[Theme checkNullValue:[summaryDict objectForKey:@"ride_duration"]];
    objFareRecrds.rideFare=[Theme checkNullValue:[NSString stringWithFormat:@"%.02f",[[FareDict objectForKey:@"grand_bill"] floatValue]]];
    objFareRecrds.waitingDuration=[Theme checkNullValue:[summaryDict objectForKey:@"waiting_duration"]];
    objFareRecrds.needPayment=[Theme checkNullValue:@"YES"];
    objFareRecrds.needCash=needCash;
   
    controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FareSummaryVCSID"];
    //controller.view.frame=self.view.frame;
    controller.objFareRecs=[[FareRecords alloc]init];
    [controller setObjFareRecs:objFareRecrds];
    controller.delegate=self;
    [controller setIsCloseEnabled:YES];
    [controller presentInParentViewController:self];
    
}

- (IBAction)didClickContinueRideBtn:(id)sender {
   
        continueRideBtn.userInteractionEnabled=NO;
        if([rideOption isEqualToString:@"arrived"]){
            [self loadContinueRide];
            [self performSelector:@selector(enableContinueBtn) withObject:nil afterDelay:10];
        }else if ([rideOption isEqualToString:@"begin"]){
             [self loadContinueRide];
            [self performSelector:@selector(enableContinueBtn) withObject:nil afterDelay:10];
        }
        else if ([rideOption isEqualToString:@"end"]){
            EndTripViewController * objEndTripVc=[self.storyboard instantiateViewControllerWithIdentifier:@"EndTripVCSID"];
            [objEndTripVc setRideID:rideId];
            [self.navigationController pushViewController:objEndTripVc animated:YES];
        }
    
}

-(void)enableContinueBtn{
    continueRideBtn.userInteractionEnabled=YES;
}
-(void)loadContinueRide{
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web continueRide:[self setParametersForAcceptRide]
              success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             
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
             
             
             if([rideOption isEqualToString:@"arrived"]){
                 RideUserViewController * objRideUserVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RideUserVCSID"];
                 [objRideUserVc setObjRiderRecords:objRiderRecords];
                 [self.navigationController pushViewController:objRideUserVc animated:YES];
             }else if ([rideOption isEqualToString:@"begin"]){
                 TripViewController * objTripVc=[self.storyboard instantiateViewControllerWithIdentifier:@"TripVCSID"];
                 [objTripVc setObjRiderRecs:objRiderRecords];
                 [self.navigationController pushViewController:objTripVc animated:YES];
             }
            
         }else{
             
             [self.view makeToast:kErrorMessage];
             
         }
         
     }
              failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [self.navigationController popViewControllerAnimated:NO];
         
     }];
}
-(NSDictionary *)setParametersForAcceptRide{
    NSString * latitude1=@"";
    NSString * longitude1=@"";
    if(location.coordinate.latitude!=0){
        latitude1=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
        longitude1=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
    }
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"ride_id":rideId,
                                  };
    return dictForuser;
}
-(void)moveToNextVc:(NSInteger )index{
    if(index==1){
        CashOTPViewController * objCashOtpController=[self.storyboard instantiateViewControllerWithIdentifier:@"CashOTPVCSID"];
        [objCashOtpController setRideId:rideId];
        [self.navigationController pushViewController:objCashOtpController animated:YES];
    }else if (index==0){
        [controller.view makeToast:@"Please_wait_until_transaction"];
        [self sendrequestForPayment];
    }else if (index==2){
        [self sendrequestForNoPayment];
    }
    else if (index==3){
        [self stopActivityIndicator];
    }
}
-(void)sendrequestForPayment{
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web requestForPayment:[self setParametersForPaymentRequest]
                   success:^(NSMutableDictionary *responseDictionary)
     {
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             //[controller.view makeToast:@"Please wait until transaction is complete. Don't minimize or go back"];
             PaymentWaitingViewController * objPayWait=[self.storyboard instantiateViewControllerWithIdentifier:@"PaymentWaitingVCSID"];
             [objPayWait setRideIdPay:rideId];
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
-(NSDictionary *)setParametersForPaymentRequest{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"ride_id":rideId
                                  };
    return dictForuser;
}
-(void)sendrequestForNoPayment{
    RatingsViewController * objRatingsVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingsVCSID"];
    [objRatingsVc setRideid:rideId];
    [self.navigationController pushViewController:objRatingsVc animated:YES];
    
    //    [self showActivityIndicator:YES];
    //    UrlHandler *web = [UrlHandler UrlsharedHandler];
    //    [web NoNeedPayment:[self setParametersForPaymentRequest]
    //               success:^(NSMutableDictionary *responseDictionary)
    //     {
    //         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
    //             RatingsViewController * objRatingsVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingsVCSID"];
    //             [objRatingsVc setRideid:rideID];
    //             [self.navigationController pushViewController:objRatingsVc animated:YES];
    //         }else{
    //             [self stopActivityIndicator];
    //             [controller.view makeToast:kErrorMessage];
    //         }
    //     }
    //               failure:^(NSError *error)
    //     {
    //         [self stopActivityIndicator];
    //         [controller.view makeToast:kErrorMessage];
    //         
    //     }];
}


@end
