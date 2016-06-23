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
#import "Constant.h"
#import "AppDelegate.h"


typedef void(^RequestCompletionHandlerBlock) (NSMutableDictionary *responseDictionary);
typedef void(^RequestFailedHandlerBlock)(NSError *error);
@interface UrlHandler : NSObject<UIAlertViewDelegate>
@property(nonatomic, strong)AFHTTPRequestOperationManager *manager;


+ (id) UrlsharedHandler;
-(void)PostLoginUrl:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)UpdateUserLocation:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)UserGoOfflineOnLineUrl:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)DriverReject:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)DriverAccept:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)DriverArrLocation:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)DriverStartedRide:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)DriverEndRide:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)DriverCancelWithReason:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getUserInformation:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getDriverTripList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getDriverTripDetail:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getOTP:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)receiveCash:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)requestForPayment:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)RateUser:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)SubmitRateUser:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)LogoutDriver:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)saveBankingData:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getBankingData:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getPaymentList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getPaymentDetail:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)continueRide:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)NoNeedPayment:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)SearchGoogleLocation:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)ForgotPassword:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)ChangePassword:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)StarterData:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)XmppModeUpdate:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getGoogleRoute:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getGoogleLatLongToAddress:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)CheckPaymentStatus:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getDriverLocations:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getDriverCategory:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getCountryList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getVehicleList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getVehicleMakerList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getVehicleModelList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getVehicleYearList:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)getRegOtp:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)sendDriverImage:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
-(void)RegistrationDriverByApp:(NSDictionary *)parameters success:(RequestCompletionHandlerBlock)success failure:(RequestFailedHandlerBlock)failure;
@end
