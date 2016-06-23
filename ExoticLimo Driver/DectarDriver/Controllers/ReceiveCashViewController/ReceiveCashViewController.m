//
//  ReceiveCashViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/2/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "ReceiveCashViewController.h"

@interface ReceiveCashViewController ()

@end

@implementation ReceiveCashViewController
@synthesize fareAmt,receiveCashHeaderLbl,fareLbl,receiveBtn,custIndicatorView,RideId,backBtn,textLbl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFont];
    fareLbl.text=fareAmt;
    // Do any additional setup after loading the view.
}
-(void)setFont{
    receiveCashHeaderLbl=[Theme setHeaderFontForLabel:receiveCashHeaderLbl];
    fareLbl=[Theme setLargeBoldFontForLabel:fareLbl];
    textLbl=[Theme setHeaderFontForLabel:textLbl];
    receiveBtn=[Theme setBoldFontForButton:receiveBtn];
    
    [receiveCashHeaderLbl setText:JJLocalizedString(@"Receive_Cash", nil)];
    [receiveBtn setTitle:JJLocalizedString(@"Received", nil) forState:UIControlStateNormal];
    [textLbl setText:JJLocalizedString(@"Please_collect_the_below", nil)];
    
    
   // receiveBtn.layer.cornerRadius=2;
    //receiveBtn.layer.masksToBounds=YES;
}
-(void)viewDidAppear:(BOOL)animated{
    if([[self backViewController]isKindOfClass:[PaymentWaitingViewController class]]){
        backBtn.hidden=YES;
    }else{
         backBtn.hidden=NO;
    }
    
}
- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}

- (IBAction)didClickReceiveBtn:(id)sender {
    backBtn.userInteractionEnabled=NO;
    receiveBtn.userInteractionEnabled=NO;
    [self.view makeToast:@"Please_wait_until_transaction"];
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web receiveCash:[self setParametersForOtp]
        success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             [self performSelector:@selector(moveToHomeVc) withObject:self afterDelay:1];
             [self.view makeToast:@"Payment_Received"];
         }else{
             backBtn.userInteractionEnabled=YES;
             receiveBtn.userInteractionEnabled=YES;

             [self.view makeToast:kErrorMessage];
         }
     }
        failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         backBtn.userInteractionEnabled=YES;
         receiveBtn.userInteractionEnabled=YES;
         [self.view makeToast:kErrorMessage];
         
     }];
}
-(void)moveToHomeVc{
    RatingsViewController * objRatingsVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingsVCSID"];
    [objRatingsVc setRideid:RideId];
    [self.navigationController pushViewController:objRatingsVc animated:YES];
    
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        
//        if ([controller isKindOfClass:[HomeViewController class]]) {
//            
//            [self.navigationController popToViewController:controller
//                                                  animated:YES];
//            break;
//        }
//    }
}
-(NSDictionary *)setParametersForOtp{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"ride_id":RideId,
                                  @"amount":fareAmt
                                  };
    return dictForuser;
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

- (IBAction)didClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
