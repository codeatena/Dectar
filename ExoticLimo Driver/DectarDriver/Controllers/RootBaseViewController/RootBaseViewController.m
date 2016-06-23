//
//  RootBaseViewController.m
//  VoiceEM
//
//  Created by Casperon Technologies on 6/25/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "RootBaseViewController.h"
#import "HomeViewController.h"


@interface RootBaseViewController ()

@end

@implementation RootBaseViewController
@synthesize custIndicatorView,popupController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self applicationLanguageChangeNotification:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNetworkChange:)
                                                 name:NoNetworkCon
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveReturnNotification:)
                                                 name:kDriverReturnNotif
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveReturnNotificationForSessionOut:)
                                                 name:kDriverSessionOut
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAdvtNotification:)
                                                 name:kDriverAdvtInfo
                                               object:nil];
    
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationLanguageChangeNotification:) name:ApplicationLanguageDidChangeNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(setFeedBackMail:) name: @"feedBackEmail" object: nil];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {
        
    }else{
    }
    
    CGRect screenRect               = CGRectMake(0, 0, self.view.bounds.size.width, 64);
    _internetConnectionIndicator    = [[SMBInternetConnectionIndicator alloc] initWithFrame:screenRect];
    [_internetConnectionIndicator setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin)];
    [self.view addSubview:_internetConnectionIndicator];
    [self.view bringSubviewToFront:_internetConnectionIndicator];
}
- (void)receiveReturnNotification:(NSNotification *) notification
{
    
    if(self.view.window){
        [self stopActivityIndicator];
    }
}
- (void)receiveReturnNotificationForSessionOut:(NSNotification *) notification
{
    
    if(self.view.window){
        [self Logout];
    }
}

- (void) handleNetworkChange:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
   // AppDelegate* appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //
    
  //NSString * projectName=  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    if(remoteHostStatus == NotReachable) {
      [self stopActivityIndicator];
      
       [self.view makeToast:@"No network connection!! Please connect to network"];
    }
    else  {
       
        
    }
}


-(void)applicationLanguageChangeNotification:(NSNotification*)notification
{
    NSLog(@"Either %@ class did not implemented language change notification or it's calling super method",NSStringFromClass([self class]));
}
-(UIViewController*) topMostController
{
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


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
}
-(void)showActivityIndicator:(BOOL)isShow{
    if(isShow==YES){
        if(custIndicatorView==nil){
             custIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStylePulse color:SetThemeColor];
            
        }
        custIndicatorView.center =self.view.center;
        [custIndicatorView startAnimating];
        [self.view addSubview:custIndicatorView];
        [self.view bringSubviewToFront:custIndicatorView];
    }
}
-(void)stopActivityIndicator{
    [custIndicatorView stopAnimating];
    custIndicatorView=nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) setFeedBackMail:(NSNotification *)notice{
    if(self.view.window){
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setSubject:[Theme project_getAppName]];
            NSArray *usersTo = [NSArray arrayWithObject: kAppSupportEmailId];
            [controller setToRecipients:usersTo];
            if (controller) [self presentViewController:controller animated:YES completion:nil];
            
        } else {
            // Handle the error
        }
        
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [self.view makeToast:JJLocalizedString(@"Email Cancelled", nil)];
            
            break;
        case MFMailComposeResultSaved:
            [self.view makeToast:JJLocalizedString(@"Email Saved", nil)];
            
            break;
        case MFMailComposeResultSent:
            [self.view makeToast:JJLocalizedString(@"Email Sent", nil)];
            
            break;
        case MFMailComposeResultFailed:
            [self.view makeToast:JJLocalizedString(@"Email Failed", nil)];
            
            break;
        default:
            [self.view makeToast:JJLocalizedString(@"Email Not Sent", nil)];
            
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(void)Logout{
    
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web LogoutDriver:[self setParametersForLogout]
              success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         //if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
         AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
         [testAppDelegate logoutXmpp];
         [Theme ClearUserDetails];
         LoginViewController * objLoginVc=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialVCSID"];
         UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginVc];
         testAppDelegate.window.rootViewController = navigationController;
         self.view.userInteractionEnabled=YES;
         //         }else{
         //
         //             [self.view makeToast:kErrorMessage];
         //         }
     }
              failure:^(NSError *error)
     {
         
         [self stopActivityIndicator];
         AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
          [testAppDelegate logoutXmpp];
         [Theme ClearUserDetails];
         
         LoginViewController * objLoginVc=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialVCSID"];
         UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginVc];
         testAppDelegate.window.rootViewController = navigationController;
         self.view.userInteractionEnabled=YES;
         [self.view makeToast:kErrorMessage];
         
     }];
}
-(NSDictionary *)setParametersForLogout{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"device":@"IOS"
                                  };
    return dictForuser;
}

- (void)receiveAdvtNotification:(NSNotification *) notification
{
    
    if(self.view.window){
        
        NSDictionary * dict=notification.userInfo;
        if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[dict objectForKey:@"action"]]] isEqualToString:@"ads"]){
            
            
            NSString * titileStr=[Theme checkNullValue:[dict objectForKey:@"key1"]];
            NSString * messageStr=[Theme checkNullValue:[dict objectForKey:@"key2"]];
            NSString * imageStrStr=[Theme checkNullValue:[dict objectForKey:@"key3"]];
            
            
            
            NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:titileStr attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15], NSParagraphStyleAttributeName : paragraphStyle}];
            
            UIImageView * advtImage;
            if(imageStrStr.length>0){
                advtImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 250,250)];
                [advtImage sd_setImageWithURL:[NSURL URLWithString:imageStrStr] placeholderImage:[UIImage imageNamed:@"PlaceHolderImg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
            }
            
            NSAttributedString *lineTwo = [[NSAttributedString alloc] initWithString:messageStr attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:13], NSForegroundColorAttributeName : [UIColor darkGrayColor], NSParagraphStyleAttributeName : paragraphStyle}];
            CNPPopupButton * button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 45)];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.numberOfLines = 0;
            titleLabel.attributedText = title;
            
            
            [button setTitle:@"OK" forState:UIControlStateNormal];
            button.backgroundColor =SetThemeColor;
            button.tintColor=[UIColor whiteColor];
            button.layer.cornerRadius = 4;
            button.selectionHandler = ^(CNPPopupButton *button){
                [self.popupController dismissPopupControllerAnimated:YES];
            };
            
            UILabel *lineTwoLabel = [[UILabel alloc] init];
            lineTwoLabel.numberOfLines = 0;
            lineTwoLabel.attributedText = lineTwo;
            
            if(imageStrStr.length>0){
                self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel,advtImage,lineTwoLabel, button]];
                
            }else{
                self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel, lineTwoLabel, button]];
                
            }
            
            
            self.popupController.theme = [CNPPopupTheme defaultTheme];
            self.popupController.theme.popupStyle = CNPPopupStyleCentered;
            self.popupController.delegate = self;
            [self.popupController presentPopupControllerAnimated:YES];
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
