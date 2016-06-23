//
//  UrlHandler.h
//  VoiceEM
//
//  Created by Casperon Technologies on 5/18/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AppDelegate.h"



typedef void(^RequestCompletionHandlerBlock) (NSMutableDictionary *responseDictionary);
typedef void(^RequestFailedHandlerBlock)(NSError *error);
@interface UrlHandler : NSObject
{
     AppDelegate *appDel;
}
@property(nonatomic, strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic, assign) BOOL ShowAlert;
@property(nonatomic, strong)UIAlertView * ErrorAlert ;
@property(nonatomic, assign) BOOL ShowDeadAlert;


+ (id) UrlsharedHandler;
-(void)GetMapView:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)GetGoeUpate:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)RgstrAccount:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)SignIn:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)GetEta:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)ApplyCoupon:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)GetFavrList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)SaveFavourite:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)DeleteList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)EditListFavour:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)ConfirmRide:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)Bookingcancel:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)OTPcheck:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)Myride:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)GetMyRide:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)nameChange:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)numberChange:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)passwrdChange:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)referCode:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)saveEmergency:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)ShowEmergency:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)RemoveEmergency:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)GetMoney:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)GETTranscationList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)CancelReason:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)CancelRide:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)PaymentType:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)WalletPayment:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)CashPayment:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)Getwaypayment:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)ListReview:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)loggout:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)SubmirReview:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)GetLocationList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)GetCategoryList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)GetRatecardDetails:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)AddAmount:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)AlertEmergency:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)MailInvoice:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)AutoDetect:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)Reset_passowrd:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)Update_passowrd:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;

-(void)Check_Social:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)login_Social:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)Track_Driver:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;

-(void)Add_Tips:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)Remove_Tips:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;

-(void)FareBreakUp:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)CheckXMPP:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;

-(void)ETAshare:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getGoogleLatLongToAddress:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getGoogleRoute:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;


@end
