//
//  EndTripViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/23/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

#import "EndTripViewController.h"

@interface EndTripViewController ()<moveToNectVCFromFareSummary,locationGoogleDelegate>{
     FareSummaryViewController *controller;
}

@end

@implementation EndTripViewController
@synthesize headerLbl,scrollView,locHeaderLbl,dropTimeHeaderLbl,waitHeaderLbl,disHeaderLbl,locationLbl,timeLbl,waitingTimeLbl,distanceTxtField,endTripBtn,hourWaitTxtField,minWaitTxtField,rideID,currencyCodeAndAmount;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFont];
   
    // Do any additional setup after loading the view.
}
-(void)setFont{
    [headerLbl setText:JJLocalizedString(@"Trip_Detail", nil)];
    
    [locHeaderLbl setText:JJLocalizedString(@"Drop_Location", nil)];
    [locationLbl setText:JJLocalizedString(@"Select Drop Location", nil)];
    [dropTimeHeaderLbl setText:JJLocalizedString(@"Drop_Time", nil)];
    [timeLbl setText:JJLocalizedString(@"Select_Drop_Time", nil)];
    [waitHeaderLbl setText:JJLocalizedString(@"Waiting_Time",nil)];
    [disHeaderLbl setText:JJLocalizedString(@"Ride_Distance_km", nil)];
    [distanceTxtField setPlaceholder:JJLocalizedString(@"Enter_Distance", nil)];
    [hourWaitTxtField setText:JJLocalizedString(@"Hours", nil)];
    [minWaitTxtField setText:JJLocalizedString(@"Minutes", nil)];
    [endTripBtn setTitle:JJLocalizedString(@"End_Trip", nil) forState:UIControlStateNormal];
    
    
    
    
    
    headerLbl=[Theme setHeaderFontForLabel:headerLbl];
    locHeaderLbl=[Theme setNormalFontForLabel:locHeaderLbl];
    dropTimeHeaderLbl=[Theme setNormalFontForLabel:dropTimeHeaderLbl];
    waitHeaderLbl=[Theme setNormalFontForLabel:waitHeaderLbl];
    disHeaderLbl=[Theme setNormalFontForLabel:disHeaderLbl];

    distanceTxtField=[Theme setNormalFontForTextfield:distanceTxtField];
    hourWaitTxtField=[Theme setNormalFontForTextfield:hourWaitTxtField];
    minWaitTxtField=[Theme setNormalFontForTextfield:minWaitTxtField];
    
    locationLbl=[Theme setNormalFontForLabel:locationLbl];
    timeLbl=[Theme setNormalFontForLabel:timeLbl];
    waitingTimeLbl=[Theme setNormalFontForLabel:waitingTimeLbl];
    
    
    endTripBtn=[Theme setBoldFontForButton:endTripBtn];
    
  //  endTripBtn.layer.cornerRadius=2;
   // endTripBtn.layer.masksToBounds=YES;
    
    NSString * str=[Theme checkNullValue:[Theme getCurrentDistanceString]];
    if([str isEqualToString:@""]){
        str=@"km";
    }
    NSString * RideDistance=JJLocalizedString(@"Ride_Distance", nil);
    
    disHeaderLbl.text=[NSString stringWithFormat:@"%@ (%@)",RideDistance,str];
    [self setMandatoryField];
      scrollView.contentSize=CGSizeMake(scrollView.frame.size.width, distanceTxtField.frame.origin.y+distanceTxtField.frame.size.height+80);
    NSArray *fields = @[ distanceTxtField, hourWaitTxtField, minWaitTxtField];
    
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
    hourWaitTxtField.layer.borderWidth=0.5;
    hourWaitTxtField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    minWaitTxtField.layer.borderWidth=0.5;
    minWaitTxtField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
}
-(void)setMandatoryField{
    for (UIView *subview in scrollView.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            UILabel * lbl=(UILabel *)subview;
            
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"MandatoryImg"];
                
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:lbl.text];
                [myString appendAttributedString:attachmentString];
                
                lbl.attributedText = myString;
            
        }else if ([subview isKindOfClass:[UITextField class]]){
            UITextField * txtField=(UITextField *)subview;
            if([txtField isEqual:distanceTxtField]){
                UIView *   arrow = [[UILabel alloc] init];
                arrow.frame = CGRectMake(0, 0,20, 20);
                
                arrow.contentMode = UIViewContentModeScaleToFill;
                txtField.leftView = arrow;
                txtField.leftViewMode = UITextFieldViewModeAlways;
            }
        }
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
    [scrollView setContentOffset:CGPointMake(0.0,textField.frame.origin.y-100) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resetView];
    return YES;
}
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
     [self resetView];
   
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location == 0 && [string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}
-(void)resetView{
    if(hourWaitTxtField.text.length==0){
        hourWaitTxtField.text=JJLocalizedString(@"Hours", nil);
    }
    if (minWaitTxtField.text.length==0) {
        minWaitTxtField.text=JJLocalizedString(@"Minutes", nil);
    }
    [self.view endEditing:YES];
    [distanceTxtField resignFirstResponder];
    [hourWaitTxtField resignFirstResponder];
    [minWaitTxtField resignFirstResponder];
    if(IS_IPHONE_4_OR_LESS){
        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
        [self.scrollView setContentOffset:bottomOffset animated:YES];
    }else{
          [scrollView setContentOffset:CGPointMake(0.0,0) animated:YES];
    }
}
   

