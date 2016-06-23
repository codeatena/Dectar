//
//  UrlHandler.m
//  VoiceEM
//
//  Created by Casperon Technologies on 5/18/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "UrlHandler.h"
#import "AppDelegate.h"
#import "AFURLRequestSerialization.h"
#import "Theme.h"

@implementation UrlHandler{
    AppDelegate *appdelegate;
}
@synthesize manager;

+ (id) UrlsharedHandler
{
    static UrlHandler *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
-(void)serverErrorMessage{

     //[self showAlert:JJLocalizedString(@"Server error! Please try again later", nil)];
}

-(void)noNetworkMessage{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:NoNetworkCon
     object:self];
}

#pragma mark - AFHTTPRequestOperationManager getter
-(AFHTTPRequestOperationManager *)manager
{
    NSString * str=[Theme checkNullValue:[Theme getCurrentLanguage]];
    if(str.length==0){
        str=@"en";
    }
    if (!manager)
    {
        manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
     [manager.requestSerializer setValue:str forHTTPHeaderField:@"applanguage"];
    return manager;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)callPostMethodWithParameters:(NSDictionary *)parameters withMethod:(NSString *)mathodName success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
 if(appdelegate==nil){
        appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    }
     if (appdelegate.isInternetAvailableFor) {
         if([AppDelegate checkApplicationHasLocationServicesPermission]&&[AppDelegate checkLocationServicesTurnedOn]){
       
         [self.manager POST:mathodName parameters:parameters
          
                    success:^(AFHTTPRequestOperation *operation, id responseObject)
          {
              
              NSError *parsingError;
              NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&parsingError];
              NSString * deadStr=[Theme checkNullValue:[responseDict objectForKey:@"is_dead"]];
              if(deadStr.length>0){
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Theme project_getAppName]
                                                                  message:@"Your Session has been Logged out...\nKindly Login again"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil, nil];
                  alert.tag=13;
                  
                  [alert show];
                  
              }else{
                  success(responseDict);
              }
              
              
          }
          
                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
          {
              NSLog(@"Error = %@",error);
            
              [self serverErrorMessage];
              failure(error);
          }];
         }else{
               failure(nil);
             [[NSNotificationCenter defaultCenter]
              postNotificationName:kDriverReturnNotif
              object:self];
         }
     }else{
         [self performSelector:@selector(noNetworkMessage) withObject:self afterDelay:0];
     }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==13){
        if (buttonIndex == [alertView cancelButtonIndex]){
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kDriverSessionOut
             object:self];
        }else{
            //reset clicked
        }
    }
    
}
-(void)callGetMethodWithParameters:(NSDictionary *)parameters withMethod:(NSString *)mathodName success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
if(appdelegate==nil){
        appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    }
    if (appdelegate.isInternetAvailableFor) {
        [self.manager GET:mathodName parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
           
            NSError *parsingError;
            NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&parsingError];
            success(responseDict);
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"Error = %@",error);
            
           [self serverErrorMessage];
            failure(error);
        }];
    }
    else{
        
          [self performSelector:@selector(noNetworkMessage) withObject:self afterDelay:0];
    }
    
}

-(void)callPostMethodWithoutIndicatorWithParameters:(NSDictionary *)parameters withMethod:(NSString *)mathodName success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
 if(appdelegate==nil){
        appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    }
     if (appdelegate.isInternetAvailableFor) {
        [self.manager POST:mathodName parameters:parameters
         
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             NSError *parsingError;
             NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&parsingError];
             success(responseDict);
             
         }
         
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error = %@",error);
             [self serverErrorMessage];
             failure(error);
         }];
    }else{
        [self performSelector:@selector(noNetworkMessage) withObject:self afterDelay:0];
    }
}
-(void)callGetMethodWithoutIndicatorWithParameters:(NSDictionary *)parameters withMethod:(NSString *)mathodName success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
 if(appdelegate==nil){
        appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    }
   if (appdelegate.isInternetAvailableFor) {
        [self.manager GET:mathodName parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            NSError *parsingError;
            NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&parsingError];
            success(responseDict);
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"Error = %@",error);
            [self serverErrorMessage];
            failure(error);
        }];
    }
    else{
        
        [self performSelector:@selector(noNetworkMessage) withObject:self afterDelay:0];
    }
    
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma Normal Registration
-(void)RegisterUserWithParameters:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
   
