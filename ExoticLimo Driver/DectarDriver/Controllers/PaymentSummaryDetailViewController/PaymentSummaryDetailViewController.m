//
//  PaymentSummaryDetailViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/14/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "PaymentSummaryDetailViewController.h"

@interface PaymentSummaryDetailViewController ()

@end

@implementation PaymentSummaryDetailViewController
@synthesize paymentHeaderLbl,paymentDateLbl,amountHeaderLbl,amountLbl,RecDateHeaderLbl,receiverDateLbl,headerLbl,paymentDetailTableView,paymentDetailArray,objPayRecs;
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kDriverCashPaymentNotifWhenQuit
                                               object:nil];
    [self setFont];
    [self setDataToBasicView];
     paymentDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getPaymentDetail];
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
-(void)setDataToBasicView{
    paymentDateLbl.text=[NSString stringWithFormat:@"%@ to %@",objPayRecs.fromDate,objPayRecs.toDate];
    amountLbl.text=[NSString stringWithFormat:@"%@ %@",objPayRecs.PriceSymbol,objPayRecs.Amount];
    receiverDateLbl.text= objPayRecs.ReceivedDate;
}

-(void)setFont{
    headerLbl=[Theme setHeaderFontForLabel:headerLbl];
    [headerLbl setText:JJLocalizedString(@"PAYMENT_DETAIL", nil)];
    [paymentHeaderLbl setText:JJLocalizedString(@"Payment", nil)];
    [amountHeaderLbl setText:JJLocalizedString(@"Amount", nil)];
    [RecDateHeaderLbl setText:JJLocalizedString(@"Received_Date", nil)];

    
//    paymentHeaderLbl=[Theme setNormalFontForLabel:paymentHeaderLbl];
//    paymentDateLbl=[Theme setSmallBoldFontForLabel:paymentDateLbl];
//    amountHeaderLbl=[Theme setNormalFontForLabel:amountHeaderLbl];
//    amountLbl=[Theme setSmallBoldFontForLabel:amountLbl];
//    RecDateHeaderLbl=[Theme setNormalFontForLabel:RecDateHeaderLbl];
//    receiverDateLbl=[Theme setNormalSmallFontForLabel:receiverDateLbl];
}
-(void)getPaymentDetail{
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getPaymentDetail:[self setParametersPaymentDetail]
                   success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             paymentDetailArray=[[NSMutableArray alloc]init];
              NSString * currency=[Theme checkNullValue:[Theme findCurrencySymbolByCode:responseDictionary[@"response"][@"currency"]]];
             for (NSDictionary * reasonDict in responseDictionary[@"response"][@"listsArr"]) {
                 PaymentDetailRecords * objPaymentRecs=[[PaymentDetailRecords alloc]init];
                 objPaymentRecs.rideId=[Theme checkNullValue:reasonDict[@"ride_id"]];
                 objPaymentRecs.amount=[Theme checkNullValue:reasonDict[@"amount"]];
                 objPaymentRecs.currencySymbol=currency;
                 objPaymentRecs.date=[Theme checkNullValue:reasonDict[@"ride_date"]];
                 
                 [paymentDetailArray addObject:objPaymentRecs];
             }
             if([paymentDetailArray count]==0){
                 [self.view makeToast:@"No_Records_Found"];
             }
             [paymentDetailTableView reloadData];
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
-(NSDictionary *)setParametersPaymentDetail{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"pay_id":objPayRecs.paymentID,
                                  };
    return dictForuser;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [paymentDetailArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paymentDetailIdentifier"];
    if (cell == nil) {
        cell = [[PaymentDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paymentDetailIdentifier"];
    }
    PaymentDetailRecords * objPayDetRecs=[[PaymentDetailRecords alloc]init];
    objPayDetRecs=[paymentDetailArray objectAtIndex:indexPath.row];
    [cell setDatasToDetailList:objPayDetRecs];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
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

- (IBAction)didClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
