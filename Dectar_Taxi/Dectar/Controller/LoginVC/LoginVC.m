//
//  LoginVC.m
//  Dectar
//
//  Created by Suresh J on 08/07/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "LoginVC.h"
#import "UrlHandler.h"
#import "LoginMainVC.h"
#import "Themes.h"
#import "DGActivityIndicatorView.h"
#import "ForgetPSDVC.h"
#import "RegisterVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LanguageHandler.h"
#import "JTImageButton.h"

@interface LoginVC ()<UITextFieldDelegate>
{
    DGActivityIndicatorView *activityIndicatorView;
    NSString * country;
}

@property (strong, nonatomic) IBOutlet UITextField *Email_Field;
@property (strong, nonatomic) IBOutlet UITextField *Password_field;
@property (strong, nonatomic) IBOutlet UIButton *Sign_btn;
@property (strong , nonatomic) NSString * userIDString;
@property (strong , nonatomic) NSString * CategoryString;
@property (strong , nonatomic) NSString * UserImage;
@property (strong, nonatomic) IBOutlet UIButton *Facebook;
@property(strong, nonatomic) IBOutlet UILabel * terms;
@property (strong, nonatomic) IBOutlet UIButton *ForgetPassowrd_btn;
@property (strong, nonatomic) IBOutlet UIButton *Signup_here_btn;
@property(strong, nonatomic) IBOutlet UILabel * Hint_signUp;
@property(strong, nonatomic) IBOutlet UILabel * Heading_Lbl;

@property (nonatomic ,assign) IBOutlet JTImageButton *selectcarBtn;

//@property (strong ,nonatomic)CLLocationManager * currentLocation;

@end

@implementation LoginVC
@synthesize Email_Field,Password_field,UserImage,userIDString,CategoryString,loginrecord,Sign_btn,Facebook;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    Email_Field.delegate=self;
    Password_field.delegate=self;
    
   /** currentLocation = [[CLLocationManager alloc] init];
    //    currentLocation.distanceFilter = kCLDistanceFilterNone;
    //    currentLocation.desiredAccuracy = kCLLocationAccuracyBest; // 100m
    [currentLocation startUpdatingLocation];
    [currentLocation requestWhenInUseAuthorization];
    [currentLocation requestAlwaysAuthorization];*/
    
    UITapGestureRecognizer * estimate=[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(Estimate)];
    estimate.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:estimate];
    //[Themes statusbarColor:self.view];

    // Do any additional setup after loading the view.
    
    [_selectcarBtn createTitle:@"SELECT YOUR CAR" withIcon:[UIImage imageNamed:@"ok_icon"]
                         font:[UIFont fontWithName:@"RobotoCondensed-Bold" size:15.0f]
                   iconHeight:26
                  iconOffsetY:-3];
    [self configCustomButton1:_selectcarBtn];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    Email_Field.leftView = paddingView;
    Email_Field.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    Password_field.leftView = paddingView1;
    Password_field.leftViewMode = UITextFieldViewModeAlways;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)applicationLanguageChangeNotification:(NSNotification*)notification{
    
    [Sign_btn setTitle:JJLocalizedString(@"SIGN_IN", nil) forState:UIControlStateNormal];
    NSString * bycontinue=JJLocalizedString(@"By_Continuing_I_agree", nil) ;
    NSString * Agreement=JJLocalizedString(@"User_agreement_and_Terms_of_services", nil);
    [_terms setText:[NSString stringWithFormat:@"%@ %@'s %@",bycontinue,[Themes getAppName],Agreement]];
    [_Heading_Lbl setText:JJLocalizedString(@"LOGIN", nil)];
    [Email_Field setPlaceholder:JJLocalizedString(@"EMAIL", nil)];
    [Password_field setPlaceholder:JJLocalizedString(@"PASSWORD", nil)];
    [_ForgetPassowrd_btn setTitle:JJLocalizedString(@"Forget_password", nil) forState:UIControlStateNormal];
    [_Signup_here_btn setTitle:JJLocalizedString(@"SignUp_Here", nil) forState:UIControlStateNormal];
    [_Hint_signUp setText:JJLocalizedString(@"Not_a_membet_yet", nil)];


}

- (void)configCustomButton1:(JTImageButton *)btn
{
    btn.titleColor = [UIColor whiteColor];
    btn.padding = JTImageButtonPaddingBig;
    btn.cornerRadius = 0.0;
    btn.borderWidth = 1.0;
    btn.bgColor = BGCOLOR;
    btn.borderColor = [UIColor whiteColor];
    btn.iconSide = JTImageButtonIconSideRight;
}