- (IBAction)didClickLocationBtn:(id)sender {
   [self resetView];
    LocationSearchViewController * objLocSearchVc=[self.storyboard instantiateViewControllerWithIdentifier:@"LocationSearchVCSID"];
    objLocSearchVc.delegate=self;
    [self.navigationController pushViewController:objLocSearchVc animated:YES];
}

- (IBAction)didClickDropTimeBtn:(id)sender {
   [self resetView];
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:JJLocalizedString(@"Select_Drop_Time", nil) delegate:self];
    
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDateTimePicker];
     [picker setMaximumDate:[NSDate date]];
    [picker show];
    
   
}
- (void)actionSheetPickerViewDidCancel:(IQActionSheetPickerView *)pickerView;{
    [self resetView];
}
-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
   [self resetView];
    if([Theme isEndDateIsSmallerThanCurrent:date]){
        if(date!=nil){
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
            timeLbl.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];

        }
       
    }else{
        [self.view makeToast:@"Please_select_valid_Drop_time"];
        
    }
    
    
}
- (IBAction)didClickWaitTimeBtn:(id)sender {
    [self resetView];
}

- (IBAction)didClickEndTrip:(id)sender {
    [self resetView];
    if ([self validateAndMoveToNextPage]) {
        endTripBtn.userInteractionEnabled=NO;
        [self showActivityIndicator:YES];
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [web DriverEndRide:[self setParametersDriverEndRide]
                   success:^(NSMutableDictionary *responseDictionary)
         {
             
             [self stopActivityIndicator];
             if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
                 [self.view makeToast:@"Ride_Finished"];
                 NSDictionary * summaryDict=responseDictionary[@"response"][@"fare_details"];
                 FareRecords * objFareRecrds=[[FareRecords alloc]init];
                 objFareRecrds.currency=[Theme findCurrencySymbolByCode:[Theme checkNullValue:[summaryDict objectForKey:@"currency"]]];
                 
                 objFareRecrds.rideDistance=[Theme checkNullValue:[summaryDict objectForKey:@"ride_distance"]];
                 objFareRecrds.rideDuration=[Theme checkNullValue:[summaryDict objectForKey:@"ride_duration"]];
                 objFareRecrds.rideFare=[Theme checkNullValue:[NSString stringWithFormat:@"%.02f",[[summaryDict objectForKey:@"ride_fare"] floatValue]]];
                 objFareRecrds.waitingDuration=[Theme checkNullValue:[summaryDict objectForKey:@"waiting_duration"]];
                 objFareRecrds.needPayment=[Theme checkNullValue:[summaryDict objectForKey:@"need_payment"]];
                 objFareRecrds.needCash = [Theme checkNullValue:[responseDictionary[@"response"] objectForKey:@"receive_cash"]];
                 currencyCodeAndAmount=[NSString stringWithFormat:@"%@ %@",objFareRecrds.currency,objFareRecrds.rideFare];
                 controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FareSummaryVCSID"];
                 //controller.view.frame=self.view.frame;
                 controller.objFareRecs=[[FareRecords alloc]init];
                 [controller setObjFareRecs:objFareRecrds];
                 controller.delegate=self;
                 [controller presentInParentViewController:self];
                 
             }else{
                 endTripBtn.userInteractionEnabled=YES;
                 [self.view makeToast:[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"response"]]];
             }
         }
                   failure:^(NSError *error)
         {
             endTripBtn.userInteractionEnabled=YES;
             [self stopActivityIndicator];
             [self.view makeToast:kErrorMessage];
             
         }];
    }
}

