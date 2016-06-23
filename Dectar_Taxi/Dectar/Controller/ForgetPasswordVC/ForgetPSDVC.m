//
//  ForgetPSDVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 10/12/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "ForgetPSDVC.h"
#import "UrlHandler.h"
#import "Themes.h"
#import "OTP_VC.h"
#import <Stripe/Stripe.h>
#import "LanguageHandler.h"

@interface ForgetPSDVC ()<UITextFieldDelegate,STPPaymentCardTextFieldDelegate>
{
        int direction;
        int shakes;
        int seconds;
        NSTimer * timer;
}
@property (strong, nonatomic) STPPaymentCardTextField *CardField;
@end

@implementation ForgetPSDVC
@synthesize Email_fld,timer_lbl,email_btn,resend_Btn;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    Email_fld.layer.shadowColor = [UIColor blackColor].CGColor;
    Email_fld.layer.shadowOpacity = 0.5;
    Email_fld.layer.shadowRadius = 2;
    Email_fld.layer.shadowOffset = CGSizeMake(3.0f,3.0f);

    
    email_btn.layer.cornerRadius = 5;
    email_btn.layer.shadowColor = [UIColor blackColor].CGColor;
    email_btn.layer.shadowOpacity = 0.5;
    email_btn.layer.shadowRadius = 2;
    email_btn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    Email_fld.delegate=self;
    
    [timer invalidate];

    [self statusbarColor];
    
   STPPaymentCardTextField* CardField= [[STPPaymentCardTextField alloc] initWithFrame:CGRectMake(Email_fld.frame.origin.x, Email_fld.frame.origin.y+Email_fld.frame.size.height+20, Email_fld.frame.size.width, Email_fld.frame.size.height)];
    CardField.delegate = self;
    self.CardField=CardField;
    [self.view addSubview:CardField];
   
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)paymentCardTextFieldDidChange:(nonnull STPPaymentCardTextField *)textField {
    self.navigationItem.rightBarButtonItem.enabled = textField.isValid;
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [Email_fld setPlaceholder:JJLocalizedString(@"Forget_password", nil)];
    [_heading setText:JJLocalizedString(@"", nil)];
    [email_btn setTitle:JJLocalizedString(@"E_mail_me", nil) forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)statusbarColor
{
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)];
    statusBarView.backgroundColor  =  [UIColor whiteColor];
    [self.view addSubview:statusBarView];
}
- (IBAction)Back_to:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [timer invalidate];

}
- (IBAction)Send_mail:(id)sender {
   
    [self sendmail];

}
- (IBAction)Resnd_mail:(id)sender {
    
    [self sendmail];

    
}
- (void) updateCountdown
{
    
    int  secondsleft;
    secondsleft = (seconds %3600) % 60;
    timer_lbl.text = [NSString stringWithFormat:@"00:%02d", seconds];
    seconds--;
    
    if (seconds<0)
    {
        [timer invalidate];
        [resend_Btn setHidden:NO];
        [timer_lbl setHidden:YES];
    }
}
-(BOOL)validateTextfield
{
    if(Email_fld.text.length==0){
        [self showAlert:@"Email_is_mandatory"];
        [Email_fld becomeFirstResponder];
        return NO;
    }
    
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==Email_fld)
    {
        
        if (![self validateEmail:Email_fld.text])
        {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(@"Please_Enter_Valid_Email_Address", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
            direction = 1;
            shakes = 0;
            [self shake:Email_fld];

            [textField becomeFirstResponder];
        }
        else
        {
            [textField resignFirstResponder];
        }
        
    }
    return YES;
}
-(void)showAlert:(NSString *)errorStr{
    NSString *titleStr = JJLocalizedString(@"Oops", nil);
    UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(errorStr, nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [Alert show];
    direction = 1;
    shakes = 0;
    [self shake:Email_fld];

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
-(void)shake:(UIView *)theOneYouWannaShake
{
    [UIView animateWithDuration:0.03 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*direction, 0);
     }
                     completion:^(BOOL finished)
     {
         if(shakes >= 10)
         {
             theOneYouWannaShake.transform = CGAffineTransformIdentity;
             return;
         }
         shakes++;
         direction = direction * -1;
         [self shake:theOneYouWannaShake];
     }];
}
-(void)sendmail
{
  
    
    if ([self validateTextfield])
   {
       //timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self   selector:@selector(updateCountdown) userInfo:nil repeats: YES];
       
      // seconds=30;
      // [timer_lbl setHidden:NO];
       
       NSDictionary *parameters=@{@"email":Email_fld.text};
       
       UrlHandler *web = [UrlHandler UrlsharedHandler];
       [Themes StartView:self.view];
       [web Reset_passowrd:parameters success:^(NSMutableDictionary *responseDictionary)
        {
            [Themes StopView:self.view];
            
            if ([responseDictionary count]>0)
            {
                //  NSLog(@"response%@",responseDictionary);
                responseDictionary=[Themes writableValue:responseDictionary];
                
                NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                NSString * alert=[responseDictionary valueForKey:@"response"];
                [Themes StopView:self.view];
                
                if ([comfiramtion isEqualToString:@"1"])
                {
                    UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [Alert show];
                    
                    [timer invalidate];
                    OTP_VC * otpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OTPVCID"];
                    otpVC.Checkking=@"ForgetPassowrd";
                    otpVC.OTP_Status=[responseDictionary valueForKey:@"sms_status"];
                    otpVC.OTP_Code=[responseDictionary valueForKey:@"verification_code"];
                    otpVC.email_id=[responseDictionary valueForKey:@"email_address"];
                    [self.navigationController pushViewController:otpVC animated:YES];

                    
                }
                else
                {
                    NSString *titleStr = JJLocalizedString(@"Oops", nil);
                    UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [Alert show];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    [timer invalidate];

                }
                
            }
        }
                 failure:^(NSError *error) {
                     
                     [Themes StopView:self.view];
                     [timer invalidate];

                     
                 }];
   }

   
}
@end