-(void)Estimate
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==Email_Field)
    {
        
        if (![self validateEmail:Email_Field.text])
        {
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Oops\xF0\x9F\x9A\xAB", nil)  message:JJLocalizedString(@"Please_Enter_Valid_Email_Address", nil)  delegate:nil cancelButtonTitle:JJLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [Alert show];
            [textField becomeFirstResponder];
        }
        else
        {
            [textField resignFirstResponder];
            [Password_field becomeFirstResponder];
        }
       
    }
    else if (textField==Password_field)
    {
       
            [Password_field resignFirstResponder];
    }
    return YES;
}

- (IBAction)didClickback:(id)sender {
    
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        //[self.navigationController popViewControllerAnimated:YES];
      //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SignIn:(id)sender {
    
    [self setLoginDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLoginDetails
{

    if ([self validateTextfield])
    {
        NSDictionary * parameters=@{@"email":Email_Field.text,
                                    @"password":Password_field.text,
                                    @"deviceToken":[Themes writableValue:[Themes GetDeviceToken]],//@"3a91055c93d30ab99c27e0ccb6598f7d5934c7c1787e66d39c72cb435a24eb62",
                                    @"gcm_id":@""};
        
        parameters=[Themes writableValue:parameters];
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        
        [Themes StartView:self.view];
        
        [web SignIn:parameters success:^(NSMutableDictionary *responseDictionary)
         {
             //NSLog(@"%@",responseDictionary);   
             [Themes StopView:self.view];
             
             if ([responseDictionary count]>0)
             {
                 responseDictionary=[Themes writableValue:responseDictionary];
                 
                 NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                 [Themes StopView:self.view];
                 
                 if ([comfiramtion isEqualToString:@"1"])
                 {
                     loginrecord=[[LoginRecord alloc]init];
                     loginrecord.CategoryStr=[responseDictionary valueForKey:@"category"];
                     loginrecord.UserID=[responseDictionary valueForKey:@"user_id"];
                     loginrecord.UserImage=[responseDictionary valueForKey:@"user_image"];
                     loginrecord.UserEmail=[responseDictionary valueForKey:@"email"];
                     loginrecord.UserName=[responseDictionary valueForKey:@"user_name"];
                     loginrecord.MobileNumber=[responseDictionary valueForKey:@"phone_number"];
                     loginrecord.AmountWallet=[responseDictionary valueForKey:@"wallet_amount"];
                     loginrecord.currency=[responseDictionary valueForKey:@"currency"];
                     loginrecord.countryCode=[responseDictionary valueForKey:@"country_code"];
                     
                     [Themes saveXmppUserCredentials:[responseDictionary valueForKey:@"sec_key"]];
                     [Themes saveUserID:loginrecord.UserID];
                     [Themes SaveuserDP:loginrecord.UserImage];
                     [Themes SaveCategoryString:loginrecord.CategoryStr];
                     [Themes SaveuserEmail:loginrecord.UserEmail];
                     [Themes saveUserName:loginrecord.UserName];
                     [Themes SaveMobileNumber:loginrecord.MobileNumber];
                     [Themes SaveWallet:loginrecord.AmountWallet];
                     [Themes SaveCurrency:loginrecord.currency];
                     [Themes SaveCountryCode:loginrecord.countryCode];
                     
                     [Themes StopView:self.view];
                     AppDelegate*appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                     [appdelegate connectToXmpp];
                     [appdelegate setInitialViewController];
                     
                 }
                 else
                 {
                     NSString * alert=[responseDictionary valueForKey:@"message"];
                     
                     NSString *titleStr = JJLocalizedString(@"Oops", nil);
                     UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [Alert show];
                 }
             }
             
             
         }
         
            failure:^(NSError *error) {
                [Themes StopView:self.view];
                [Sign_btn setUserInteractionEnabled:YES];
                
                
            }];
    }
    
    
}
-(BOOL)validateTextfield
{
    if(Email_Field.text.length==0){
        [self showAlert:@"Email_Is_mandatory"];
        [Email_Field becomeFirstResponder];
        [Sign_btn setUserInteractionEnabled:YES];
        return NO;
    }else if(Password_field.text.length==0){
        [self showAlert:@"Password_Is_mandatory"];
        [Password_field becomeFirstResponder];
        [Sign_btn setUserInteractionEnabled:YES];
        return NO;
    }
    
    
    return YES;
}
-(void)showAlert:(NSString *)errorStr{
    NSString *titleStr = JJLocalizedString(@"Oops", nil);
    UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:errorStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [Alert show];
}
- (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(range.location==0&&[string isEqualToString:@" "]){
        return NO;
    }
    return YES;
}
- (IBAction)Forget_password:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ForgetPSDVC *objLoginVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"ForgetPSDVCID"];
    //ForgetPSDVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPSDVCID"];
    [self.navigationController pushViewController:objLoginVC animated:YES];

}

