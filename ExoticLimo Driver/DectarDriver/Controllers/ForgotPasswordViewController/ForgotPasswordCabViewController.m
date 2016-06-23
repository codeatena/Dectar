//
//  ForgotPasswordCabViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 12/21/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

#import "ForgotPasswordCabViewController.h"


@interface ForgotPasswordCabViewController ()

@end

@implementation ForgotPasswordCabViewController
@synthesize forgotScrollView,emailTxtField;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_headerlbl setText:JJLocalizedString(@"Forgot_Password", nil)];
    [_RequestBtn setTitle:JJLocalizedString(@"Request_Password", nil) forState:UIControlStateNormal];
    [_forgetheader setText:JJLocalizedString(@"Forgot_your_password", nil)];
    [_Hint_emaillbl setText:JJLocalizedString(@"Enter_your_Email_below_to_receive"  , nil)];
    [emailTxtField setPlaceholder:JJLocalizedString(@"Email", nil)];
    
    // Do any additional setup after loading the view.
}
- (IBAction)didClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(IS_IPHONE_4_OR_LESS){
        [forgotScrollView setContentOffset:CGPointMake(0.0,textField.frame.origin.y-100) animated:YES];
        
    }else{
        [forgotScrollView setContentOffset:CGPointMake(0.0, 0) animated:YES];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
   [forgotScrollView setContentOffset:CGPointMake(0.0, 0) animated:YES];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location == 0 && [string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}
- (IBAction)didClickRequestBtn:(id)sender {
    if([self validateTxtFields]){
        [self.view endEditing:YES];

        [self showActivityIndicator:YES];
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [web ForgotPassword:[self setParametersForForgotPassword]
                     success:^(NSMutableDictionary *responseDictionary)
         {
             self.view.userInteractionEnabled=YES;
             [self stopActivityIndicator];
             if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
                
                 [self.view makeToast:[Theme checkNullValue:[responseDictionary objectForKey:@"response"]]];
             }else{
                 self.view.userInteractionEnabled=YES;
                 [self.view makeToast:kErrorMessage];
             }
         }
                     failure:^(NSError *error)
         {
             self.view.userInteractionEnabled=YES;
             [self stopActivityIndicator];
             [self.view makeToast:kErrorMessage];
             
         }];
    }

}

-(NSDictionary *)setParametersForForgotPassword{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"email":emailTxtField.text,

                                  };
    return dictForuser;
}
-(BOOL)validateTxtFields{
    if (![Theme NSStringIsValidEmail:emailTxtField.text]){
        [self showErrorMessage:@"Please_enter_valid_Email"];
        return NO;
    }
    
    return YES;
}
-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:@"Oops !!!" message:JJLocalizedString(str, nil)];
    [notice show];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

@end
