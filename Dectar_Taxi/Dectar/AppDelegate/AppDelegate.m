//
//  AppDelegate.m
//  Dectar
//
//  Created by Suresh J on 08/07/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "AppDelegate.h"
#import "Constant.h"
#import <GoogleMaps/GoogleMaps.h>

#import "LoginMainVC.h"
#import "Themes.h"
#import "FareRecord.h"
#import <CoreLocation/CoreLocation.h>
#import "SMBInternetConnectionIndicator.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "Constant.h"
#import "FareVC.h"
#import "AdvertsRecord.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "XMLReader.h"
#import "UrlHandler.h"
#import "Driver_Record.h"
#import "NewTrackVC.h"
#import "DEMORootViewController.h"
#import <HockeySDK/HockeySDK.h>

@interface AppDelegate ()<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    Reachability*internetReachableHandler;
    FareRecord * ObjRec;
    SMBInternetConnectionIndicator * banner;
    AVAudioPlayer * audioplayer;
    UIAlertView *NOInetrnet,*haveInternet;
    AdvertsRecord * Ads_objRec;
    NSDictionary *dictCodes ;
    Driver_Record * ObjDriverRecord;
    UIAlertView    *CancelAlert;
    BOOL isXMPPDisConnected;

}
@property (strong ,nonatomic)CLLocationManager * currentLocation;

@end

@implementation AppDelegate
@synthesize currentLocation,IsShowing;
@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize wifiReachability,wwanReachability,isNetworkAvailable,currentView,connectionTimer;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   /* CTTelephonyNetworkInfo *network_Info = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = network_Info.subscriberCellularProvider;
    
    NSLog(@"country code is: %@", carrier.mobileCountryCode);
    
    //will return the actual country code
    NSLog(@"ISO country code is: %@", carrier.isoCountryCode);*/
  
    dictCodes= [Themes getCountryList];
    
    [GMSServices provideAPIKey:GoogleClientKey];
    
    currentLocation = [[CLLocationManager alloc] init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        [currentLocation requestAlwaysAuthorization];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
//        currentLocation.allowsBackgroundLocationUpdates = YES;
        [currentLocation requestAlwaysAuthorization];

                                                                                                                                                                                                                                                                                                                                                                                     }
    [currentLocation startUpdatingLocation];
    [currentLocation requestWhenInUseAuthorization];
    [currentLocation setDelegate:self];

    //*************************************************************************//
    //     Monitoring network reachability
    //*************************************************************************//
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    
    if(!wifiReachability)
        wifiReachability = [Reachability reachabilityForLocalWiFi];
    
    if(!wwanReachability)
        wwanReachability = [Reachability reachabilityForInternetConnection];
    
    
    [wifiReachability startNotifier]; // It will inform changes in wifi network
    
    [wwanReachability startNotifier]; // It will inform changes in cellular network
    
    wifiStatus = [wifiReachability currentReachabilityStatus];
    wwanStatus = [wwanReachability currentReachabilityStatus];
    
    isNetworkAvailable = (wifiStatus == ReachableViaWiFi) || (wwanStatus == ReachableViaWWAN);
    
    if(wifiStatus == ReachableViaWiFi)
    {
        NSLog(@"Net work reachable through wifi");
    }
    else if(wwanStatus == ReachableViaWWAN)
    {
        NSLog(@"Net work reachable through wwan");
    }
    else
    {
        NSLog(@"No wan found...");
    }
    
    internetReachableHandler = [Reachability reachabilityForInternetConnection];
    [internetReachableHandler startNotifier];
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"4f4f1ef66ab34a77ae92b69d747b601c"];
    // Do some additional configuration if needed here
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
    NSURL* url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    
   /*if ([Themes getUserID]==nil)
    {
        [self Logoutroot];
    }*/
    if ([Themes getUserID] !=nil)
    {
            [self setInitialViewController];
        
    }
    else if ([url.description containsString:@"cabilydectar"])
    {
        if ([Themes getUserID].length >0)
        {
            NSDictionary *userDict = [self urlPathToDictionary:url.absoluteString];
            NSString * rideIdStr=[Themes checkNullValue:[userDict valueForKey:@"ride_id"]];
            if(rideIdStr.length>0){
                ObjRec=[[FareRecord alloc]init];
                ObjRec.ride_id=rideIdStr;
                [self performSelector:@selector(ShareEta) withObject:nil afterDelay:1.0];
                UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                NewTrackVC*rootNewTrackVC = [storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
                self.window.rootViewController = rootNewTrackVC;
            }
        }
        else
        {
            //UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            UINavigationController *rootView = (UINavigationController*)[sb instantiateViewControllerWithIdentifier:@"LoginNavigation"];
            [appDel.window setRootViewController:rootView];
            [self performSelector:@selector(ShareEta) withObject:nil afterDelay:1.0];
            
        }
       
    }
    else
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        UINavigationController *rootView = (UINavigationController*)[sb instantiateViewControllerWithIdentifier:@"LoginNavigation"];
        [appDel.window setRootViewController:rootView];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//         NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
//         if([language hasPrefix:@"es"]){
//         [Themes saveLanguage:@"es"];
//         }
//         else
//         {
//           [Themes saveLanguage:@"en"];
//         }
        [Themes saveLanguage:@"en"];
        [Themes SetLanguageToApp];
      
    }
    
    [Stripe setDefaultPublishableKey:kStripeKey];
    
    NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if(remoteNotif)
    {
        [self pushNotificationHandler:remoteNotif];
    }

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    
    
    return YES;
}