- (IBAction)PushT0:(id)sender {
    //RegisterVC *objRegisterVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVCID"];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    RegisterVC *objRegisterVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"RegisterVCID"];
    [self.navigationController pushViewController:objRegisterVC animated:YES];

    
}
-(IBAction)FBLogin:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [Themes StartView:self.view];

    [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
             [Themes StopView:self.view];

         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
             [Themes StopView:self.view];

         } else {
             NSLog(@"Logged in");
             [Themes StopView:self.view];

             [self faceboo_Check];
         }
     }];
    
  
    
    
}
-(void)faceboo_Check
{
     if ([FBSDKAccessToken currentAccessToken])
    {
        [Themes StartView:self.view];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture, email, name, id" }]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                      id result, NSError *error) {
             if (!error) {
                 [Facebook setHidden:YES];
                 NSString * User_ID=[result objectForKey:@"id"];
                 NSString * name=[result objectForKey:@"name"];
                 NSString * email=[result objectForKey:@"email"];
                 
                 NSDictionary * parameters=@{@"media_id":User_ID,
                                             @"deviceToken":[Themes writableValue:[Themes GetDeviceToken]]};
                 
                 parameters=[Themes writableValue:parameters];
                 
                 UrlHandler *web = [UrlHandler UrlsharedHandler];
                 
                 [Themes StartView:self.view];
                 
                 [web Check_Social:parameters success:^(NSMutableDictionary *responseDictionary)
                  {
                      //NSLog(@"%@",responseDictionary);
                      [Themes StopView:self.view];
                      
                      if ([responseDictionary count]>0)
                      {
                          responseDictionary=[Themes writableValue:responseDictionary];
                          
                          NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                          [Themes StopView:self.view];
                          
                          if ([comfiramtion isEqualToString:@"1"])                                                      //ALREADY
                          {
                              Email_Field.text=email;

                               loginrecord=[[LoginRecord alloc]init];
                               loginrecord.CategoryStr=[responseDictionary valueForKey:@"category"];
                               loginrecord.UserID=[responseDictionary valueForKey:@"user_id"];
                               loginrecord.UserImage=[responseDictionary valueForKey:@"user_image"];
                               loginrecord.UserEmail=[responseDictionary valueForKey:@"email"];
                               loginrecord.UserName=[responseDictionary valueForKey:@"user_name"];
                               loginrecord.MobileNumber=[responseDictionary valueForKey:@"phone_number"];
                               loginrecord.AmountWallet=[responseDictionary valueForKey:@"wallet_amount"];
                               loginrecord.currency=[responseDictionary valueForKey:@"currency"];
                               loginrecord.countryCode=[responseDictionary valueForKey:@"country_code"];
                               
                               [Themes saveUserID:loginrecord.UserID];
                               [Themes SaveuserDP:loginrecord.UserImage];
                               [Themes SaveCategoryString:loginrecord.CategoryStr];
                               [Themes SaveuserEmail:loginrecord.UserEmail];
                               [Themes saveUserName:loginrecord.UserName];
                               [Themes SaveMobileNumber:loginrecord.MobileNumber];
                               [Themes SaveWallet:loginrecord.AmountWallet];
                               [Themes SaveCurrency:loginrecord.currency];
                               [Themes SaveCountryCode:loginrecord.countryCode];
                                [Themes saveXmppUserCredentials:[responseDictionary valueForKey:@"sec_key"]];
                               [Themes StopView:self.view];
                              
                              [self moveToStarterVC];
                              
                          }
                          else if ([comfiramtion isEqualToString:@"0"])                                          //BLOCK
                              
                          {
                              NSString * alert=[responseDictionary valueForKey:@"message"];
                              
                              NSString *titleStr = JJLocalizedString(@"Oops", nil);
                              UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                              [Alert show];
                          }
                          else                                                                                           //SIGNUP
                          {
                              NSString * alert=[responseDictionary valueForKey:@"message"];
                              
                              NSString *titleStr = JJLocalizedString(@"Oops", nil);
                              UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                              [Alert show];
                              
                              UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                              //RegisterVC *objRegisterVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVCID"];
                              RegisterVC *objRegisterVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"RegisterVCID"];
                              
                              objRegisterVC.NameFB=name;
                              objRegisterVC.IDFB=User_ID;
                              objRegisterVC.EmailFB=email;
                              [self.navigationController pushViewController:objRegisterVC animated:YES];
                              
                          }
                      }
                      
                      
                      
                      
                  }
                  
                           failure:^(NSError *error) {
                               [Themes StopView:self.view];
                               
                               [Sign_btn setUserInteractionEnabled:YES];
                               
                               
                           }];
                 
             }
         }];
        
        [Themes StopView:self.view];
        
        
    }
}
-(void)moveToStarterVC{
    AppDelegate *testAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [testAppDelegate setInitialViewController];
    [testAppDelegate connectToXmpp];
    
}
@end
