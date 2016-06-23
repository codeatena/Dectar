//
//  ChangePasswordVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/27/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "LanguageHandler.h"

@interface ChangePasswordVC ()

@end

@implementation ChangePasswordVC
@synthesize newpsd_fld,confim_fld,current_fld,saveBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)applicationLanguageChangeNotification:(NSNotification*)notification{
    
    [_heading setText:JJLocalizedString(@"change_password", nil)];
    [saveBtn setTitle:JJLocalizedString(@"save", nil) forState:UIControlStateNormal];
    [current_fld setPlaceholder:JJLocalizedString(@"old_password", nil)];
    [newpsd_fld setPlaceholder:JJLocalizedString(@"new_password", nil)];
    [confim_fld setPlaceholder:JJLocalizedString(@"confirm_password", nil)];
    

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField==current_fld)
    {
        [textField resignFirstResponder];
        [newpsd_fld  becomeFirstResponder];
    }
    else  if(textField==newpsd_fld)
    {
        [textField resignFirstResponder];
        [confim_fld becomeFirstResponder];
    }
    else if(textField==confim_fld)
    {
        if (![newpsd_fld.text isEqualToString:confim_fld.text])
        {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(@"PASSWORD_MISS_MATCH", nil)  delegate:nil cancelButtonTitle:@"RETRY" otherButtonTitles:nil, nil];
            [Alert show];

        }
        else
        {
            [saveBtn setHidden:NO];
            [textField resignFirstResponder];
            //[self saveData];
        }
    }
    return YES;
}
- (IBAction)savepsd:(id)sender {
    
    if (![newpsd_fld.text isEqualToString:confim_fld.text])
    {
        NSString *titleStr = JJLocalizedString(@"Oops", nil);
        UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(@"PASSWORD_MISS_MATCH", nil) delegate:nil cancelButtonTitle:@"RETRY" otherButtonTitles:nil, nil];
        [Alert show];
    }
    else
    {
        [saveBtn setHidden:NO];

        [self saveData];

    }
    
}
- (IBAction)backto:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)saveData
{
    NSDictionary *parameters=@{@"user_id":[Themes getUserID],
                               @"password":current_fld.text,
                               @"new_password":confim_fld.text};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web passwrdChange:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         [Themes StopView:self.view];

         if ([responseDictionary count]>0)
         {
             responseDictionary=[Themes writableValue:responseDictionary];
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             NSString * alert=[responseDictionary valueForKey:@"response"];
             [Themes StopView:self.view];
             if ([comfiramtion isEqualToString:@"1"])
             {
                 
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
                 [saveBtn setHidden:NO];

                 [self.navigationController popViewControllerAnimated:YES];
             }
             else
             {
                 NSString *titleStr = JJLocalizedString(@"Oops", nil);
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
             }

         }
         
     }
        failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];

}

@end
