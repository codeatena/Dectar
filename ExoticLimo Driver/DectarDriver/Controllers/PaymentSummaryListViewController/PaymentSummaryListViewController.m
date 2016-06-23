//
//  PaymentSummaryListViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/14/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "PaymentSummaryListViewController.h"

@interface PaymentSummaryListViewController ()

@end

@implementation PaymentSummaryListViewController
@synthesize paymentTableView,headerLbl,payMentArray,noRecsImg;
+ (instancetype) controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"PaymentListVCSID"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kDriverCashPaymentNotifWhenQuit
                                               object:nil];
    
    headerLbl=[Theme setHeaderFontForLabel:headerLbl];
    [headerLbl setText:JJLocalizedString(@"PAYMENT_STATEMENTS", nil)];
    paymentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getPaymentList];
    // Do any additional setup after loading the view.
}
- (void)receiveNotification:(NSNotification *) notification
{
    if(self.view.window){
        NSDictionary * dict=notification.userInfo;
        if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[dict objectForKey:@"action"]]] isEqualToString:@"receive_cash"]){
            NSString * rideId=[Theme checkNullValue:[dict objectForKey:@"key1"]];
            NSString * CurrId=[Theme findCurrencySymbolByCode:[Theme checkNullValue:[dict objectForKey:@"key4"]]];
            NSString * fareStr=[Theme checkNullValue:[dict objectForKey:@"key3"]];
            NSString * fareAmt=[NSString stringWithFormat:@"%@ %@",CurrId,fareStr];
            
            [self stopActivityIndicator];
            ReceiveCashViewController * objReceiveCashVC=[self.storyboard  instantiateViewControllerWithIdentifier:@"ReceiveCashVCSID"];
            [objReceiveCashVC setRideId:rideId];
            [objReceiveCashVC setFareAmt:fareAmt];
            [self.navigationController pushViewController:objReceiveCashVC animated:YES];
        }
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
}
-(void)getPaymentList{
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getPaymentList:[self setParametersPaymrntList]
                success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             payMentArray=[[NSMutableArray alloc]init];
             NSString * currency=[Theme checkNullValue:[Theme findCurrencySymbolByCode:responseDictionary[@"response"][@"currency"]]];
             for (NSDictionary * reasonDict in responseDictionary[@"response"][@"payments"]) {
                 PaymentRecords * objPaymentRecs=[[PaymentRecords alloc]init];
                 objPaymentRecs.paymentID=[Theme checkNullValue:reasonDict[@"pay_id"]];
                 objPaymentRecs.toDate=[Theme checkNullValue:reasonDict[@"pay_duration_to"]];
                 objPaymentRecs.fromDate=[Theme checkNullValue:reasonDict[@"pay_duration_from"]];
                 objPaymentRecs.PriceSymbol=currency;
                 objPaymentRecs.Amount=[Theme checkNullValue:reasonDict[@"amount"]];
                 objPaymentRecs.ReceivedDate=[Theme checkNullValue:reasonDict[@"pay_date"]];
                 
                 [payMentArray addObject:objPaymentRecs];
             }
             if([payMentArray count]==0){
                 [self.view makeToast:@"No Records Found."];
             }
             [paymentTableView reloadData];
         }else{
             
             [self.view makeToast:kErrorMessage];
         }
     }
                failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [self.view makeToast:kErrorMessage];
         
     }];
}
-(NSDictionary *)setParametersPaymrntList{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  };
    return dictForuser;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([payMentArray count]==0){
        noRecsImg.hidden=NO;
    }else{
        noRecsImg.hidden=YES;
    }
    return [payMentArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentListIdentifier"];
    if (cell == nil) {
        cell = [[PaymentListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:@"PaymentListIdentifier"];
    }
    PaymentRecords * objPayRecs=[[PaymentRecords alloc]init];
    objPayRecs=[payMentArray objectAtIndex:indexPath.row];
    [cell setDatasToList:objPayRecs];
    objPayRecs=[payMentArray  objectAtIndex:indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentRecords * objRecs=[[PaymentRecords alloc]init];
    objRecs=[payMentArray objectAtIndex:indexPath.row];
    PaymentSummaryDetailViewController * objPaymentDetailVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PaymentDetailVCSID"];
    [objPaymentDetailVC setObjPayRecs:objRecs];
    [self.navigationController pushViewController:objPaymentDetailVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}
@end