- (IBAction)didClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sendLocation:(NSString *)locStr{
    locationLbl.text=locStr;
}
-(BOOL)validateAndMoveToNextPage{
    if([locationLbl.text isEqualToString:JJLocalizedString(@"Select_Drop_Location", nil)]){
        [self showErrorMessage:@"Please_Select_Drop_Location"];
        return NO;
    }else if ([timeLbl.text isEqualToString:JJLocalizedString(@"Select_Drop_Time",nil)]){
        [self showErrorMessage:@"Please_Select_Drop_Time"];
        return NO;
    }else if (distanceTxtField.text.length==0){
        [self showErrorMessage:@"Please_Enter_Distance"];
        return NO;
    }
    return YES;
}

-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:@"Oops !!!" message:JJLocalizedString(str, nil)];
    [notice show];
}

-(NSDictionary *)setParametersDriverEndRide{
    NSString * driverId=@"";
    NSString * hourStr=[Theme checkNullValue:hourWaitTxtField.text];
      NSString * minStr=[Theme checkNullValue:minWaitTxtField.text];
    if([hourWaitTxtField.text isEqualToString:JJLocalizedString(@"Hours", nil)]){
        hourStr=@"00";
    }
    if([minWaitTxtField.text isEqualToString:JJLocalizedString(@"Minutes", nil)]){
        minStr=@"00";
    }
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
   
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"ride_id":rideID,
                                  @"interrupted":@"YES",
                                  @"drop_loc":[Theme checkNullValue:locationLbl.text],
                                  @"drop_time":[Theme checkNullValue:timeLbl.text],
                                  @"distance":[Theme checkNullValue:distanceTxtField.text],
                                  @"wait_time":[NSString stringWithFormat:@"%@:%@:00",hourStr,minStr]
                                  };
    return dictForuser;
}
-(void)moveToNextVc:(NSInteger )index{
    if(index==1){
        CashOTPViewController * objCashOtpController=[self.storyboard instantiateViewControllerWithIdentifier:@"CashOTPVCSID"];
        [objCashOtpController setRideId:rideID];
        [self.navigationController pushViewController:objCashOtpController animated:YES];
    }else if (index==0){
        [controller.view makeToast:@"Please_wait_until_transaction"];
        [self sendrequestForPayment];
    }else if (index==2){
        [self sendrequestForNoPayment];
    }
}
-(void)sendrequestForPayment{
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web requestForPayment:[self setParametersForPaymentRequest]
                   success:^(NSMutableDictionary *responseDictionary)
     {
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
            // [controller.view makeToast:@"Please wait until transaction is complete. Don't minimize or go back"];
             PaymentWaitingViewController * objPayWait=[self.storyboard instantiateViewControllerWithIdentifier:@"PaymentWaitingVCSID"];
             [objPayWait setRideIdPay:rideID];
             [self.navigationController pushViewController:objPayWait animated:YES];
         }else{
             [self stopActivityIndicator];
             [controller.view makeToast:kErrorMessage];
         }
     }
                   failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [controller.view makeToast:kErrorMessage];
         
     }];
}
-(void)sendrequestForNoPayment{
    RatingsViewController * objRatingsVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingsVCSID"];
    [objRatingsVc setRideid:rideID];
    [self.navigationController pushViewController:objRatingsVc animated:YES];
 
//    [self showActivityIndicator:YES];
//    UrlHandler *web = [UrlHandler UrlsharedHandler];
//    [web NoNeedPayment:[self setParametersForPaymentRequest]
//               success:^(NSMutableDictionary *responseDictionary)
//     {
//         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
//             RatingsViewController * objRatingsVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingsVCSID"];
//             [objRatingsVc setRideid:rideID];
//             [self.navigationController pushViewController:objRatingsVc animated:YES];
//         }else{
//             [self stopActivityIndicator];
//             [controller.view makeToast:kErrorMessage];
//         }
//     }
//               failure:^(NSError *error)
//     {
//         [self stopActivityIndicator];
//         [controller.view makeToast:kErrorMessage];
//         
//     }];
}

-(NSDictionary *)setParametersForPaymentRequest{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"ride_id":rideID
                                  };
    return dictForuser;
}


@end
