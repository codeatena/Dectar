//
//  AppDelegate.h
//  Dectar
//
//  Created by Suresh J on 08/07/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Stripe/Stripe.h>
#import "EMNotificationPopup.h"
#import "XMPP.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPPRosterCoreDataStorage.h"
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,EMNotificationPopupDelegate>
{
    NetworkStatus wifiStatus,wwanStatus;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) EMNotificationPopup *notificationPopup;
@property (assign, nonatomic) BOOL IsShowing;
@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property(nonatomic,retain)  Reachability *wifiReachability,*wwanReachability;
@property (nonatomic)BOOL isNetworkAvailable;
@property (nonatomic,retain)NSString *currentView;
@property(nonatomic,strong)NSTimer *connectionTimer;


- (BOOL)connect;
- (void)disconnect;

-(void)setInitialViewController;
-(void)Logoutroot;
-(void)LogIn;
-(void)AdVerts;
-(void)connectToXmpp;
  
@end

