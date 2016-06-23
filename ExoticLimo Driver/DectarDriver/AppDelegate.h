//
//  AppDelegate.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/21/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "Theme.h"
#import "StarterViewController.h"
#import "InitialViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "ITRAirSideMenu.h"
#import "ITRLeftMenuController.h"
#import "UIView+Toast.h"
#import "XMPP.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMLReader.h"
#import <AVFoundation/AVFoundation.h>

@import HockeySDK;


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BOOL isXMPPDisConnected;
    AVAudioPlayer * audioPlayer;
}
@property ITRAirSideMenu *itrAirSideMenu;
@property (strong, nonatomic) UIWindow *window;
@property (assign , nonatomic) BOOL isXmppActive;
@property (assign , nonatomic) BOOL isInternetAvailable;
-(BOOL) isInternetAvailableFor;
-(void)setInitialViewController;
+ (BOOL) checkLocationServicesTurnedOn;
+(BOOL) checkApplicationHasLocationServicesPermission;


///////////// xmpp
@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property(nonatomic,strong)NSTimer *connectionTimer;


-(void)connectToXmpp;
- (BOOL)connect;
- (void)disconnect;
-(void)logoutXmpp;
-(void)xmppState;
-(void)xmppUpdateLoc:(CLLocationCoordinate2D)curLocation withReceiver:(NSString *)receiverId withRideId:(NSString *)rideId;



@end

