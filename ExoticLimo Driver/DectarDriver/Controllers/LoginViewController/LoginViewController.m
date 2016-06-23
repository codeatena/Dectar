//
//  LoginViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/21/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<ITRAirSideMenuDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>

@end
@class RootBaseViewController;
@implementation LoginViewController
@synthesize loginScrollView,userNameTxtField,passwordTextfield,signInBtn,custIndicatorView,forgotPasswordbtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFontAndColor];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveReturnNotification:)
                                                 name:kDriverReturnNotif
                                               object:nil];
    
}
- (void)receiveReturnNotification:(NSNotification *) notification
{
    
    if(self.view.window){
        [self stopActivityIndicator];
        signInBtn.userInteractionEnabled=YES;
    }
}
-(void)setFontAndColor{
    @try {
        _headerLbl.text=JJLocalizedString(@"Sign_In", nil);
        userNameTxtField.placeholder=JJLocalizedString(@"Email", nil);
        passwordTextfield.placeholder=JJLocalizedString(@"Password", nil);
        [signInBtn setTitle:JJLocalizedString(@"SIGN_IN", nil) forState:UIControlStateNormal];
        
        
        NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:JJLocalizedString(@"Forgot_password?", nil)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, string.length)];//TextColor
        [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(0, string.length)];
        [string addAttribute:NSUnderlineColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, string.length)];//TextColor
        [forgotPasswordbtn setAttributedTitle:string forState:UIControlStateNormal];
        
        
        
        
        _headerLbl=[Theme setHeaderFontForLabel:_headerLbl];
        signInBtn=[Theme setBoldFontForButton:signInBtn];
        
        //    signInBtn.layer.cornerRadius=2;
        //    signInBtn.layer.masksToBounds=YES;
        userNameTxtField=[Theme setNormalFontForTextfield:userNameTxtField];
        passwordTextfield=[Theme setNormalFontForTextfield:passwordTextfield];
        userNameTxtField=[self leftPadding:userNameTxtField withImageName:@"EmailMessage"];
        passwordTextfield=[self leftPadding:passwordTextfield withImageName:@"PasswordLock"];
    }
    @catch (NSException *exception) {
        
    }
   
    
}
-(UITextField *)leftPadding:(UITextField *)txtField withImageName:(NSString *)imgName{
    UIView *   arrow = [[UILabel alloc] init];
    arrow.frame = CGRectMake(0, 0,50, 50);
    UIImageView *   Img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    Img.frame = CGRectMake(10, 10,30, 30);
    [arrow addSubview:Img];
    arrow.contentMode = UIViewContentModeScaleToFill;
    txtField.leftView = arrow;
    txtField.leftViewMode = UITextFieldViewModeAlways;
    return txtField;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField isEqual:userNameTxtField]){
        [loginScrollView setContentOffset:CGPointMake(0.0, 0) animated:YES];
    }else{
        [loginScrollView setContentOffset:CGPointMake(0.0,textField.frame.origin.y-100) animated:YES];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [loginScrollView setContentOffset:CGPointMake(0.0, 0) animated:YES];
    return YES;
}
- (IBAction)didClickForgotPasswordBtn:(id)sender {
    ForgotPasswordCabViewController * objForgotVc=[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordVCSID"];
   
    [self.navigationController pushViewController:objForgotVc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)didClickUserCredentialBtns:(id)sender {
}
- (IBAction)didClickBackBtn:(id)sender {
   [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)didClickSigninBtn:(id)sender {
    if([self validateTextField]){
        
        signInBtn.userInteractionEnabled=NO;
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [self showActivityIndicator:YES];
        [web PostLoginUrl:[self setParametersForLogin]
                  success:^(NSMutableDictionary *responseDictionary)
         {
             [self stopActivityIndicator];
             if([[Theme checkNullValue:[responseDictionary objectForKey:@"status"]] isEqualToString:@"1"]){
                 DriverInfoRecords * objDriverInfoRecs=[[DriverInfoRecords alloc]init];
                 objDriverInfoRecs.driverId=[Theme checkNullValue:responseDictionary[@"driver_id"]];
                 objDriverInfoRecs.driverName=[Theme checkNullValue:responseDictionary[@"driver_name"]];
                 objDriverInfoRecs.driverImage=[Theme checkNullValue:responseDictionary[@"driver_image"]];
                 objDriverInfoRecs.driverEmail=[Theme checkNullValue:responseDictionary[@"email"]];
                 objDriverInfoRecs.driverVehicModel=[Theme checkNullValue:responseDictionary[@"vehicle_model"]];
                 objDriverInfoRecs.driverVehicNumber=[Theme checkNullValue:responseDictionary[@"vehicle_number"]];
                 objDriverInfoRecs.driverKey=[Theme checkNullValue:responseDictionary[@"key"]];
                 [Theme saveUserDetails:objDriverInfoRecs];
                 [Theme saveXmppUserCredentials:[Theme checkNullValue:responseDictionary[@"sec_key"]]];
                 if([Theme UserIsLogin]){
                     [self moveToStarterVC];
                      signInBtn.userInteractionEnabled=YES;
                 }
             }else{
                 UIAlertView * alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Oops", nil) message:[Theme checkNullValue:[responseDictionary objectForKey:@"response"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alert show];
                  signInBtn.userInteractionEnabled=YES;
             }
         }
                  failure:^(NSError *error)
         {
             
             [self stopActivityIndicator];
              signInBtn.userInteractionEnabled=YES;
         }];
    }
}

-(BOOL)validateTextField{
    BOOL validate=YES;
    if(userNameTxtField.text.length==0){
        [self showAlert:JJLocalizedString(@"Email_cannot_be_empty", nil)];
        validate=NO;
        return validate;
    }else if (passwordTextfield.text.length==0){
        [self showAlert:JJLocalizedString(@"Password_cannot_be_empty", nil)];
        validate=NO;
        return validate;
    }
    return validate;
}
-(void)showAlert:(NSString *)alertMsg{
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Oops", nil) message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(NSDictionary *)setParametersForLogin{

    NSDictionary *dictForuser = @{
                                  @"email":userNameTxtField.text,
                                  @"password":passwordTextfield.text,
                                  @"deviceToken":[Theme getDeviceToken],
                                  @"gcm_id":@""
                                  };
    return dictForuser;
}
-(void)moveToStarterVC{
    AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
    [testAppDelegate setInitialViewController];
    [testAppDelegate connectToXmpp];
    
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
@end
