//
//  AppDelegate.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/21/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "DEMORootViewController.h"


@interface AppDelegate ()<ITRAirSideMenuDelegate>{
    Reachability *internetReachableHandler;
    Reachability *  reachability;
}

@end


@implementation AppDelegate

@synthesize xmppStream;
@synthesize xmppRoster,isXmppActive,connectionTimer,isInternetAvailable;
-(BOOL) isInternetAvailableFor
{
   
    return isInternetAvailable;
}
- (void) handleNetworkChangeDelegate:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
   
    if(remoteHostStatus == NotReachable) {
        isInternetAvailable=NO;
        [self playAudio];
    }
    else  {
         isInternetAvailable=YES;
        [self stopAudio];
    }
}
-(void)playAudio{
    if(audioPlayer==nil){
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/NoInternetSound.wav", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops = -1;
        [audioPlayer play];
    }
}
- (void) stopAudio
{
    [audioPlayer stop];
    [audioPlayer setCurrentTime:0];
    audioPlayer=nil;

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    [GMSServices provideAPIKey:kGoogleApiKey];
    
    //// xmpp
[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleNetworkChangeDelegate:) name: kReachabilityChangedNotification object: nil];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {
         isInternetAvailable=NO;
    }else{
         isInternetAvailable=YES;
    }
    [self connectToXmpp];

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
    if([Theme UserIsLogin]){
       
        [self setInitialViewController];
    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
       /* [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        if([language hasPrefix:@"es"]){
            [Theme saveLanguage:@"es"];
        }else{
            [Theme saveLanguage:@"en"];
        }*/
        [Theme saveLanguage:@"en"];
        [Theme SetLanguageToApp];
    }
    
    NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if(remoteNotif)
    {
        [self pushNotificationHandler:remoteNotif];
    }
    [self loadHockeyApp];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    sleep(4);
    return YES;
}

-(void)loadHockeyApp{
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyAppIdentifier];
   // [[BITHockeyManager sharedHockeyManager].crashManager setCrashManagerStatus: BITCrashManagerStatusAutoSend];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation]; // This line is obsolete in the crash only builds
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    
    [Theme savePushNotificationID:devToken];
    
}
-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

    
    [self pushNotificationHandler:userInfo];
}

-(void)pushNotificationHandler:(NSDictionary *)userInfo{
    NSDictionary * messageDict=userInfo[@"message"];
    
    if([Theme retrieveDriverOnline]){
        if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[messageDict objectForKey:@"action"]]] isEqualToString:@"ride_request"]){
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kDriverReceiveNotif
             object:self userInfo:messageDict];
        }
        if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[messageDict objectForKey:@"action"]]] isEqualToString:@"receive_cash"]){
            // when user selects cod
            [self moveToPaymentPage:messageDict];
        }
        if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[messageDict objectForKey:@"action"]]] isEqualToString:@"payment_paid"]){
            //payment_paid user
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kDriverPaymentCompletedNotif
             object:self userInfo:messageDict];
        }
        if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[messageDict objectForKey:@"action"]]] isEqualToString:@"ride_cancelled"]){
            //ride cancelled user
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kUserCancelledDrive
             object:self userInfo:messageDict];
        }
        if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[messageDict objectForKey:@"action"]]] isEqualToString:@"new_trip"]){
            //ride cancelled user
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNewTripKey
             object:self userInfo:messageDict];
        }
        if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[messageDict objectForKey:@"action"]]] isEqualToString:@"ads"]){
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kDriverAdvtInfo
             object:self userInfo:messageDict];
            
        }
        
    }
}



-(void)moveToPaymentPage:(NSDictionary *)messageDict{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kDriverCashPaymentNotif
     object:self userInfo:messageDict];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kDriverCashPaymentNotifWhenQuit
     object:self userInfo:messageDict];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}
-(void)setInitialViewController{
   
    if([Theme UserIsLogin]){
        if([Theme UserIsLogin]){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            DEMORootViewController * objLoginVc=[mainStoryboard instantiateViewControllerWithIdentifier:@"rootController"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginVc];
            self.window.rootViewController = navigationController;
            self.window.backgroundColor = [UIColor whiteColor];
            [navigationController setNavigationBarHidden:YES animated:YES];
            [self.window makeKeyAndVisible];
        }
    }
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"Hi Hello");
    
    return YES;
}


+ (BOOL) checkLocationServicesTurnedOn {
    BOOL isLoc=TRUE;
    if (![CLLocationManager locationServicesEnabled]) {
        isLoc=FALSE;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Permission Denied"
                                                        message:@"'Location Services' need to be turn on."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
       isLoc=TRUE; 
    }
    return isLoc;
}
+(BOOL) checkApplicationHasLocationServicesPermission {
    BOOL isLoc=TRUE;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        isLoc=FALSE;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Permission Denied"
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        isLoc=TRUE;
    }
      return isLoc;
}


