//
//  UrlHandler.m
//  VoiceEM
//
//  Created by Casperon Technologies on 5/18/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "UrlHandler.h"
#import "Themes.h"
#import "AppDelegate.h"
#import "Constant.h"

@implementation UrlHandler
@synthesize manager,ShowAlert,ErrorAlert;

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

    NSLog(@"Server Error or Request timeout error");
    
   }


-(void)noNetworkMessage{
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"NoNetworkMsgPush"
     object:self];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==13){
        [manager.operationQueue cancelAllOperations];
        
        _ShowDeadAlert=NO;
        if (buttonIndex == [alertView cancelButtonIndex]){
            
            [Themes ClearUserInfo];
            AppDelegate*appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [appdelegate Logoutroot];
            [appdelegate disconnect];
            [manager.operationQueue cancelAllOperations];
            
            
        }else{
            //reset clicked
        }
    }
    
    else if (alertView==ErrorAlert)
    {
        ErrorAlert = nil;
        ShowAlert=NO;
    }
}
#pragma mark - AFHTTPRequestOperationManager getter
-(AFHTTPRequestOperationManager *)manager
{
    NSString *str = [Themes getCurrentLanguage];
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
    /*NSString *userAgent = [manager.requestSerializer  valueForHTTPHeaderField:@"cabily2k15"];
    //userAgent = [userAgent stringByAppendingPathComponent:@"CUSTOM_PART"];
    [self.manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"cabily2k15"];*/
    

    
    return manager;
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)callPostMethodWithParameters:(NSDictionary *)parameters withMethod:(NSString *)mathodName success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
    if (!appDel) {
        
        appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
     if (appDel.isNetworkAvailable) {
        
         [self.manager POST:mathodName parameters:parameters
          
                    success:^(AFHTTPRequestOperation *operation, id responseObject)
          {
              
              NSError *parsingError;
              NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&parsingError];
              NSString * deadStr=[Themes writableValue:[responseDict objectForKey:@"is_dead"]];
              if(deadStr.length>0){
                  if(_ShowDeadAlert == NO)
                  {
                      
                      _ShowDeadAlert = YES;
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Themes getAppName]
                                                                      message:@"Your Session has been Logged out...\nKindly Login again"
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil, nil];
                      alert.tag=13;
                      
                      [alert show];
                      
                      [manager.operationQueue cancelAllOperations];
                  }
                  
                  
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
     }
     else
     {
         [self performSelector:@selector(noNetworkMessage) withObject:self afterDelay:0];
     }
}

-(void)callGetMethodWithParameters:(NSDictionary *)parameters withMethod:(NSString *)mathodName success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
    if (!appDel) {
        
        appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    if (appDel.isNetworkAvailable) {
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
    if (!appDel) {
        
        appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    if (appDel.isNetworkAvailable) {
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
    }
    else{
        [self performSelector:@selector(noNetworkMessage) withObject:self afterDelay:0];
    }
}
-(void)callGetMethodWithoutIndicatorWithParameters:(NSDictionary *)parameters withMethod:(NSString *)mathodName success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    if (!appDel) {
        
        appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    if (appDel.isNetworkAvailable) {
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
#pragma mark POST METHOD
-(void)GetGoeUpate:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:GeoUpdate success:success failure:failure];
}

-(void)GetMapView:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:Map_and_Taxi_Selection success:success failure:failure];
}

-(void)RgstrAccount:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:RegisterAccount success:success failure:failure];

}
-(void)SignIn:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:Login success:success failure:failure];

}
-(void)GetEta:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:mapEta success:success failure:failure];
    
}
-(void)ApplyCoupon:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:applycoupon success:success failure:failure];
}

