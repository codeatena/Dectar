//
//  ResetVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 10/19/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import "ResetVC.h"
#import "UrlHandler.h"
#import "Themes.h"
#import "LoginVC.h"
#import "LanguageHandler.h"

@interface ResetVC ()
{
    BOOL checkBoxSelected;
    int direction;
    int shakes;

}

@end

@implementation ResetVC
@synthesize Email_fld,password_fld,show_btn,reset_passwrd_btn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [show_btn setBackgroundImage:[UIImage imageNamed:@"Unchecked"]
                        forState:UIControlStateNormal];
    [show_btn setBackgroundImage:[UIImage imageNamed:@"Checked"]
                        forState:UIControlStateHighlighted];
    show_btn.adjustsImageWhenHighlighted=YES;
    password_fld.secureTextEntry=YES;

    reset_passwrd_btn.layer.cornerRadius = 5;
    reset_passwrd_btn.layer.shadowColor = [UIColor blackColor].CGColor;
    reset_passwrd_btn.layer.shadowOpacity = 0.5;
    reset_passwrd_btn.layer.shadowRadius = 2;
    reset_passwrd_btn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    [self statusbarColor];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_heading setText:JJLocalizedString(@"Reset_Password", nil)];
    [Email_fld setPlaceholder:JJLocalizedString(@"Enter_EMail_ID", nil)];
    [password_fld setPlaceholder:JJLocalizedString(@"New_Password", nil)];
    [_showpassword setText:JJLocalizedString(@"Show_Password", nil)];
    [reset_passwrd_btn setTitle:JJLocalizedString(@"Reset_Password", nil) forState:UIControlStateNormal];
}

-(void)statusbarColor
{
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)];
    statusBarView.backgroundColor  =  [UIColor whiteColor];
    [self.view addSubview:statusBarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bact_to:(id)sender {
   // [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];

}

- (IBAction)reset:(id)sender {
    
    if ([self validateTextfield])
    {
        
        NSDictionary *parameters=@{@"email":Email_fld.text,
                                   @"password":password_fld.text};
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        [web Update_passowrd:parameters success:^(NSMutableDictionary *responseDictionary)
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
                     
                     LoginVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVCID"];
                     [self.navigationController pushViewController:objLoginVC animated:YES];
                     
                 }
                 else
                 {
                     NSString *titleStr = JJLocalizedString(@"Oops", nil);
                     UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [Alert show];
                     
                     
                 }
                 
             }
         }
                    failure:^(NSError *error) {
                        
                        [Themes StopView:self.view];
                        
                        
                    }];
    }
    

    
}
- (IBAction)Show_password:(id)sender {
    
    checkBoxSelected = !checkBoxSelected;
    UIButton* check = (UIButton*) sender;
    if (checkBoxSelected == NO)
    {
        [check setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
        password_fld.secureTextEntry=YES;

    }
    
    else
    {
        [check setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
        password_fld.secureTextEntry=NO;
        password_fld.font = [UIFont fontWithName:@"OpenSans" size:password_fld.font.pointSize];

    }
    

}

-(BOOL)validateTextfield
{
    if(Email_fld.text.length==0){
        [self showAlert:JJLocalizedString(@"Email_is_mandatory", nil)];
        [Email_fld becomeFirstResponder];
        direction = 1;
        shakes = 0;
        [self shake:Email_fld];
        return NO;
    }else if(password_fld.text.length==0){
        [self showAlert:JJLocalizedString(@"Password_is_mandatory", nil)];
        [password_fld becomeFirstResponder];
        direction = 1;
        shakes = 0;
        [self shake:password_fld];
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
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(@"Please_Enter_Valid_Email", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
            direction = 1;
            shakes = 0;
            [self shake:Email_fld];
            
            [password_fld becomeFirstResponder];
            [textField resignFirstResponder];

        }
        
    }
    else if (textField==password_fld)
    {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}
-(void)showAlert:(NSString *)errorStr{
    NSString *titleStr = JJLocalizedString(@"Oops", nil);
    UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(errorStr, nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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

@end