- (void) receiveLanguageChangedNotification22:(NSNotification *) notification
{
    
}

-(void)setInitialViewController{
    
    if([Themes getUserID] !=nil){
        if(([Themes getUserID] !=nil)){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            DEMORootViewController * objLoginVc=[mainStoryboard instantiateViewControllerWithIdentifier:@"rootController"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginVc];
            
            //UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"menuController1"];
            //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
            [navigationController setNavigationBarHidden:YES animated:YES];
            
            self.window.rootViewController = navigationController;
            self.window.backgroundColor = [UIColor whiteColor];
            [self.window makeKeyAndVisible];
        }
    }
}

-(void)ShareEta
{
    if ([Themes getUserID].length >0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"ShareETA" object:ObjRec];

    }
    else
    {
        UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:[Themes getAppName]
                                                           message:@"Kindly login to track you ride"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [alert show];

    }

}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    if ([[url scheme] containsString:@"cabilydectar"])
    {
        
        if ([Themes getUserID].length >0)
        {
            NSDictionary *userDict = [self urlPathToDictionary:url.absoluteString];
            ObjRec=[[FareRecord alloc]init];
            ObjRec.ride_id=[Themes checkNullValue:[userDict valueForKey:@"ride_id"]];
            if(ObjRec.ride_id.length>0){
                [[NSNotificationCenter defaultCenter] postNotificationName: @"ShareETA" object:ObjRec];
                UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                NewTrackVC*rootNewTrackVC = [storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
                self.window.rootViewController = rootNewTrackVC;
            }
        }
        else
        {
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:[Themes getAppName]
                                                               message:@"Kindly login to track you ride"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
        }

    }
    else
    {
        [[FBSDKApplicationDelegate sharedInstance] application:application
                                                       openURL:url
                                             sourceApplication:sourceApplication
                                                    annotation:annotation];

    }

    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{       CLGeocoder*geocoder = [[CLGeocoder alloc] init];
    
    if (locations == nil)
        return;
    
    CLLocation *current = [locations objectAtIndex:0];
    if(current.coordinate.latitude!=0){
        [geocoder reverseGeocodeLocation:current completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (placemarks == nil)
                 return;
             
             CLPlacemark *currentLocPlacemark = [placemarks objectAtIndex:0];
             NSString *code= [currentLocPlacemark ISOcountryCode];
             code=[[dictCodes valueForKey:code]objectAtIndex:1];
             NSLog(@"%@",code);
             currentLocation = nil;
             [Themes SaveCountryCode:[NSString stringWithFormat:@"+%@",code]];
             [currentLocation stopUpdatingLocation];
             
         }];
    }
    
}