-(void)GetFavrList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:favouriteList success:success failure:failure];
    
}
-(void)SaveFavourite:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:addfavourite success:success failure:failure];
    
}
-(void)DeleteList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:deleteList success:success failure:failure];
    
}
-(void)EditListFavour:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:EditFavr success:success failure:failure];
    
}
-(void)ConfirmRide:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:ConfrimBooking success:success failure:failure];
    
}
-(void)Bookingcancel:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:deleteRide success:success failure:failure];
    
}
-(void)OTPcheck:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:OTP success:success failure:failure];
    
}
-(void)Myride:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:MyrideList success:success failure:failure];
    
}
-(void)GetMyRide:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:ViewRides success:success failure:failure];
    
}
-(void)nameChange:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:changename success:success failure:failure];
    
}
-(void)passwrdChange:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:changepassword success:success failure:failure];
    
}
-(void)numberChange:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:changemobilenumber success:success failure:failure];
    
}
-(void)referCode:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:invite success:success failure:failure];
    
}
-(void)saveEmergency:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:AddEmergency success:success failure:failure];
    
}
-(void)RemoveEmergency:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:DeleteEmergency success:success failure:failure];
    
}
-(void)ShowEmergency:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:viewEmergency success:success failure:failure];
    
}
-(void)AlertEmergency:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:SoundEmergency success:success failure:failure];
    
}

-(void)GetMoney:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:Mymoney success:success failure:failure];
    
}
-(void)GETTranscationList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:transcationList success:success failure:failure];
    
}
-(void)CancelReason:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:ReasonCancel success:success failure:failure];
    
}
-(void)CancelRide:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:RideCancel success:success failure:failure];
    
}

-(void)PaymentType:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:ListofPayment success:success failure:failure];
    
}
-(void)WalletPayment:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:PaymentByWallet success:success failure:failure];
    
}
-(void)CashPayment:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:PaymentByCash success:success failure:failure];
    
}
-(void)Getwaypayment:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:paymentGetWay success:success failure:failure];
    
}
-(void)ListReview:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:ReviewList success:success failure:failure];
    
}
-(void)loggout:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:Loggout success:success failure:failure];
    
}
-(void)SubmirReview:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:ReviewSubmit success:success failure:failure];
    
}
-(void)GetLocationList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
    [self callPostMethodWithParameters:parameters withMethod:LocationsList success:success failure:failure];
}

-(void)GetCategoryList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
    [self callPostMethodWithParameters:parameters withMethod:CategoryList success:success failure:failure];
}

-(void)GetRatecardDetails:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
    [self callPostMethodWithParameters:parameters withMethod:RateCardDetails success:success failure:failure];
}
-(void)AddAmount:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
    [self callPostMethodWithParameters:parameters withMethod:AddWallet success:success failure:failure];
}
-(void)MailInvoice:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
    [self callPostMethodWithParameters:parameters withMethod:Invoice success:success failure:failure];
}

-(void)AutoDetect:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
    [self callPostMethodWithParameters:parameters withMethod:detectiontionAuto success:success failure:failure];
}

-(void)Reset_passowrd:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
    [self callPostMethodWithParameters:parameters withMethod:Password_Reset success:success failure:failure];
}
-(void)Update_passowrd:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
    [self callPostMethodWithParameters:parameters withMethod:Password_Update success:success failure:failure];
}

-(void)Check_Social:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
    [self callPostMethodWithParameters:parameters withMethod:Social_Check success:success failure:failure];
}

-(void)login_Social:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
    [self callPostMethodWithParameters:parameters withMethod:Social_login success:success failure:failure];
}

-(void)Track_Driver:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
    [self callPostMethodWithParameters:parameters withMethod:Driver_Track success:success failure:failure];
}

-(void)Add_Tips:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
    [self callPostMethodWithParameters:parameters withMethod:Tips_Adding success:success failure:failure];
}

-(void)Remove_Tips:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure
{
    [self callPostMethodWithParameters:parameters withMethod:Tips_Remove success:success failure:failure];
}
-(void)FareBreakUp:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:GetFare success:success failure:failure];
    
}
-(void)CheckXMPP:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:ForXMPP success:success failure:failure];
    
}
-(void)ETAshare:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    [self callPostMethodWithParameters:parameters withMethod:ShareETA success:success failure:failure];
    
}
#pragma mark getGoogleLatLong To Address
-(void)getGoogleLatLongToAddress:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",getLatLongToAddressGoogle];
    [self callGetMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}
#pragma mark getGoogleRoute
-(void)getGoogleRoute:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure{
    NSString * methodStr=[NSString stringWithFormat:@"%@",getRouteFromGoogle];
    [self callGetMethodWithParameters:parameters withMethod:methodStr success:success failure:failure];
}

@end
