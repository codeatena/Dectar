//
//  PaymentVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 12/28/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import "PaymentVC.h"
#import "MyRideRecord.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "Constant.h"
#import "RatingVC.h"
#import "WebViewVC.h"
#import "LanguageHandler.h"


@interface PaymentVC ()<UITableViewDataSource,UITableViewDelegate>
{
    MyRideRecord *addressObj;
    NSMutableArray *paymentArry;
    NSString * payment_Name,*paymnet_code;
    NSString * Mobile_ID;
    NSTimer *payment_timer;
    NSString  *stripe_connected;
    NSString * payment_timeout;



}
@end

@implementation PaymentVC

- (void)viewDidLoad {
    
    [self payMode];
    [_payment_Table setDelegate:self];
    [_payment_Table setDataSource:self];

    _payment_Table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _submit_btn.userInteractionEnabled=NO;
       [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_heading setText:JJLocalizedString(@"paymetn_pay", nil)];
    [_submit_btn setTitle:JJLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
    [_Cancle_btn setTitle:JJLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)payMode
{
    NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                @"ride_id": _RideID};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web PaymentType:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
             NSLog(@"%@",responseDictionary);
             responseDictionary=[Themes writableValue:responseDictionary];
             
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             [Themes StopView:self.view];
             paymentArry=[NSMutableArray array];
             if ([comfiramtion isEqualToString:@"1"])
             {
                 
                 for (NSDictionary * objCatDict in responseDictionary[@"response"][@"payment"]) {
                     addressObj=[[MyRideRecord alloc]init];
                     addressObj.paymentname=[objCatDict valueForKey:@"name"];
                     addressObj.paymentCode =[objCatDict valueForKey:@"code"];
                     
                     [paymentArry addObject:addressObj];
                     
                 }
                 stripe_connected=[NSString stringWithFormat:@"%@",[[responseDictionary valueForKey:@"response"] valueForKey:@"stripe_connected"]];
                 
                 
                 payment_timeout=[NSString stringWithFormat:@"%@",[[responseDictionary valueForKey:@"response"]valueForKey:@"payment_timeout"]];
                 
                 if([stripe_connected  isEqual: @"Yes"])
                 {
                     float Timing = [payment_timeout floatValue];
                     
                     payment_timer=[NSTimer scheduledTimerWithTimeInterval: Timing
                                                                    target: self
                                                                  selector:@selector(invoke_payment)
                                                                  userInfo: nil repeats:YES];
                     
                 }

                 [_payment_Table reloadData];
                 
                 
             }
             else
             {
                 
             }
         }
         
         
         
     }
             failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [payment_timer invalidate];

}

