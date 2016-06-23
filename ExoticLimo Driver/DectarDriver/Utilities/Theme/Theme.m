//
//  Theme.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/21/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "Theme.h"

@implementation Theme

#pragma mark Set Font Methods
#pragma --
//////////////////////////////////////////////////////////////////////////////////
+(UILabel *)setNormalFontForLabel:(UILabel *)label{
    [label setFont: [UIFont fontWithName:@"RobotoCondensed-Regular" size:17]];
    return label;
}
+(UILabel *)setNormalSmallFontForLabel:(UILabel *)label{
    [label setFont: [UIFont fontWithName:@"RobotoCondensed-Regular" size:14]];
    return label;
}
+(UILabel *)setBoldFontForLabel:(UILabel *)label{
    [label setFont: [UIFont fontWithName:@"RobotoCondensed-Bold" size:21]];
    return label;
}
+(UILabel *)setSmallBoldFontForLabel:(UILabel *)label{
    [label setFont: [UIFont fontWithName:@"RobotoCondensed-Bold" size:15]];
    return label;
}
+(UILabel *)setLargeBoldFontForLabel:(UILabel *)label{
    [label setFont: [UIFont fontWithName:@"RobotoCondensed-Bold" size:31]];
    return label;
}
+(UITextField *)setLargeBoldFontForTextField:(UITextField *)textField{
    [textField setFont: [UIFont fontWithName:@"RobotoCondensed-Bold" size:31]];
    return textField;
}
+(UIButton *)setNormalFontForButton:(UIButton *)btn{
    [btn.titleLabel setFont: [UIFont fontWithName:@"RobotoCondensed-Regular" size:14]];
    return btn;
}
+(UIButton *)setLargeFontForButton:(UIButton *)btn{
    [btn.titleLabel setFont: [UIFont fontWithName:@"RobotoCondensed-Regular" size:22]];
    return btn;
}
+(UIButton *)setBoldFontForButton:(UIButton *)btn{
    [btn.titleLabel setFont: [UIFont fontWithName:@"RobotoCondensed-Bold" size:16]];
    return btn;
}
+(UIButton *)setBoldFontForButtonBold:(UIButton *)btn{
    [btn.titleLabel setFont: [UIFont fontWithName:@"RobotoCondensed-Bold" size:18]];
    return btn;
}
+(UIButton *)setSmallBoldFontForButtonBold:(UIButton *)btn{
    [btn.titleLabel setFont: [UIFont fontWithName:@"RobotoCondensed-Bold" size:13]];
    return btn;
}
+(UIButton *)setBoldSmallFontForButton:(UIButton *)btn{
    [btn.titleLabel setFont: [UIFont fontWithName:@"RobotoCondensed-Bold" size:13]];
    return btn;
}
+(UILabel *)setHeaderFontForLabel:(UILabel *)label{
    [label setFont: [UIFont fontWithName:@"RobotoCondensed-Regular" size:18]];
    return label;
}
+(UITextField *)setNormalFontForTextfield:(UITextField *)textField{
    [textField setFont: [UIFont fontWithName:@"RobotoCondensed-Regular" size:14]];
    return textField;
}

+(UITextView *)setNormalFontForTextView:(UITextView *)UITextView{
    [UITextView setFont: [UIFont fontWithName:@"RobotoCondensed-Regular" size:14]];
    return UITextView;
}
//////////////////////////////////////////////////////////////////////////////////
+(NSString *)checkNullValue:(NSString *)str{
    if (str == nil || [str isKindOfClass:[NSNull class]]) {
        str=@"";
    }
    NSString * returnString=[NSString stringWithFormat:@"%@",str];
    return returnString;
}
+(void)savePushNotificationID:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kdeviceTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)getDeviceToken{
    //@"21a6d650d0063c66fca06e0dc5426d23a3a823be5ac8af13f004e9e415085a7f";
    NSString *savedValue =[[NSUserDefaults standardUserDefaults]stringForKey:kdeviceTokenKey];
    if(savedValue==nil){
        savedValue=@"";
    }
    return savedValue;
}
+(void)saveUserDetails:(DriverInfoRecords*)userInfoRec{
    NSData* data=[NSKeyedArchiver archivedDataWithRootObject:[self recordsToDict:userInfoRec]];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kDriverInfo];
}
+(NSDictionary *)recordsToDict:(DriverInfoRecords *)userInfoRec{
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    [dict setObject:userInfoRec.driverId forKey:@"driver_id"];
    [dict setObject:userInfoRec.driverName forKey:@"driver_name"];
    [dict setObject:userInfoRec.driverImage forKey:@"driver_image"];
    [dict setObject:userInfoRec.driverEmail forKey:@"email"];
    [dict setObject:userInfoRec.driverVehicModel forKey:@"vehicle_model"];
    [dict setObject:userInfoRec.driverVehicNumber forKey:@"vehicle_number"];
    [dict setObject:userInfoRec.driverKey forKey:@"key"];
    return dict;
}
+(void)ClearUserDetails{
    NSData* data=[NSKeyedArchiver archivedDataWithRootObject:nil];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kDriverInfo];
}