//    NSString * methodStr=[NSString stringWithFormat:@"%@%@",BaseURL,RegisterNormalUrl];
//        [self callMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Get Home page data
-(void)PostLoginUrl:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",LoginUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
#pragma mark Update User Location
-(void)UpdateUserLocation:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",UpdateCurrentLocationUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark Go Offline OnLine
-(void)UserGoOfflineOnLineUrl:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",GoOnlineUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark Reject request
-(void)DriverReject:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",DriverRejectRequest];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
#pragma mark AcceptRequest
-(void)DriverAccept:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",DriverAcceptRequest];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark Driver Arrived
-(void)DriverArrLocation:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",DriverArrivedLocation];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark Driver Started
-(void)DriverStartedRide:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",DriverStartedTrip];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark Driver Ended
-(void)DriverEndRide:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",DriverEndTrip];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark Driver cancel reason
-(void)DriverCancelWithReason:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",DriverCacelTripWithReason];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
#pragma mark Get user Info
-(void)getUserInformation:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",getUserInfo];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
#pragma mark Driver Trip info
-(void)getDriverTripList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",getDriverTripsList];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
#pragma mark  Trip info
-(void)getDriverTripDetail:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",getDriverTripsDetail];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
#pragma mark  cash OTP
-(void)getOTP:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",requestForCashOTP];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
#pragma mark  Receive Cash
-(void)receiveCash:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",cashReceivedUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
#pragma mark  payment Request
-(void)requestForPayment:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",requestPayment];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
#pragma mark  rate user
-(void)RateUser:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",rateTheUser];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark  rate Submitting
-(void)SubmitRateUser:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",submitRate];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
#pragma mark  Logout
-(void)LogoutDriver:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",LogoutUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark  save bank
-(void)saveBankingData:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",saveBankingUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark  get bank
-(void)getBankingData:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",getBankingUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
#pragma mark  get payment
-(void)getPaymentList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",paymentListUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
#pragma mark  get pay detail
-(void)getPaymentDetail:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",kPaymentDetailUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
#pragma mark  get pay detail
-(void)continueRide:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",ContinueRideUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark no need Payment
-(void)NoNeedPayment:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",NoNeedPaymentUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark Google Location Search
-(void)SearchGoogleLocation:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",GoogleLocation];
    //[self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
    [self callGetMethodWithoutIndicatorWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
#pragma mark Forgot Password Payment
-(void)ForgotPassword:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",ForgotPasswordUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark Change Password Payment
-(void)ChangePassword:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",ChangePasswordUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark Starter Data
-(void)StarterData:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",StarterDataUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark ConnectXmpp
-(void)XmppModeUpdate:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",XmppUpdateUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}


#pragma mark getGoogleRoute
-(void)getGoogleRoute:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",getRouteFromGoogle];
    [self callGetMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark getGoogleLatLong To Address
-(void)getGoogleLatLongToAddress:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",getLatLongToAddressGoogle];
    [self callGetMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark check Payment Status
-(void)CheckPaymentStatus:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",CheckPaymentStatusUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark Get Locations
-(void)getDriverLocations:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",getDriverLocationsUrl];
    [self callPostMethodWithParameters:nil withMethod:methodStr success:success failure:failure];
}

#pragma mark Get Category
-(void)getDriverCategory:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",getDriverCategoryUrl];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark Country List
-(void)getCountryList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",getCountryListURL];
    [self callPostMethodWithParameters:nil withMethod:methodStr success:success failure:failure];
}

#pragma mark Vehicle List
-(void)getVehicleList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",getVehicleListURL];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark maker List
-(void)getVehicleMakerList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",getVehicleMakerListURL];
    [self callPostMethodWithParameters:nil withMethod:methodStr success:success failure:failure];
}

#pragma mark Vehicle Model List
-(void)getVehicleModelList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",getVehicleModelListURL];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark Vehicle Year List
-(void)getVehicleYearList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",getVehicleYearListURL];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark Reg Otp
-(void)getRegOtp:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",sendOTPRegURL];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}


#pragma mark Reg Otp
-(void)sendDriverImage:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",sendDriverImageURL];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

#pragma mark Regby app
-(void)RegistrationDriverByApp:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",regDriverByApp];
    [self callPostMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
@end
