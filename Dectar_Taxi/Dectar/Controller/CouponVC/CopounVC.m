//
//  CopounVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 2/4/16.
//  Copyright © 2016 CasperonTechnologies. All rights reserved.
//

#import "CopounVC.h"
#import "Themes.h"
#import "Constant.h"
#import "UrlHandler.h"
#import "LanguageHandler.h"

@interface CopounVC ()

@end

@implementation CopounVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [_coupon_fld setText:[Themes GetCoupon]];
    if ([_coupon_fld.text length]<=0) {
        [_benefits_view setHidden:YES];
        [_Apply_btn setTitle:JJLocalizedString(@"Apply", nil)  forState:UIControlStateNormal];
    }
    else
    {
        [_benefits_view setHidden:NO];
        [_Apply_btn setTitle:JJLocalizedString(@"Remove", nil) forState:UIControlStateNormal];
        [_detail_lbl setText:[Themes GetCouponDetails]];
    }
    
    
    _couonfld_view.layer.cornerRadius = 10;
    _couonfld_view.layer.shadowColor = [UIColor blackColor].CGColor;
    _couonfld_view.layer.shadowOpacity = 0.5;
    _couonfld_view.layer.shadowRadius = 2;
    _couonfld_view.layer.shadowOffset = CGSizeMake(3.0f,3.0f);

    _benefits_view.layer.cornerRadius = 10;
    _benefits_view.layer.shadowColor = [UIColor blackColor].CGColor;
    _benefits_view.layer.shadowOpacity = 0.5;
    _benefits_view.layer.shadowRadius = 2;
    _benefits_view.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    _Apply_btn.layer.shadowColor = [UIColor blackColor].CGColor;
    _Apply_btn.layer.shadowOpacity = 0.5;
    _Apply_btn.layer.shadowRadius = 2;
    _Apply_btn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);

    // Do any additional setup after loading the view.
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    _heading.text=JJLocalizedString(@"Coupon", nil);
    _hint.text=JJLocalizedString(@"Your_allowance", nil);
    
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
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)apply_action:(id)sender {
    UIButton *resultButton = (UIButton *)sender;
    if ([resultButton.currentTitle isEqualToString:JJLocalizedString(@"Apply", nil)])
    {
        NSDictionary *parameters=@{@"user_id":[Themes getUserID],
                                   @"code":_coupon_fld.text,
                                   @"pickup_date":_Date};
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        [web ApplyCoupon:parameters success:^(NSMutableDictionary *responseDictionary) {
            
            [Themes StopView:self.view];
            if ([responseDictionary count]>0)
            {
                responseDictionary=[Themes writableValue:responseDictionary];
                NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                
                [Themes StopView:self.view];
                if ([comfiramtion isEqualToString:@"1"])
                {
                    [_coupon_fld resignFirstResponder];
                    NSString * alert=[[responseDictionary valueForKey:@"response"]valueForKey:@"message"];
                    NSString * code=[[responseDictionary valueForKey:@"response"]valueForKey:@"code"];
                    NSString * Type=[[responseDictionary valueForKey:@"response"]valueForKey:@"discount_type"];
                    NSString * Amount=[[responseDictionary valueForKey:@"response"]valueForKey:@"discount_amount"];

                    [Themes SaveCoupon:code];
                    UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [Alert show];
                    [_Apply_btn setTitle:JJLocalizedString(@"Remove", nil)  forState:UIControlStateNormal];
                    [[NSNotificationCenter defaultCenter] postNotificationName: @"CouponApplied" object:nil];
                    [_benefits_view setHidden:NO];
                    if ([Type isEqualToString:@"Percent"]) {
                        NSString *Precent=@"%";
                        NSString * success=JJLocalizedString(@"You_have_successfully", nil);
                        NSString * amount=JJLocalizedString(@"will_be_reduce", nil);
                        [_detail_lbl setText:[NSString stringWithFormat:@"%@ %@%@ %@",success,Amount,Precent,amount]];
                        [_detail_lbl sizeToFit];
                        [Themes SaveCouponDetails:_detail_lbl.text];
                        

                    }
                    else
                    {
                        NSString * success=JJLocalizedString(@"You_have_successfully_Flat", nil);
                        NSString * amount=JJLocalizedString(@"will_be_reduce", nil);

                        [_detail_lbl setText:[NSString stringWithFormat:@"%@%@ %@",success,Amount,amount]];
                        [_detail_lbl sizeToFit];
                        [Themes SaveCouponDetails:_detail_lbl.text];

                    }
                   

                }
                else
                {
                    NSString * alert=[responseDictionary valueForKey:@"response"];
                    NSString *titleStr = JJLocalizedString(@"Oops", nil);
                    UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [Alert show];
                    [Themes SaveCoupon:@""];
                    [Themes SaveCouponDetails:@""];
                    [_coupon_fld resignFirstResponder];

                }
                
            }
        }
                 failure:^(NSError *error) {
                     [Themes StopView:self.view];
                     [_coupon_fld resignFirstResponder];

                     
                     
        }];
    }
    else if ([resultButton.currentTitle isEqualToString:JJLocalizedString(@"Remove", nil) ])
    {
     
        UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[Themes getAppName] message:JJLocalizedString(@"Your_Coupon_Successfully_Removed", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
        [_benefits_view setHidden:YES];
        [Themes SaveCoupon:@""];
        [_coupon_fld setText:@""];
        [Themes SaveCouponDetails:@""];
        [_Apply_btn setTitle:JJLocalizedString(@"Apply", nil) forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"CouponApplied" object:nil];

    }
}

@end
