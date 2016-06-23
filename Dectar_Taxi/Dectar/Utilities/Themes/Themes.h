//
//  Themes.h
//  Dectar
//
//  Created by Suresh J on 08/07/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DGActivityIndicatorView.h"
#import "Reachability.h"
#import "SMBInternetConnectionIndicator.h"
#import "LanguageHandler.h"


@interface Themes : NSObject

+(void)StopView:(UIView*)view;
+(void)StartView:(UIView*)view;
+(id)writableValue:(id)value;
+(void)banner:(UIView*)view;

+(void)saveUserID:(NSString*)userName;
+(NSString*)getUserID;

+(void)saveUserName:(NSString*)userName;
+(NSString*)getUserName;

+(void)SaveuserDP:(NSString*)Displaypicture;
+(NSString*)getUserDp;

+(void)SaveCategoryString:(NSString*)CategoryString;
+(NSString*)getCategoryString;

+(void)SaveuserEmail:(NSString*)userMail;
+(NSString*)getuserMail;

+(void)SaveCoupon:(NSString*)Pickup;
+(NSString*)GetCoupon;

+(void)SaveDeviceToken:(NSString*)Pickup;
+(NSString*)GetDeviceToken;


+(void)SaveMobileNumber:(NSString*)mobileNumber;
+(NSString*)getmobileNumber;

+(void)SaveFullWallet:(NSString*)FullWallet;
+(NSString*)GetFullWallet;

+(void)SaveCouponDetails:(NSString*)CouponDetails;
+(NSString*)GetCouponDetails;

+(void)SaveWallet:(NSString*)Amount;
+(NSString*)GetWallet;

+(void)SaveCurrency:(NSString*)Currency;
+(NSString*)GetCurrency;

+(void)SaveCountryCode:(NSString*)CountryCode;
+(NSString*)GetCountryCode;

+ (NSString *)findCurrencySymbolByCode:(NSString *)_currencyCode;

+(void)statusbarColor:(UIView*)view;

+(void)saveXmppUserCredentials:(NSString *)str;
+(NSString*)getXmppUserCredentials;
+(id)checkNullValue:(id)value;
+(NSDictionary *)getCountryList;
+(NSString *)getAppName;

+(void)ClearUserInfo;



+(void)saveLanguage:(NSString *)str;
+(NSString*)ChangeToLanguage;
+(void)SetLanguageToApp;
+(NSString*)getCurrentLanguage;
@end