-(void)invoke_payment
{
    
    [payment_timer invalidate];
    
    if([stripe_connected  isEqual: @"Yes"])
    {
        NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                    @"ride_id":_RideID};
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        [web AutoDetect:parameters success:^(NSMutableDictionary *responseDictionary)
         {
             [Themes StopView:self.view];
             
             if ([responseDictionary count]>0)
             {
                 NSLog(@"%@",responseDictionary);
                 responseDictionary=[Themes writableValue:responseDictionary];
                 
                 NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                 [Themes StopView:self.view];
                 if ([comfiramtion isEqualToString:@"1"])
                 {
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:JJLocalizedString(@"Your_Payment_successfully finished", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
                     [objLoginVC setRideID_Rating:_RideID];
                     [self.navigationController pushViewController:objLoginVC animated:YES];
                     
                 }
                 /*  else if ([comfiramtion isEqualToString:@"2"])
                  {
                  UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:@"Your Wallet amount successfully used"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                  [alert show];
                  [self listPayment];
                  [paymnetTabel reloadData];
                  [bgView setHidden:YES];
                  [paymentView setHidden:YES];
                  
                  }
                  
                  else if ([comfiramtion isEqualToString:@"0"])
                  {
                  UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:@"Your wallet is empty"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                  [alert show];
                  [self listPayment];
                  [paymnetTabel reloadData];
                  [bgView setHidden:YES];
                  [paymentView setHidden:YES];
                  
                  
                  }*/
             }
             
             
             
         }
                failure:^(NSError *error)
         {
             [Themes StopView:self.view];
         }];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [paymentArry count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
    }
  
    NSIndexPath* selection = [tableView indexPathForSelectedRow];
    if (selection && selection.row == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    MyRideRecord *objRec=(MyRideRecord*)[paymentArry objectAtIndex:indexPath.row];
    UIFont *myFont = [UIFont fontWithName: @"Avenir-Medium" size: 18.0 ];
    cell.textLabel.font  = myFont;
    cell.textLabel.text=objRec.paymentname;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    addressObj = [paymentArry objectAtIndex:indexPath.row];
    
    payment_Name=addressObj.paymentname;
    paymnet_code=addressObj.paymentCode;
    
    _submit_btn.backgroundColor=BGCOLOR;
    _submit_btn.userInteractionEnabled=YES;
    
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_6) {
        return 70;
    }
    return 59;
}


- (IBAction)Submit_Action:(id)sender {
    
    if ([paymnet_code isEqualToString:@"cash"])
    {
        NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                    @"ride_id":_RideID};
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        [web CashPayment:parameters success:^(NSMutableDictionary *responseDictionary)
         {
             [Themes StopView:self.view];
             
             if ([responseDictionary count]>0)
             {
                 NSLog(@"%@",responseDictionary);
                 responseDictionary=[Themes writableValue:responseDictionary];
                 
                 NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                 [Themes StopView:self.view];
                 
                 if ([comfiramtion isEqualToString:@"1"])
                 {
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:JJLocalizedString(@"Your_Payment_Driver_Confirmation", nil)   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     // if(self.view.window){
                     /* */
                     //}
                     
                    /* RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
                     [objLoginVC setRideID_Rating:_RideID];*/
                     //[self presentViewController:objLoginVC animated:YES completion:nil];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"SecondViewControllerDismissed"
                                                                         object:nil
                                                                       userInfo:nil];
                     [self.navigationController popViewControllerAnimated:YES];
                     
                 }
                 else
                 {
                     NSString * Response=[responseDictionary valueForKey:@"response"];
                     [self Toast:Response];

                 }
                 
                 
             }
             
         }
                 failure:^(NSError *error)
         {
             [Themes StopView:self.view];
         }];
        
    }
    else if ([paymnet_code isEqualToString:@"wallet"])
    {
        NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                    @"ride_id":_RideID};
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        [web WalletPayment:parameters success:^(NSMutableDictionary *responseDictionary)
         {
             [Themes StopView:self.view];
             
             if ([responseDictionary count]>0)
             {
                 NSLog(@"%@",responseDictionary);
                 responseDictionary=[Themes writableValue:responseDictionary];
                 
                 NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                 [Themes StopView:self.view];
                 if ([comfiramtion isEqualToString:@"1"])
                 {
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message: JJLocalizedString(@"Your_Payment_successfully finished", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
                     [objLoginVC setRideID_Rating:_RideID];
                     [self.navigationController pushViewController:objLoginVC animated:YES];

                     
                 }
                 else if ([comfiramtion isEqualToString:@"2"])
                 {
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:JJLocalizedString(@"Your_wallet_amount_Successfull", nil)   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     [self payMode];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"WalletUsed"
                                                                         object:nil
                                                                       userInfo:nil];
                     //[_payment_Table reloadData];
                     
                 }
                 
                 else if ([comfiramtion isEqualToString:@"0"])
                 {
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:JJLocalizedString(@"Your_wallet_is_empty", nil)   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     [self payMode];
                     //[_payment_Table reloadData];
                     
                     
                 }
             }
             
         }
                   failure:^(NSError *error)
         {
             [Themes StopView:self.view];
         }];
        
    }
    else if ([paymnet_code isEqualToString:@"auto_detect"])
    {
        NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                    @"ride_id":_RideID};
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        [web AutoDetect:parameters success:^(NSMutableDictionary *responseDictionary)
         {
             [Themes StopView:self.view];
             
             if ([responseDictionary count]>0)
             {
                 NSLog(@"%@",responseDictionary);
                 responseDictionary=[Themes writableValue:responseDictionary];
                 
                 NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                 [Themes StopView:self.view];
                 if ([comfiramtion isEqualToString:@"1"])
                 {
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:JJLocalizedString(@"Your_Payment_successfully finished", nil)   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     
                     RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
                     [objLoginVC setRideID_Rating:_RideID];
                     [self.navigationController pushViewController:objLoginVC animated:YES];
                     
                 }
             }
             
             
             
         }
                failure:^(NSError *error)
         {
             [Themes StopView:self.view];
         }];
    }
    else
    {
        NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                    @"ride_id":_RideID,
                                    @"gateway":paymnet_code};
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        
        [web Getwaypayment:parameters success:^(NSMutableDictionary *responseDictionary)
         {
             [Themes StopView:self.view];
             
             if ([responseDictionary count]>0)
             {
                 NSLog(@"%@",responseDictionary);
                 responseDictionary=[Themes writableValue:responseDictionary];
                 
                 NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                 [Themes StopView:self.view];
                 
                 if ([comfiramtion isEqualToString:@"1"])
                 {
                     Mobile_ID=[responseDictionary valueForKey:@"mobile_id"];
                     WebViewVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewVCID"];
                     addfavour.FromWhere=NO;
                     addfavour.parameters=Mobile_ID;
                     addfavour.Ride_ID=_RideID;
                     [self.navigationController pushViewController:addfavour animated:YES];

                     
                 }
                 else
                 {
                     
                 }
                 
             }
             
             
         }
                   failure:^(NSError *error)
         {
             [Themes StopView:self.view];
         }];
    }
   

}

- (IBAction)Cancel_Action:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
