
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

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define BGCOLOR [UIColor colorWithRed:249.0/255.0 green:102.0/255.0 blue:48.0/255.0 alpha:1.0]
#define BLUECOLOR [UIColor colorWithRed:40.0/255.0 green:203.0/255.0 blue:249.0/255.0 alpha:1.0]

//#define BGCOLOR [UIColor blackColor]

#define STATUSCOLOR [UIColor colorWithRed:248.0/255.0 green:149.0/255.0 blue:115.0/255.0 alpha:1.0]

#define GoogleClientKey @"AIzaSyD4P9ubntQmCPBL_fU1HMVWoDh0ghwg4TM"// @"AIzaSyB8Ro0ByGwGnL3jDHI1uJDpdog39-E1rpU"//@"AIzaSyBhislNhLCUHwO-EfErTGh9wU-8WZv5AGE"
#define GoogleServerKey @"AIzaSyD4P9ubntQmCPBL_fU1HMVWoDh0ghwg4TM" //182.156.95.138 1.39.63.251
#define kStripeKey @"pk_test_y1g9v956mLamOybYYODFN7FK"
#define kXmppHostName @"exoticlimoaustralia.com.au" //@"192.168.1.150" //@"67.219.149.186"
#define kXmppDomainPassword @"vps.exoticlimo.ssdhosts.com.au" //"casp83"  //@messaging.dectar.com "casp83"

#define SupportMail @"info@exoticlimo.com.au"

#define AppbaseUrl @"http://www.exoticlimoaustralia.com.au/"

#define GeoUpdate AppbaseUrl@"app/set-user-geo"
#define Map_and_Taxi_Selection AppbaseUrl @"app/get-map-view"
#define OTP AppbaseUrl @"app/register"
#define Login AppbaseUrl @"app/login"
#define mapEta AppbaseUrl @"app/get-eta"
#define applycoupon AppbaseUrl @"app/apply-coupon"
#define favouriteList AppbaseUrl @"app/favourite/display"
#define addfavourite AppbaseUrl@"app/favourite/add"
#define deleteList AppbaseUrl@"app/favourite/remove"
#define EditFavr AppbaseUrl@"app/favourite/edit"
#define ConfrimBooking AppbaseUrl@"app/book-ride"
#define deleteRide AppbaseUrl@"app/delete-ride"
#define RegisterAccount AppbaseUrl@"app/check-user"
#define MyrideList AppbaseUrl@"app/my-rides"
#define ViewRides AppbaseUrl@"app/view-ride"
#define changepassword AppbaseUrl@"app/user/change-password"
#define changename AppbaseUrl@"app/user/change-name"
#define changemobilenumber AppbaseUrl@"app/user/change-mobile"
#define invite AppbaseUrl@"app/get-invites"
#define AddEmergency AppbaseUrl@"app/user/set-emergency-contact"
#define DeleteEmergency AppbaseUrl@"app/user/delete-emergency-contact"
#define viewEmergency AppbaseUrl@"app/user/view-emergency-contact"
#define SoundEmergency AppbaseUrl@"app/user/alert-emergency-contact"
#define Mymoney AppbaseUrl@"app/get-money-page"
#define transcationList AppbaseUrl@"app/get-trans-list"
#define ReasonCancel AppbaseUrl@"app/cancellation-reason"
#define RideCancel AppbaseUrl@"app/cancel-ride"
#define ListofPayment AppbaseUrl@"app/payment-list"
#define PaymentByWallet AppbaseUrl@"app/payment/by-wallet"
#define PaymentByCash AppbaseUrl@"app/payment/by-cash"
#define paymentGetWay AppbaseUrl@"app/payment/by-gateway"
#define ReviewList AppbaseUrl@"app/review/options-list"
#define Loggout AppbaseUrl@"app/logout"
#define ReviewSubmit AppbaseUrl@"app/review/submit"
#define LocationsList AppbaseUrl@"app/get-location"
#define CategoryList AppbaseUrl@"app/get-category"
#define RateCardDetails AppbaseUrl@"app/get-ratecard"
#define AddWallet AppbaseUrl@"mobile/wallet-recharge/stripe-process"
#define Invoice AppbaseUrl@"app/mail-invoice"
#define detectiontionAuto AppbaseUrl@"app/payment/by-auto-detect"
#define Password_Reset AppbaseUrl@"app/user/reset-password"
#define Password_Update AppbaseUrl@"app/user/update-reset-password"
#define Social_Check AppbaseUrl@"app/social-check"
#define Social_login AppbaseUrl@"app/social-login"
#define Driver_Track AppbaseUrl@"api/v3/track-driver"
#define Tips_Adding AppbaseUrl@"app/apply-tips"
#define Tips_Remove AppbaseUrl@"app/remove-tips"
#define GetFare AppbaseUrl@"app/get-fare-breakup"
#define ForXMPP AppbaseUrl@"api/xmpp-status"
#define ShareETA AppbaseUrl@"api/v3/track-driver/share-my-ride"
#define getLatLongToAddressGoogle @"https://maps.googleapis.com/maps/api/geocode/json?"
#define getRouteFromGoogle @"https://maps.googleapis.com/maps/api/directions/json"