-(void)handleNetworkChange:(NSNotification *)notification
{
    @try{
        
        NSLog(@"||||||||||||----Network changed: %@----|||||||||||",[notification object]);
        
        NetworkStatus remoteHostStatus = [[notification object] currentReachabilityStatus];
        
        if(!wwanReachability)
            wwanReachability = [Reachability reachabilityForInternetConnection];
        
        [wwanReachability startNotifier];
        
        wwanStatus=[wwanReachability currentReachabilityStatus];
        
        
        if(remoteHostStatus == NotReachable)
        {
            isNetworkAvailable = NO;
            
            isNetworkAvailable = ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi) || ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN);
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NoNetworkMsgPush" object:self];
            
            NSLog(@"Network Reachable....%@",isNetworkAvailable?@"available":@"unavailable.");
        }
        else
        {
            if (remoteHostStatus == ReachableViaWiFi)
            {
                NSLog(@"ReachableViaWiFi....");
                
                isNetworkAvailable=YES;
                
            }
            if (remoteHostStatus == ReachableViaWWAN)
            {
                NSLog(@"ReachableViaWWAN....");
                
                BOOL isConnectedWith3G = [wwanReachability connectionRequired];
                
                if (isConnectedWith3G) {
                    
                    isNetworkAvailable=NO;
                    
                }
                else
                {
                    isNetworkAvailable=YES;
                    
                    
                }
                NSLog(@"Connecting through 3G Network........ ");
            }
            
            if ([xmppStream isDisconnected]) {
                
                [self disconnect];
                [self connect];
                
            }
            
        }

        
    }
    @catch (NSException *e) {
        
        NSLog(@"Exception in Reachability Notification..%@",e);
    }
}
-(void)dismiss:(UIAlertView*)alert
{
   
    if (alert==NOInetrnet)
    {
        [NOInetrnet dismissWithClickedButtonIndex:0 animated:YES];

    }
    else if (alert ==haveInternet)
    {
        [haveInternet dismissWithClickedButtonIndex:0 animated:YES];

    }
}
-(void)playAudio{
    if(audioplayer==nil){
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/NoInternet.wav", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error;
        audioplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioplayer.numberOfLoops = -1;
        [audioplayer play];
    }
}
- (void) stopAudio
{
    [audioplayer stop];
    [audioplayer setCurrentTime:0];
    audioplayer=nil;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if([CLLocationManager locationServicesEnabled]){
        
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
        }
    }
}
-(void)LogIn
{
    [self setInitialViewController];

}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [Themes SaveDeviceToken:devToken];
    
}
-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self pushNotificationHandler:userInfo];

    
}
-(void)pushNotificationHandler:(NSDictionary *)userInfo
{
    NSString * ActionMsg=[[userInfo valueForKey:@"message"]valueForKey:@"action"];
    NSDictionary * MessageDict=userInfo[@"message"];
    
    if ([ActionMsg isEqualToString:@"ride_confirmed"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"pushnotification" object:MessageDict];
        
        
    }
    if ([ActionMsg isEqualToString:@"cab_arrived"])
    {
        ObjRec=[[FareRecord alloc]init];
        ObjRec.ride_id=[MessageDict valueForKey:@"key1"];
        ObjRec.driverLat=[MessageDict valueForKey:@"key3"];
        ObjRec.driverLong=[MessageDict valueForKey:@"key4"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cab_arrived" object:ObjRec];
        
        
    }
    if ([ActionMsg isEqualToString:@"ride_completed"])
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ride_completed" object:MessageDict];
        
        
    }
    if ([ActionMsg isEqualToString:@"payment_paid"])
    {
        
        ObjRec=[[FareRecord alloc]init];
        ObjRec.ride_id=[MessageDict valueForKey:@"key1"];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"payment_paid" object:ObjRec];
        
    }
    if ([ActionMsg isEqualToString:@"requesting_payment"])
    {
        ObjRec=[[FareRecord alloc]init];
        ObjRec.ride_id=[MessageDict valueForKey:@"key6"];
        
        /*ObjRec.TotalBill=[[userInfo valueForKey:@"message"]valueForKey:@"key2"];
         ObjRec.duration=[[userInfo valueForKey:@"message"]valueForKey:@"key4"];
         ObjRec.waiting=[[userInfo valueForKey:@"message"]valueForKey:@"key5"];
         ObjRec.distance=[[userInfo valueForKey:@"message"]valueForKey:@"key3"];
         ObjRec.ride_id=[[userInfo valueForKey:@"message"]valueForKey:@"key6"];
         ObjRec.CurrencySymbol=[[userInfo valueForKey:@"message"]valueForKey:@"key1"];*/
        
        [[NSNotificationCenter defaultCenter] postNotificationName: @"ride_completed" object:ObjRec];
    }
    
    if ([ActionMsg isEqualToString:@"ride_cancelled"])
    {
        CancelAlert= [[UIAlertView alloc] initWithTitle:[Themes getAppName]
                                                message:@"Sorry Your Ride has been cancelled"
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [CancelAlert show];
        
    }
    if ([ActionMsg isEqualToString:@"ads"])
    {
        
        Ads_objRec=[[AdvertsRecord alloc]init];
        Ads_objRec.Title=[MessageDict valueForKey:@"key1"];
        Ads_objRec.Description=[MessageDict valueForKey:@"key2"];
        Ads_objRec.Images=[MessageDict valueForKey:@"key3"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Advertisment" object:Ads_objRec];
        
    }
    if ([ActionMsg isEqualToString:@"trip_begin"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Ride_start" object:MessageDict];
        
    }

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==CancelAlert)
    {
        if (buttonIndex==0)
        {
            [self LogIn];
 
        }
    }
}
-(void)AdVerts
{
    [self coreManagementWithPosition:EMNotificationPopupPositionCenter andType:EMNotificationPopupBigButton];

}
- (void) coreManagementWithPosition: (EMNotificationPopupPosition) position andType:(EMNotificationPopupType) notificationPopupType {
    if (_notificationPopup.isVisible) {
        [_notificationPopup dismissWithAnimation:YES];
        _notificationPopup = NULL;
    } else {
        _notificationPopup = [[EMNotificationPopup alloc] initWithType:notificationPopupType enterDirection:EMNotificationPopupToDown exitDirection:EMNotificationPopupToLeft popupPosition:position];
        _notificationPopup.delegate = self;
        
        _notificationPopup.title = @"Sorry for this Alert message :)";
        _notificationPopup.subtitle = @"Awesome message :)";
        _notificationPopup.image = [UIImage imageNamed:@"carimage"];
        
        if (notificationPopupType == EMNotificationPopupBigButton)
            _notificationPopup.actionTitle = @"OK";
        
        [_notificationPopup show];
    }
}
- (void) emNotificationPopupActionClicked {
    [_notificationPopup dismissWithAnimation:YES];
}

- (void) dismissCustomView {
    [_notificationPopup dismissWithAnimation:YES];
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

-(void)Logoutroot
{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController *rootView = (UINavigationController*)[sb instantiateViewControllerWithIdentifier:@"LoginNavigation"];
    [appDel.window setRootViewController:rootView];

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
    [connectionTimer invalidate];
    [self disconnect];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground");

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    /*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kReachabilityChangedNotification object:nil];
    [self performSelector:@selector(dismiss:) withObject:errorView afterDelay:0.10];*/
//    if (IsShowing==YES)
//    {
//        [self networkChanged];
//
//    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kReachabilityChangedNotification object:nil];
    /*[self performSelector:@selector(dismiss:) withObject:errorView afterDelay:0.10];*/
    
    NSLog(@"applicationDidBecomeActive");
    [FBSDKAppEvents activateApp];
    
    if (connectionTimer)
    {
        [connectionTimer invalidate];
    }
    connectionTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(checkConnectionTimer) userInfo:nil repeats:YES];
    
    if ([Themes getUserID]!=nil)
    {
        if (![xmppStream isDisconnected]) {
            
            [self disconnect];
        }
        [self connect];
    }
    
    
    if ([Themes getUserID]!=nil)
    {
        [self disconnect];
        [self connect];
    }

}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark Check Connection Timer
-(void)checkConnectionTimer
{
    @try {
        [NSThread detachNewThreadSelector:@selector(checkConnectionAvailability) toTarget:self withObject:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in checkConnectionTimer..");
    }
    
}
#pragma mark Check Connection Availability
-(void)checkConnectionAvailability
{
    @try {
        
        if (isNetworkAvailable)
        {
            if([Themes getUserID]!=nil)
            {
                [self xmppState];
                
                if (isXMPPDisConnected)
                {
                    [self connect];
                }
                else
                {
                    NSLog(@"XMPP not disconnected");
                }
                
            }
            else
            {
                NSLog(@"User not logged in");
            }
        }
        else
        {
            NSLog(@"Network/Server Unavailable");
            
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception...checkConnectionAvailability");
    }
}


#pragma XMPP

-(void)connectToXmpp{
    
    if ([Themes getUserID]!=nil)
    {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [self connect];
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSDictionary *userInfo = [error userInfo];
    NSString *errorString = [userInfo objectForKey:NSLocalizedDescriptionKey];
    
    NSLog(@"Error..........%@",errorString);
    NSLog(@"Error IP.......%@",xmppStream.hostName);
    
    if (errorString && ![errorString isEqualToString:@"Network is unreachable"] && [Themes getUserID]!=nil)
    {
        if(isNetworkAvailable){
            [self connect];
        }
        
    }
}

- (void)setupStream {
    
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    xmppStream.hostName=@"exoticlimoaustralia.com.au";//
//    xmppStream.hostName=@"67.219.149.186";
    //xmppStream.hostPort=5222;
    
}

- (void)goOnline {
    
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline {
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}


- (void)disconnect {
    isXMPPDisConnected = YES;
    [self XMPP_Unplug];
    [self goOffline];
    [xmppStream disconnect];
}


- (BOOL)connect {

    [self setupStream];
    
    NSString *jabberID = [NSString stringWithFormat:@"%@@%@",[Themes getUserID],kXmppDomainPassword]; // @messaging.dectar.com
    NSString *myPassword = [Themes getXmppUserCredentials];
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    
    if (jabberID == nil || myPassword == nil) {
        
        return NO;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithString:jabberID]];
    //    password = myPassword;
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"Can't connect to server %@", [error localizedDescription]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        
        return NO;
    }
    else
    {
        NSLog(@"Connection success");
        return YES;
    }
    
    return YES;
}

#pragma mark -
#pragma mark XMPP delegates

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    isXMPPDisConnected = NO;
    NSError *error = nil;
    [[self xmppStream] authenticateWithPassword:[Themes getXmppUserCredentials] error:&error];
    if (error==nil)
    {
        [self XMPP_Plug];
    }
    else
    {
        isXMPPDisConnected = YES;
    }
    
}

-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    UIAlertView *timeOutView = [[UIAlertView alloc] initWithTitle:@"Time-out" message:@"Connection timeout please try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [timeOutView show];
    
    NSLog(@"Handle timeout issues");
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    [self goOnline];
    
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)element
{
    // This method is executed on our moduleQueue.
    
    // <stream:error>
    //   <conflict xmlns="urn:ietf:params:xml:ns:xmpp-streams"/>
    //   <text xmlns="urn:ietf:params:xml:ns:xmpp-streams" xml:lang="">Replaced by new connection</text>
    // </stream:error>
    //
    // If our connection ever gets replaced, we shouldn't attempt a reconnect,
    // because the user has logged in on another device.
    // If we still applied the reconnect logic,
    // the two devices may get into an infinite loop of kicking each other off the system.
    
    NSString *elementName = [element name];
    NSString *myJid = (NSString *)[sender myJID];
    
    
    NSString *resultString = [[[NSString stringWithFormat:@"%@",myJid] componentsSeparatedByString:@"@"] objectAtIndex:0];
    
    NSString *userName = [[Themes getUserID] lowercaseString];
    
    if ([elementName isEqualToString:@"stream:error"] || [elementName isEqualToString:@"error"])
    {
        NSXMLElement *r_conflict = [element elementForName:@"conflict" xmlns:@"urn:ietf:params:xml:ns:xmpp-streams"];
        
        if (r_conflict)
        {
            [self disconnect];
            
            if ([resultString isEqualToString:userName])
            {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Conflict" message:@"Same User has been logged in into other device" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [errorAlert show];
            }
            else
            {
                
            }
        }
        
    }
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    
    return NO;
    
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    @try {
        NSLog(@"Receive success %@",message);
        NSString *testXMLString =[NSString stringWithFormat:@"%@",message];
        // Parse the XML into a dictionary
        NSError *parseError = nil;
        NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:testXMLString error:&parseError];
        NSLog(@"%@", xmlDictionary);
        
        NSString * TextContent=[[[xmlDictionary valueForKey:@"message"] valueForKey:@"body"] valueForKey:@"text"];
        
        NSString *xmppRecMsg = [[TextContent
                                 stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                                stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSData *data = [xmppRecMsg dataUsingEncoding:NSUTF8StringEncoding];
        id recMsgDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if(recMsgDict!=nil&&[recMsgDict count]>0)
        {
            NSLog(@"%@",recMsgDict);
            
            
            NSString * ActionMsg=[recMsgDict valueForKey:@"action"];
            
            if ([ActionMsg isEqualToString:@"ride_confirmed"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName: @"pushnotification" object:recMsgDict];
                
                
            }
            else if ([ActionMsg isEqualToString:@"cab_arrived"])
            {
                
                ObjRec=[[FareRecord alloc]init];
                ObjRec.ride_id=[Themes checkNullValue:[recMsgDict valueForKey:@"key1"]];
                ObjRec.Message=[Themes checkNullValue:[recMsgDict valueForKey:@"message"]];
                ObjRec.driverLat=[Themes checkNullValue:[recMsgDict valueForKey:@"key3"]];
                ObjRec.driverLong=[Themes checkNullValue:[recMsgDict valueForKey:@"key4"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cab_arrived" object:ObjRec];
                //[self LogIn];
                
            }
            else if ([ActionMsg isEqualToString:@"ride_completed"])
            {
                ObjRec=[[FareRecord alloc]init];
                ObjRec.ride_id=[Themes checkNullValue:[recMsgDict valueForKey:@"key1"]];
                ObjRec.Message=[Themes checkNullValue:[recMsgDict valueForKey:@"message"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ride_completed" object:ObjRec];
                
                
            }
            else if ([ActionMsg isEqualToString:@"payment_paid"])
            {
                ObjRec=[[FareRecord alloc]init];
                ObjRec.ride_id=[Themes checkNullValue:[recMsgDict valueForKey:@"key1"]];
                [[NSNotificationCenter defaultCenter] postNotificationName: @"payment_paid" object:ObjRec];
                
            }
            else if ([ActionMsg isEqualToString:@"requesting_payment"])
            {
                ObjRec=[[FareRecord alloc]init];
                ObjRec.ride_id=[Themes checkNullValue:[recMsgDict valueForKey:@"key6"]];
                [[NSNotificationCenter defaultCenter] postNotificationName: @"waitingfor_payment" object:ObjRec];
            }
            
            else if ([ActionMsg isEqualToString:@"ride_cancelled"])
            {
                CancelAlert= [[UIAlertView alloc] initWithTitle:[Themes getAppName]
                                                        message:@"Sorry Your Ride has been cancelled"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                [CancelAlert show];
                
            }
            else if ([ActionMsg isEqualToString:@"ads"])
            {
                
                Ads_objRec=[[AdvertsRecord alloc]init];
                Ads_objRec.Title=[Themes checkNullValue:[recMsgDict valueForKey:@"key1"]];
                Ads_objRec.Description=[Themes checkNullValue:[recMsgDict valueForKey:@"key2"]];
                Ads_objRec.Images=[Themes checkNullValue:[recMsgDict valueForKey:@"key3"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Advertisment" object:Ads_objRec];
                
            }
            else if ([ActionMsg isEqualToString:@"trip_begin"])
            {
                ObjRec=[[FareRecord alloc]init];
                ObjRec.ride_id=[Themes checkNullValue:[recMsgDict valueForKey:@"key1"]];
                ObjRec.Message=[Themes checkNullValue:[recMsgDict valueForKey:@"message"]];
                ObjRec.DropLatitude=[Themes checkNullValue:[recMsgDict valueForKey:@"key3"]];
                ObjRec.DropLongitude=[Themes checkNullValue:[recMsgDict valueForKey:@"key4"]];
                
                ObjRec.driverLat=[Themes checkNullValue:[recMsgDict valueForKey:@"key5"]];
                ObjRec.driverLong=[Themes checkNullValue:[recMsgDict valueForKey:@"key6"]];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Ride_start" object:ObjRec];
                
            }
            else if ([ActionMsg isEqualToString:@"make_payment"])
            {
                ObjRec=[[FareRecord alloc]init];
                ObjRec.ride_id=[Themes checkNullValue:[recMsgDict valueForKey:@"key1"]];
                ObjRec.Message=[Themes checkNullValue:[recMsgDict valueForKey:@"message"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ride_completed" object:ObjRec];
                
            }
            else if ([ActionMsg isEqualToString:@"driver_loc"])
            {
                
                if ([currentView isEqualToString:@"NewTrackVC"]) {
                    
                    ObjDriverRecord=[[Driver_Record alloc]init];
                    ObjDriverRecord.Driver_latitude=[Themes checkNullValue:[recMsgDict valueForKey:@"latitude"]];
                    ObjDriverRecord.Driver_longitude=[Themes checkNullValue:[recMsgDict valueForKey:@"longitude"]];
                    ObjDriverRecord.RideID=[Themes checkNullValue:[recMsgDict valueForKey:@"ride_id"]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Updatedriver_loc" object:ObjDriverRecord];
                    
                }
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
    NSLog(@"Send success %@",message);
    // [[NSNotificationCenter defaultCenter] postNotificationName: @"SendMessage" object:message];
    
    
}
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
    NSString *jidUserTypeStr = [presence type];
    
    NSString *jidUserStr = [[presence from] user];
    
    if ([jidUserTypeStr isEqualToString:@"available"]) {
        
        isXMPPDisConnected = NO;
    }
    else
    {
        isXMPPDisConnected = YES;
        [self disconnect];
    }
    
    NSLog(@"presnece......User->%@..UserPresence->%@",jidUserStr,jidUserTypeStr);
    
    
    
}
#pragma mark - XMPP State
/**
 * Called to whether XMPP is connected/disconnected for Reconnection process
 */
-(void)xmppState
{
    if (xmppStream == nil)
    {
        // xmppStream = [[XMPPStream alloc] init];
        isXMPPDisConnected = YES;
    }
    else
    {
        isXMPPDisConnected = [xmppStream isDisconnected];
        
        NSLog(@"%hhd",isXMPPDisConnected);
    }
    
    
}

- (void)xmppRoster:(XMPPStream *)sender didReceiveRosterItem:(DDXMLElement *)item {
    
    NSLog(@"Did receive Roster item");
    
    
}
-(void)XMPP_Plug
{
    NSDictionary* parameter=@{@"user_type":@"user",
                              @"id":[Themes writableValue:[Themes getUserID]],
                              @"mode":@"available"};
    UrlHandler * webhandler=[UrlHandler UrlsharedHandler];
    [webhandler CheckXMPP:parameter success:^(NSMutableDictionary *responseDictionary) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
-(void)XMPP_Unplug
{
    NSDictionary* parameter=@{@"user_type":@"user",
                              @"id":[Themes writableValue:[Themes getUserID]],
                              @"mode":@"unavailable"};
    UrlHandler * webhandler=[UrlHandler UrlsharedHandler];
    [webhandler CheckXMPP:parameter success:^(NSMutableDictionary *responseDictionary) {
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma URL SCHEME

-(NSDictionary *)urlPathToDictionary:(NSString *)path
{
    //Get the string everything after the :// of the URL.
    NSString *stringNoPrefix = [[path componentsSeparatedByString:@"://"] lastObject];
    //Get all the parts of the url
    NSMutableArray *parts = [[stringNoPrefix componentsSeparatedByString:@"/"] mutableCopy];
    //Make sure the last object isn't empty
    if([[parts lastObject] isEqualToString:@""])[parts removeLastObject];
    
    if([parts count] % 2 != 0)//Make sure that the array has an even number
        return nil;
    
    //We already know how many values there are, so don't make a mutable dictionary larger than it needs to be.
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:([parts count] / 2)];
    
    //Add all our parts to the dictionary
    for (int i=0; i<[parts count]; i+=2) {
        [dict setObject:[parts objectAtIndex:i+1] forKey:[parts objectAtIndex:i]];
    }
    
    //Return an NSDictionary, not an NSMutableDictionary
    return [NSDictionary dictionaryWithDictionary:dict];
}
@end