+(NSDictionary *)retrieveUserData{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kDriverInfo];
    NSDictionary* myDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return myDictionary;
}
+(BOOL)UserIsLogin{
    if ([[[NSUserDefaults standardUserDefaults] dictionaryRepresentation].allKeys containsObject:kDriverInfo]){
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kDriverInfo];
        NSDictionary* myDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(myDictionary!=nil){
            return YES;
        }
    }
    return NO;
}
+(NSDictionary *)DriverAllInfoDatas{
    if([self UserIsLogin]){
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kDriverInfo];
        NSDictionary* myDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        return myDictionary;
    }
    return nil;
}
+(void)SaveUSerISOnline:(NSString*)driverStatus{
    [[NSUserDefaults standardUserDefaults] setObject:[Theme checkNullValue:driverStatus] forKey:kDriverGoOnline];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(BOOL )retrieveDriverOnline{
    BOOL IsOnline=NO;
    if([Theme UserIsLogin]){
      NSString *  savedValue = [[NSUserDefaults standardUserDefaults]
                      stringForKey:kDriverGoOnline];
        if([savedValue isEqualToString:@"1"]){
            IsOnline=YES;
        }else{
          IsOnline=YES;
        }
    }
    
    return IsOnline;
}
+ (NSString *)findCurrencySymbolByCode:(NSString *)_currencyCode
{
    NSNumberFormatter *fmtr = [[NSNumberFormatter alloc] init];
    NSLocale *locale = [self findLocaleByCurrencyCode:_currencyCode];
    NSString *currencySymbol;
    if (locale)
        [fmtr setLocale:locale];
    [fmtr setNumberStyle:NSNumberFormatterCurrencyStyle];
    currencySymbol = [fmtr currencySymbol];
    
    if (currencySymbol.length > 1)
        currencySymbol = [currencySymbol substringToIndex:1];
    return currencySymbol;
}
+(NSLocale *) findLocaleByCurrencyCode:(NSString *)_currencyCode
{
    NSArray *locales = [NSLocale availableLocaleIdentifiers];
    NSLocale *locale = nil;
    
    for (NSString *localeId in locales) {
        locale = [[NSLocale alloc] initWithLocaleIdentifier:localeId];
        NSString *code = [locale objectForKey:NSLocaleCurrencyCode];
        if ([code isEqualToString:_currencyCode])
            break;
        else
            locale = nil;
    }
    return locale;
}
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
+(NSDate*)setDate:(NSString*)dateStr{
    if ([dateStr isKindOfClass:[NSDate class]]) {
        return (NSDate*)dateStr;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    return date;
}
+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
+ (BOOL)isEndDateIsSmallerThanCurrent:(NSDate *)checkEndDate
{
    NSDate* enddate = checkEndDate;
    NSDate* currentdate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
    
    if (secondsBetweenDates == 0)
        return YES;
    else if (secondsBetweenDates < 0)
        return YES;
    else
        return NO;
}
+(void)SetLanguageToApp{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"LanguageNameCabilyPartner"];
    if([savedValue isEqualToString:@"es"]){
        setApplicationLanguage(SpanishLanguageShortName);
    }else{
        setApplicationLanguage(EnglishUSLanguageShortName);
    }
}
+(void)saveLanguage:(NSString *)str{
    if([str isEqualToString:@"es"]){
        str=@"es";
    }else{
        str=@"en";
    }
    NSString *valueToSave = str;
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"LanguageNameCabilyPartner"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getCurrentLanguage
{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"LanguageNameCabilyPartner"]);
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"LanguageNameCabilyPartner"];
}


/// xmpp
+(void)saveXmppUserCredentials:(NSString *)str{
   
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"xmppusercredentialsdectar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(NSString*)getXmppUserCredentials
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"xmppusercredentialsdectar"];
}


+(NSString*)project_getAppName {
    return NSBundle.mainBundle.infoDictionary[@"CFBundleName"];
}
+(void)saveDistanceString:(NSString *)str{
    
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"DistanceStingCabilyPartner"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(NSString*)getCurrentDistanceString
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"DistanceStingCabilyPartner"];
}
@end
