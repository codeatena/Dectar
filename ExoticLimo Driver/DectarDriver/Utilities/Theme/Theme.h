//
//  Theme.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/21/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "DriverInfoRecords.h"





@interface Theme : NSObject
#pragma mark Set Font
+(UILabel *)setNormalFontForLabel:(UILabel *)label;
+(UILabel *)setBoldFontForLabel:(UILabel *)label;
+(UIButton *)setNormalFontForButton:(UIButton *)btn;
+(UIButton *)setBoldFontForButton:(UIButton *)btn;
+(UILabel *)setHeaderFontForLabel:(UILabel *)label;
+(UITextField *)setNormalFontForTextfield:(UITextField *)textField;
+(UIButton *)setLargeFontForButton:(UIButton *)btn;
+(UILabel *)setLargeBoldFontForLabel:(UILabel *)label;
+(UILabel *)setNormalSmallFontForLabel:(UILabel *)label;
+(UIButton *)setBoldSmallFontForButton:(UIButton *)btn;
+(UITextField *)setLargeBoldFontForTextField:(UITextField *)textField;
+(UIButton *)setSmallBoldFontForButtonBold:(UIButton *)btn;
+(UITextView *)setNormalFontForTextView:(UITextView *)UITextView;
+(UILabel *)setSmallBoldFontForLabel:(UILabel *)label;
+(UIButton *)setBoldFontForButtonBold:(UIButton *)btn;
+(NSString *)checkNullValue:(NSString *)str;
+(void)savePushNotificationID:(NSString *)token;
+(NSString *)getDeviceToken;
+(void)saveUserDetails:(DriverInfoRecords*)userInfoRec;
+(void)ClearUserDetails;
+(NSDictionary *)retrieveUserData;
+(BOOL)UserIsLogin;
+(NSDictionary *)DriverAllInfoDatas;
+(void)SaveUSerISOnline:(NSString*)driverStatus;
+(BOOL )retrieveDriverOnline;
+ (NSString *)findCurrencySymbolByCode:(NSString *)_currencyCode;
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
+(NSDate*)setDate:(NSString*)dateStr;
+(BOOL) NSStringIsValidEmail:(NSString *)checkString;
+ (BOOL)isEndDateIsSmallerThanCurrent:(NSDate *)checkEndDate;
+(void)SetLanguageToApp;
+(void)saveLanguage:(NSString *)str;
+(NSString*)getCurrentLanguage;
+(void)saveXmppUserCredentials:(NSString *)str;
+(NSString*)getXmppUserCredentials;
+(NSString*)project_getAppName;
+(void)saveDistanceString:(NSString *)str;
+(NSString*)getCurrentDistanceString;
@end
