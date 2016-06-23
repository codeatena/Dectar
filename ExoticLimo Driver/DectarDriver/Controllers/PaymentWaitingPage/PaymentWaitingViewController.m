//
//  PaymentWaitingViewController.m
//  DectarDriver
//
//  Created by Aravind Natarajan on 17/02/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import "PaymentWaitingViewController.h"

@interface PaymentWaitingViewController ()

@end

@implementation PaymentWaitingViewController
@synthesize custIndicatorView,rideIdPay,statusBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showActivityIndicator:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kDriverCashPaymentNotif
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kDriverPaymentCompletedNotif
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kUserCancelledDrive
                                               object:nil];
    statusBtn.layer.borderWidth=.75;
    statusBtn.layer.borderColor=SetThemeColor.CGColor;
    statusBtn.layer.cornerRadius=5;
    statusBtn.layer.masksToBounds=YES;
    [_waitLbl setText:JJLocalizedString(@"Please_wait", nil)];
    [_messageLbl setText:JJLocalizedString(@"This_process_may", nil)];
    [_hint_lbl setText:JJLocalizedString(@"Your_payment_request_is", nil)];
    [statusBtn setTitle:JJLocalizedString(@"Check_Status", nil) forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}
- (void)receiveNotification:(NSNotification *) notification
{
    if(self.view.window){
    NSDictionary * dict=notification.userInfo;
    if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[dict objectForKey:@"action"]]] isEqualToString:@"receive_cash"]){
        [self stopActivityIndicator];
        ReceiveCashViewController * objReceiveCashVC=[self.storyboard  instantiateViewControllerWithIdentifier:@"ReceiveCashVCSID"];
        [objReceiveCashVC setRideId:rideIdPay];
        
        NSString * str=[NSString stringWithFormat:@"%@ %@",[Theme checkNullValue:[Theme findCurrencySymbolByCode:[dict objectForKey:@"key4"]]],[Theme checkNullValue:[dict objectForKey:@"key3"]]];
        [objReceiveCashVC setFareAmt:str];
        [self.navigationController pushViewController:objReceiveCashVC animated:YES];
    }
    if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[dict objectForKey:@"action"]]] isEqualToString:@"payment_paid"]){
        [self stopActivityIndicator];
        [self.view makeToast:@"Payment_Received"];
        [self performSelector:@selector(moveToHome) withObject:self afterDelay:0];
    }
    if(self.view.window){
        if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[dict objectForKey:@"action"]]] isEqualToString:@"ride_cancelled"]){
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Sorry !!" message:JJLocalizedString(@"Rider_Cancelled_the_ride", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self moveBack];
}
-(void)moveBack{
    if(self.view.window){
        BOOL isHome=NO;
        BOOL isRootSkip=NO;
        for (UIViewController *controller1 in self.navigationController.viewControllers) {
            
            if ([controller1 isKindOfClass:[HomeViewController class]]) {
                
                [self.navigationController popToViewController:controller1
                                                      animated:YES];
                isHome=YES;
                isRootSkip=YES;
                
                break;
            }
        }
        if(isHome==NO){
            for (UIViewController *controller1 in self.navigationController.viewControllers) {
                
                if ([controller1 isKindOfClass:[StarterViewController class]]) {
                    
                    [self.navigationController popToViewController:controller1
                                                          animated:YES];
                    isRootSkip=YES;
                    break;
                }
            }
        }
        if(isRootSkip==NO){
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }
}
-(void)moveToHome{
    RatingsViewController * objRatingsVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingsVCSID"];
    [objRatingsVc setRideid:rideIdPay];
    [self.navigationController pushViewController:objRatingsVc animated:YES];
    //    for (UIViewController *controller1 in self.navigationController.viewControllers) {
    //
    //        if ([controller1 isKindOfClass:[HomeViewController class]]) {
    //
    //            [self.navigationController popToViewController:controller1
    //                                                  animated:YES];
    //            break;
    //        }
    //    }
}
-(void)showActivityIndicator:(BOOL)isShow{
    if(isShow==YES){
        if(custIndicatorView==nil){
            custIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStylePulse color:SetThemeColor];
            
        }
        custIndicatorView.center =self.view.center;
        custIndicatorView.spinnerSize=100;
        CGRect fram=custIndicatorView.frame;
        fram.origin.x=(self.view.frame.size.width/2)-(custIndicatorView.spinnerSize/2);
        fram.origin.y=(self.view.frame.size.height/2)-(custIndicatorView.spinnerSize/2);
        custIndicatorView.frame=fram;
        [custIndicatorView startAnimating];
        [self.view addSubview:custIndicatorView];
        [self.view bringSubviewToFront:custIndicatorView];
    }
}
-(void)stopActivityIndicator{
    [custIndicatorView stopAnimating];
    custIndicatorView=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickCheckStatusBtn:(id)sender {
    [self performSelector:@selector(enableStatusButton) withObject:nil afterDelay:10.0];
    statusBtn.userInteractionEnabled=NO;
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web CheckPaymentStatus:[self setParametersToCheckStatus]
                           success:^(NSMutableDictionary *responseDictionary)
     {
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             
             NSDictionary * reasonDict = responseDictionary[@"response"];
             
                  NSString * tripStr =[Theme checkNullValue:[reasonDict objectForKey:@"trip_waiting"]];
                   NSString * rateStr =[Theme checkNullValue:[reasonDict objectForKey:@"ratting_pending"]];
                  if([tripStr isEqualToString:@"No"]){
                      if([rateStr isEqualToString:@"Yes"]){
                          if(self.view.window){
                          RatingsViewController * objRatingsVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingsVCSID"];
                          [objRatingsVc setRideid:rideIdPay];
                          [self.navigationController pushViewController:objRatingsVc animated:YES];
                          }
                      }else{
                          if(self.view.window){

                          [self moveBack];
                          }
                      }
                      
                  
                  }else{
                       [self.view makeToast:@"Processing_payment_Please wait"];
                  }
             
         }else{
             statusBtn.userInteractionEnabled=YES;
             self.view.userInteractionEnabled=YES;
             [self.view makeToast:[Theme checkNullValue:[responseDictionary objectForKey:@"response"]]];
         }
         
     }
                           failure:^(NSError *error)
     
     {
         statusBtn.userInteractionEnabled=YES;
         
     }];
}
-(NSDictionary *)setParametersToCheckStatus{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"ride_id":rideIdPay
                                  };
    return dictForuser;
}
-(void)enableStatusButton{
    statusBtn.userInteractionEnabled=YES;
}
@end
