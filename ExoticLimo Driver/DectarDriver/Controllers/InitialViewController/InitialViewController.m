//
//  InitialViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/21/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "InitialViewController.h"
#import "LoginViewController.h"
@interface InitialViewController ()

@end

@implementation InitialViewController
@synthesize signInBtn,registerBtn;
+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"InitialVCSID"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self setFontAndColor];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
    
}
-(void)applicationLanguageChangeNotification:(NSNotification*)notification{
    
    
    [self.signInBtn setTitle:JJLocalizedString(@"SIGN_IN", nil) forState:UIControlStateNormal];
    [self.registerBtn setTitle:JJLocalizedString(@"REGISTER", nil) forState:UIControlStateNormal];
}

-(void)setFontAndColor{
    signInBtn=[Theme setBoldFontForButton:signInBtn];
    registerBtn=[Theme setBoldFontForButton:registerBtn];
   // [signInBtn setBackgroundColor:SetBlueColor];
//    signInBtn.layer.cornerRadius=2;
//    registerBtn.layer.cornerRadius=2;
//    signInBtn.layer.masksToBounds=YES;
//    registerBtn.layer.masksToBounds=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didClickRegisterBtn:(id)sender {
//    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Cabily Partner" message:@"Please visit our website to register. Thank you" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
    
    SignUpWebViewController * objSignUpVc=[self.storyboard instantiateViewControllerWithIdentifier:@"SignUpWebVSSID"];
    [self.navigationController pushViewController:objSignUpVc animated:YES];
    //RegisterMainVCSID
    
//        RegisterViewController * objSignUpVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVCSID"];
//        [self.navigationController pushViewController:objSignUpVc animated:YES];
}

- (IBAction)didClickSignInBtn:(id)sender {
    signInBtn.userInteractionEnabled=NO;
    LoginViewController * objLoginVc=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVCSID"];
    [self.navigationController pushViewController:objLoginVc animated:YES];
    signInBtn.userInteractionEnabled=YES;
}

@end
