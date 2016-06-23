//
//  Constant.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/21/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constant : NSObject
#define NoNetworkCon @"NoNetworkConnection"
#define kdeviceTokenKey @"deviceToken"
#define kDriverInfo @"DriverInfokey"
#define kDriverGoOnline @"DriverIsOnline"
#define kDriverReceiveNotif @"DriverIsONReceiveNotif"
#define kDriverCashPaymentNotif @"DriverCashPaymentNotif"
#define kDriverCashPaymentNotifWhenQuit @"DriverCashPaymentNotifWhenQuited"
#define kDriverPaymentCompletedNotif @"DriverPaymentCompletedNotif"
#define kUserCancelledDrive @"kUserCancelledDriveNotif"
#define kDriverReturnNotif @"AcceptReturntoHomeNotif"
#define kDriverAdvtInfo @"kDriverAdvtInfoNotif"
#define kDriverSessionOut @"sessionOutNotif"
#define kPushSaveKey @"PushSaveKey"
#define kNewTripKey @"newTripNotif"
#define kOpenGoogleMapScheme @"DectarDriver://"
#define kErrorMessage @"Unable_to_connect_server"



#define kGoogleApiKey @"AIzaSyDiRZLGamYwXyWZ3roXM8NyWpydYxzawOU"// Change Here the Google API key for MAp
#define kGoogleServerKey @"AIzaSyBA1tolFtCnjT02w9uiFNudgXU6UKwnZzw"// Change Here the Google Server key for MAp


#define kAppSupportEmailId @"info@exoticlimo.com.au" // Change Here the Support Email ID

#define kHockeyAppIdentifier @"0fd9b50950214edf83db1a3f1ff3b2a5"


#define baseUrl @"http://exoticlimoaustralia.com.au/" // Change Here the Base Url


#define xmppHostName @"exoticlimoaustralia.com.au"   ////192.168.1.150 //exoticlimoaustralia.com.au/   // Change Here XMPP Host Name
#define xMppJabberIdentity @"vps.exoticlimo.ssdhosts.com.au" //exoticlimoaustralia.com.au/ //casp83   // Change Here Jabber Identity

#define RegUrl baseUrl@"app/driver/signup"
#define CompletionUrl baseUrl@"app/driver/signup/success"
#define LoginUrl baseUrl@"provider/login"
#define UpdateCurrentLocationUrl baseUrl@"provider/update-driver-geo"
#define GoOnlineUrl baseUrl@"provider/update-availability"
#define DriverRejectRequest baseUrl@"provider/cancellation-reason"
#define DriverAcceptRequest baseUrl@"provider/accept-ride"
#define DriverArrivedLocation baseUrl@"provider/arrived"
#define DriverStartedTrip baseUrl@"provider/begin-ride"
#define DriverEndTrip baseUrl@"provider/end-ride"
#define DriverCacelTripWithReason baseUrl@"provider/cancel-ride"
#define getUserInfo baseUrl@"provider/get-rider-info"
#define getDriverTripsList baseUrl@"provider/my-trips/list"
#define getDriverTripsDetail baseUrl@"provider/my-trips/view"
#define requestForCashOTP baseUrl@"provider/receive-payment"
#define cashReceivedUrl baseUrl@"provider/payment-received"
#define requestPayment baseUrl@"provider/request-payment"
#define rateTheUser baseUrl@"app/review/options-list"
#define submitRate baseUrl@"app/review/submit"
#define LogoutUrl baseUrl@"provider/logout"
#define saveBankingUrl baseUrl@"provider/save-banking-info"
#define getBankingUrl baseUrl@"provider/get-banking-info"
#define paymentListUrl baseUrl@"provider/payment-list"
#define kPaymentDetailUrl baseUrl@"provider/payment-summary"
#define ContinueRideUrl baseUrl@"provider/continue-trip"
#define NoNeedPaymentUrl baseUrl@"provider/payment-completed"
#define GoogleLocation @"https://maps.googleapis.com/maps/api/place/autocomplete/json?&language=en"
#define ForgotPasswordUrl baseUrl@"provider/forgot-password"
#define ChangePasswordUrl baseUrl@"provider/change-password" 
#define StarterDataUrl baseUrl@"provider/dashboard?" //api/xmpp-status
#define XmppUpdateUrl baseUrl@"api/xmpp-status?"
#define getRouteFromGoogle @"https://maps.googleapis.com/maps/api/directions/json"
#define getLatLongToAddressGoogle @"https://maps.googleapis.com/maps/api/geocode/json?"
#define CheckPaymentStatusUrl baseUrl@"api/v3/check-trip-status"
#define getDriverLocationsUrl	 baseUrl@"v3/app/get-location-list" 
#define getDriverCategoryUrl	 baseUrl@"v3/app/get-category-list"
#define getCountryListURL	 baseUrl@"v3/app/get-country-list"
#define getVehicleListURL	 baseUrl@"v3/app/get-vehicle-list"
#define getVehicleMakerListURL	 baseUrl@"v3/app/get-maker-list" 
#define getVehicleModelListURL	 baseUrl@"v3/app/get-model-list"
#define getVehicleYearListURL	 baseUrl@"v3/app/get-year-list"
#define sendOTPRegURL	 baseUrl@"v3/app/send-otp-driver"
#define sendDriverImageURL	 baseUrl@"v3/app/save-image"
#define regDriverByApp	 baseUrl@"v3/app/register-driver"

@end
