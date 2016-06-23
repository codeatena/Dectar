//
//  RootBaseVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 10/9/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "RootBaseVC.h"
#import "Themes.h"
#import "AdvertsVC.h"
#import "AdvertsRecord.h"
#import "RatingVC.h"
#import "FareVC.h"
#import "NewViewController.h"
#import "NewTrackVC.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "REFrostedViewController.h"

@interface RootBaseVC ()<MFMailComposeViewControllerDelegate>
{
    UIGestureRecognizer * Tapped;
}

@end

@implementation RootBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applicationLanguageChangeNotification:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationLanguageChangeNotification:) name:ApplicationLanguageDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OpenAds:) name:@"Advertisment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"waitingfor_payment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewVc:) name:@"payment_paid" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cabCame:) name:@"cab_arrived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StartRide:) name:@"Ride_start" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RideOver:) name:@"ride_completed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareETA:) name:@"ShareETA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(setFeedBackMail:) name: @"feedBackEmail" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(NoNetwork) name: @"NoNetworkMsgPush" object: nil];
    // Do any additional setup after loading the view.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ApplicationLanguageDidChangeNotification object:nil];
    
}

-(void)NoNetwork{
    [Themes StopView:self.view];
    [self.view makeToast:@"No network connection"];
}

-(void)viewWillAppear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)shareETA:(NSNotification *)notification
{
   // if ([notification.object isKindOfClass:[FareRecord class]])
    //{
    if (self.view.window)
    {

        NewTrackVC *objNewTrackVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
        FareRecord*Rec=(FareRecord*)notification.object;
        [objNewTrackVC setObjrecFar:Rec];
        [self.navigationController pushViewController:objNewTrackVC animated:YES];
    
    }
    //}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) setFeedBackMail:(NSNotification *)notice{
    if(self.view.window){
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setSubject:[Themes getAppName]];
            NSArray *usersTo = [NSArray arrayWithObject: @"support@djasirintechnologies.com" ];//@"info@zoplay.com"
            [controller setToRecipients:usersTo];
            if (controller) [self presentViewController:controller animated:YES completion:nil];
            
        }
        else {
            // Handle the error
        }
        
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)OpenAds:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[AdvertsRecord class]])
    {
        if (self.view.window)
        {
            AdvertsVC * Adverts = [self.storyboard instantiateViewControllerWithIdentifier:@"AdvertsVCID"];
            AdvertsRecord*Rec=(AdvertsRecord*)notification.object;
           
            [Adverts setAds_ObjRec:Rec];
            
            if ([[UIDevice currentDevice].systemVersion integerValue] >= 8)
            {
                //For iOS 8
                Adverts.providesPresentationContextTransitionStyle = YES;
                Adverts.definesPresentationContext = YES;
                Adverts.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            else
            {
                //For iOS 7
                Adverts.modalPresentationStyle = UIModalPresentationCurrentContext;
            }
            [self presentViewController:Adverts animated:NO completion:nil];

        }
    }
}

- (void) reviewVc:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[FareRecord class]])
    {
        if(self.view.window){
            RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
            FareRecord*Rec=(FareRecord*)notification.object;
            [objLoginVC setRideID_Rating :Rec.ride_id];
            [self.navigationController pushViewController:objLoginVC animated:YES];

        }
        
    }
}

- (void) cabCame:(NSNotification *)notification
{
    if (![self isKindOfClass:[NewTrackVC class]])
    {
        if(self.view.window){
        FareRecord*Rec=(FareRecord*)notification.object;
       
        [self Banner:Rec];
            
        }
        
    }
}
-(void)RideOver:(NSNotification*)notification
{
    if (![self isKindOfClass:[NewTrackVC class]])
    {
        if(self.view.window){
            FareRecord*Rec=(FareRecord*)notification.object;
           
            [self Banner:Rec];
            
        }
        
    }
}
- (void) StartRide:(NSNotification *)notification
{
    if (![self isKindOfClass:[NewTrackVC class]])
    {
        if(self.view.window){
            FareRecord*Rec=(FareRecord*)notification.object;
            
            [self Banner:Rec];
            
        }
        
    }
}
- (void) notification:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[FareRecord class]])
    {
        if (self.view.window)
        {
            //FareVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"FareVCID"];  //NewFareVCID
            NewViewController * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"NewFareVCID"];
            FareRecord*Rec=(FareRecord*)notification.object;
            
            [addfavour setObjRc:Rec];
            [self.navigationController pushViewController:addfavour animated:YES];

        }
        
    }
    
}
-(void)Banner:(FareRecord*)Rec

{
    if(![self.view.window isKindOfClass:[NewTrackVC class]]){
        [HDNotificationView showNotificationViewWithImage:nil
                                                    title:[Themes getAppName]
                                                  message:Rec.Message
                                               isAutoHide:YES
                                                  onTouch:^{
                    
                                                              /// On touch handle. You can hide notification view or do something
                                                              NewTrackVC *objNewTrackVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
                                                              [objNewTrackVC setObjrecFar:Rec];
                                                              [self.navigationController pushViewController:objNewTrackVC animated:YES];
                                                              [HDNotificationView hideNotificationViewOnComplete:nil];
                                                      
                                                  }];
        
    }
   
    
    
    
  
    
}
- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

-(void)Toast:(NSString *)msg
{
    [self.view makeToast:JJLocalizedString(msg, nil)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)applicationLanguageChangeNotification:(NSNotification*)notification
{
    NSLog(@"Either %@ class did not implemented language change notification or it's calling super method",NSStringFromClass([self class]));
}
@end