/////////////// xmpp
- (void)applicationWillResignActive:(UIApplication *)application {
[connectionTimer invalidate];
    [self logoutXmpp];
    
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
-(void)logoutXmpp{
    isXmppActive=NO;
    [self xmppUpdateMode];
    [self disconnect];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
if (connectionTimer)
    {
        [connectionTimer invalidate];
    }
    
    connectionTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkConnectionTimer) userInfo:nil repeats:YES];
    if([Theme UserIsLogin]){
        isXmppActive=YES;
if (![xmppStream isDisconnected]) {
        [self disconnect];
 }
        [self connect];
    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
        
        if ( isInternetAvailable==YES)
        {
            if([Theme UserIsLogin])
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

-(void)xmppUpdateMode{
 
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web XmppModeUpdate:[self setParametersUpdateUserOnOff]
                        success:^(NSMutableDictionary *responseDictionary)
     {
         
     }
                        failure:^(NSError *error)
     {
        
         //[self.view makeToast:kErrorMessage];
         
         
     }];
}
-(NSDictionary *)setParametersUpdateUserOnOff{
    NSString * xmppMode=@"unavailable";
    if(isXmppActive==YES){
        xmppMode=@"available";
    }
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"user_type":@"driver",
                                  @"id":driverId,
                                  @"mode":xmppMode
                                  };
    return dictForuser;
}

-(void)connectToXmpp{
    if([Theme UserIsLogin]){
       // if ([xmppStream isDisconnected]) {
            [DDLog addLogger:[DDTTYLogger sharedInstance]];
            [self connect];
       // }
        
    }
}

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

- (void)setupStream {
    
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    xmppStream.hostName=xmppHostName;
    //192.168.1.150
    //67.219.149.186
    //messaging.dectar.com
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
    [self goOffline];
    [xmppStream disconnect];
}

- (BOOL)connect {
    
    [self setupStream];
    NSString *driverId=@"";
    NSString * passwordStr=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
        passwordStr=[Theme getXmppUserCredentials];
    }
    
    NSString * userStr=[NSString stringWithFormat:@"%@@%@",driverId,xMppJabberIdentity]; //messaging.dectar.com //casp83
    NSString *jabberID = userStr;
    NSString *myPassword = passwordStr;
    
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
    [[self xmppStream] authenticateWithPassword:[Theme checkNullValue:[Theme getXmppUserCredentials]] error:&error];
    if (error==nil) 
	{
        isXmppActive=YES;
        [self xmppUpdateMode];
}
    else
    {
        isXMPPDisConnected = YES;
    }
    
}


- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    [self goOnline];
    
}


- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    
    return NO;
    
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
//    NSLog(@"JayaPrakash");
//    NSLog(@"Receive success %@",message);
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
    if(recMsgDict!=nil&&[recMsgDict count]>0){
        if([Theme retrieveDriverOnline]){
            if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[recMsgDict objectForKey:@"action"]]] isEqualToString:@"ride_request"]){
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kDriverReceiveNotif
                 object:self userInfo:recMsgDict];
            }
            if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[recMsgDict objectForKey:@"action"]]] isEqualToString:@"receive_cash"]){
                // when user selects cod
                [self moveToPaymentPage:recMsgDict];
            }
            if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[recMsgDict objectForKey:@"action"]]] isEqualToString:@"payment_paid"]){
                //payment_paid user
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kDriverPaymentCompletedNotif
                 object:self userInfo:recMsgDict];
            }
            if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[recMsgDict objectForKey:@"action"]]] isEqualToString:@"ride_cancelled"]){
                //ride cancelled user
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kUserCancelledDrive
                 object:self userInfo:recMsgDict];
            }
            if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[recMsgDict objectForKey:@"action"]]] isEqualToString:@"new_trip"]){
                //ride cancelled user
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kNewTripKey
                 object:self userInfo:recMsgDict];
            }
             if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[recMsgDict objectForKey:@"action"]]] isEqualToString:@"ads"]){
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:kDriverAdvtInfo
                  object:self userInfo:recMsgDict];

             }
        }
    }
}



-(void)xmppUpdateLoc:(CLLocationCoordinate2D)curLocation withReceiver:(NSString *)receiverId withRideId:(NSString *)rideId{

    DDXMLElement * contentElement=[DDXMLElement elementWithName:@"body"];
    
    NSString * jsonStr=[NSString stringWithFormat:@"{\"action\":\"driver_loc\",\"latitude\":\"%@\",\"longitude\":\"%@\",\"ride_id\":\"%@\",\"type\":\"chat\"}",[NSString stringWithFormat:@"%f",curLocation.latitude],[NSString stringWithFormat:@"%f",curLocation.longitude],rideId];
    NSString* encodedUrl = [jsonStr stringByAddingPercentEscapesUsingEncoding:
                            NSUTF8StringEncoding];
    
    [contentElement setStringValue:encodedUrl];
    
    
    
    DDXMLElement * headerElement=[DDXMLElement elementWithName:@"message"];
    [headerElement addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@",receiverId,xMppJabberIdentity]];
    
    [headerElement addChild:contentElement];
    [xmppStream sendElement:headerElement];
    
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
- (void)xmppRoster:(XMPPStream *)sender didReceiveRosterItem:(DDXMLElement *)item {
    
    NSLog(@"Did receive Roster item");
    
    
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    
    
    NSDictionary *userInfo1 = [error userInfo];
    NSString *errorString = [userInfo1 objectForKey:NSLocalizedDescriptionKey];
     NSLog(@"Error..........%@",errorString);
 NSLog(@"Error IP.......%@",xmppStream.hostName);
    
   
    
 if (errorString && ![errorString isEqualToString:@"Network is unreachable"] && [Theme UserIsLogin])
    {
        if(isInternetAvailable==YES){
          [self connect];
        }
    }
}
-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    NSLog(@"Handle timeout issues: %@", sender.description);
}

@end
