//
//  CashOTPViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/2/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "CashOTPViewController.h"

@interface CashOTPViewController ()

@end

@implementation CashOTPViewController
@synthesize otpHeaderLbl,OTPTextField,otpTextLbl,requestBtn,custIndicatorView,rideId,rateAmount,OTPStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFont];
    [self requestForOtp];
    // Do any additional setup after loading the view.
}
-(void)setFont{
    requestBtn.hidden=YES;
    otpHeaderLbl=[Theme setHeaderFontForLabel:otpHeaderLbl];
    otpTextLbl=[Theme setHeaderFontForLabel:otpTextLbl];
    OTPTextField=[Theme setLargeBoldFontForTextField:OTPTextField];
    requestBtn=[Theme setBoldFontForButton:requestBtn];
    
    [otpHeaderLbl setText:JJLocalizedString(@"OTP", nil)];
    [otpTextLbl setText:JJLocalizedString(@"Please_enter_the_OTP", nil)];
    [OTPTextField setPlaceholder:JJLocalizedString(@"Enter_OTP", nil)];
    [requestBtn setTitle:JJLocalizedString(@"Request", nil) forState:UIControlStateNormal];
    
    //requestBtn.layer.cornerRadius=2;
   // requestBtn.layer.masksToBounds=YES;
}
-(void)requestForOtp{
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getOTP:[self setParametersForOtp]
                     success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             requestBtn.hidden=NO;
             NSString * resdict=[Theme checkNullValue:[responseDictionary objectForKey:@"otp_status"]];
             [self.view makeToast:[Theme checkNullValue:[responseDictionary objectForKey:@"response"]]];
             NSString * currency=[Theme checkNullValue:[Theme findCurrencySymbolByCode:[responseDictionary objectForKey:@"currency"]]];
             rateAmount=[Theme checkNullValue:[NSString stringWithFormat:@"%@ %.02f",currency,[[responseDictionary objectForKey:@"amount"] floatValue]]];
             OTPStr=[Theme checkNullValue:[responseDictionary objectForKey:@"otp"]];
             if([resdict isEqualToString:@"development"]){
                 OTPTextField.text=[Theme checkNullValue:[responseDictionary objectForKey:@"otp"]];
             }
         }else{
             
             [self.view makeToast:kErrorMessage];
         }
     }
                     failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [self.view makeToast:kErrorMessage];
         
     }];
}
-(NSDictionary *)setParametersForOtp{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"ride_id":rideId
                                  };
    return dictForuser;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didClickRequestBtn:(id)sender {
    if(OTPTextField.text.length==0||![OTPTextField.text isEqualToString:OTPStr]){
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Alert !!" message:JJLocalizedString(@"Please_enter_valid_OTP", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        ReceiveCashViewController * objReceiveCashVC=[self.storyboard  instantiateViewControllerWithIdentifier:@"ReceiveCashVCSID"];
        [objReceiveCashVC setRideId:rideId];
        [objReceiveCashVC setFareAmt:rateAmount];
        [self.navigationController pushViewController:objReceiveCashVC animated:YES];
    }
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)didClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
}
@end
