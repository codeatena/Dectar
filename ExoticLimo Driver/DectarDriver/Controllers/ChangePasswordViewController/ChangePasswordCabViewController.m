//
//  ChangePasswordCabViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 12/21/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

#import "ChangePasswordCabViewController.h"

@interface ChangePasswordCabViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passTxt;

@end

@implementation ChangePasswordCabViewController
@synthesize oldPassTxtField,retypePassTxtField,changePasswordScrollView,passTxt;
+ (instancetype) controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordVCSID"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_headerlbl setText:JJLocalizedString(@"Change_Password", nil)];
    [_changebtn setTitle:JJLocalizedString(@"Change_Password", nil) forState:UIControlStateNormal];
    [oldPassTxtField setPlaceholder:JJLocalizedString(@"Old_Password", nil)];
    [retypePassTxtField setPlaceholder:JJLocalizedString(@"ReType_Password", nil)];
    [passTxt setPlaceholder:JJLocalizedString(@"New_Password", nil)];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
}
- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==oldPassTxtField){
        [changePasswordScrollView setContentOffset:CGPointMake(0.0, 0) animated:YES];
        
    }else{
        [changePasswordScrollView setContentOffset:CGPointMake(0.0,textField.frame.origin.y-100) animated:YES];
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [changePasswordScrollView setContentOffset:CGPointMake(0.0, 0) animated:YES];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location == 0 && [string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

- (IBAction)didClickChangePasswordBtn:(id)sender {
    if([self validateTxtFields]){
        [self.view endEditing:YES];
        
        [self showActivityIndicator:YES];
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [web ChangePassword:[self setParametersForForgotPassword]
                    success:^(NSMutableDictionary *responseDictionary)
         {
             self.view.userInteractionEnabled=YES;
             [self stopActivityIndicator];
             if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
                 
                 [self.view makeToast:[Theme checkNullValue:[responseDictionary objectForKey:@"response"]]];
             }else{
                 self.view.userInteractionEnabled=YES;
                [self.view makeToast:[Theme checkNullValue:[responseDictionary objectForKey:@"response"]]];
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
                                  @"driver_id":driverId,
                                  @"password":oldPassTxtField.text,
                                  @"new_password":passTxt.text,
                                  };
    return dictForuser;
}
-(BOOL)validateTxtFields{
    if(oldPassTxtField.text.length==0){
        [self showErrorMessage:@"Old_Password_cannot_be_empty"];
        return NO;
    }
    if(passTxt.text.length==0){
        [self showErrorMessage:@"New_Password_cannot_be_empty"];
        return NO;
    }
    if(![passTxt.text isEqualToString:retypePassTxtField.text]){
        [self showErrorMessage:@"ReType_password_mismatches"];
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
