//
//  BankingInfoViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/11/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "BankingInfoViewController.h"

@interface BankingInfoViewController ()

@end

@implementation BankingInfoViewController
@synthesize headerLbl,scrollView,accUserNameLbl,userNameTxtField,accUserAddressLbl,accAddressTxtView,accNumberLbl,accNumberText,branchNameLbl,branchNameTxtField,branchAddressLbl,branchAddressTxtview,ifscLbl,
ifscTxtField,routingLbl,routingTxtField,saveBtn,bankNameLbl,bankNameTxtField,saveView;

+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"BankingInfoVCSID"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kDriverCashPaymentNotifWhenQuit
                                               object:nil];

    scrollView.hidden=YES;
    saveView.hidden=YES;
    [self setFont];
    [self getDatasForBanking];
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
-(void)getDatasForBanking{
    
    
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getBankingData:[self setParametersForGetBank]
                 success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             scrollView.hidden=NO;
             saveView.hidden=NO;
             BankingRecords * objBankingRecs=[[BankingRecords alloc]init];
             NSDictionary * dict=responseDictionary[@"response"][@"banking"];
             objBankingRecs.accUserName=[Theme checkNullValue:dict[@"acc_holder_name"]];
             objBankingRecs.accUserAddress=[Theme checkNullValue:dict[@"acc_holder_address"]];
             objBankingRecs.accBankName=[Theme checkNullValue:dict[@"bank_name"]];
             objBankingRecs.accBranchName=[Theme checkNullValue:dict[@"branch_name"]];
             objBankingRecs.accNumber=[Theme checkNullValue:dict[@"acc_number"]];
             objBankingRecs.accBranchAddress=[Theme checkNullValue:dict[@"branch_address"]];
             objBankingRecs.accIfscCode=[Theme checkNullValue:dict[@"swift_code"]];
             objBankingRecs.accRoutingNumber=[Theme checkNullValue:dict[@"routing_number"]];
             [self setDatasToFields:objBankingRecs];
         }else{
             self.view.userInteractionEnabled=YES;
             [self.view makeToast:kErrorMessage];
         }
     }
                 failure:^(NSError *error)
     {
         self.view.userInteractionEnabled=YES;
         [self stopActivityIndicator];
         [self.view makeToast:kErrorMessage];
         
     }];
}
-(NSDictionary *)setParametersForGetBank{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId
                                  };
    return dictForuser;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
}
-(void)setFont{
    headerLbl=[Theme setHeaderFontForLabel:headerLbl];
    accUserNameLbl=[Theme setNormalFontForLabel:accUserNameLbl];
    accUserAddressLbl=[Theme setNormalFontForLabel:accUserAddressLbl];
    accNumberLbl=[Theme setNormalFontForLabel:accNumberLbl];
    branchNameLbl=[Theme setNormalFontForLabel:branchNameLbl];
    branchAddressLbl=[Theme setNormalFontForLabel:branchAddressLbl];
    ifscLbl=[Theme setNormalFontForLabel:ifscLbl];
    routingLbl=[Theme setNormalFontForLabel:routingLbl];
    bankNameLbl=[Theme setNormalFontForLabel:bankNameLbl];
    bankNameTxtField=[Theme setNormalFontForTextfield:bankNameTxtField];
    userNameTxtField=[Theme setNormalFontForTextfield:userNameTxtField];
    accNumberText=[Theme setNormalFontForTextfield:accNumberText];
    branchNameTxtField=[Theme setNormalFontForTextfield:branchNameTxtField];
    ifscTxtField=[Theme setNormalFontForTextfield:ifscTxtField];
    routingTxtField=[Theme setNormalFontForTextfield:routingTxtField];
    
    
    branchAddressTxtview=[Theme setNormalFontForTextView:branchAddressTxtview];
    accAddressTxtView=[Theme setNormalFontForTextView:accAddressTxtView];
    
    saveBtn=[Theme setBoldFontForButton:saveBtn];
   
    saveBtn.layer.cornerRadius=2;
    saveBtn.layer.masksToBounds=YES;
    
    
    branchAddressTxtview.layer.cornerRadius=3;
    branchAddressTxtview.layer.borderWidth=1;
    branchAddressTxtview.layer.borderColor=setLightGray.CGColor;
    branchAddressTxtview.layer.masksToBounds=YES;
    branchAddressTxtview.textContainer.lineFragmentPadding = 20;
    
    accAddressTxtView.layer.cornerRadius=3;
    accAddressTxtView.layer.borderWidth=1;
    accAddressTxtView.layer.borderColor=setLightGray.CGColor;
    accAddressTxtView.layer.masksToBounds=YES;
    accAddressTxtView.textContainer.lineFragmentPadding = 20;
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width, routingTxtField.frame.origin.y+routingTxtField.frame.size.height+80);
    
    [headerLbl setText:JJLocalizedString(@"BANK_ACCOUNT", nil)];
    [saveBtn setTitle:JJLocalizedString(@"SAVE", nil) forState:UIControlStateNormal];
    [accUserNameLbl setText:JJLocalizedString(@"Account_Holder_Name", nil)];
    [accUserAddressLbl setText:JJLocalizedString(@"Account_Holder_Address", nil)];
    [accNumberLbl setText:JJLocalizedString(@"Account_Number", nil)];
    [bankNameLbl setText:JJLocalizedString(@"Bank_Name", nil)];
    [branchNameLbl setText:JJLocalizedString(@"Branch_Name", nil)];
    [branchAddressLbl setText:JJLocalizedString(@"Branch_Address", nil)];
    [ifscLbl setText:JJLocalizedString(@"SWIFT_IFSC_code", nil)];
    [routingLbl setText:JJLocalizedString(@"Routing_Number", nil)];



    
    
    [self setMandatoryField];
    
}
-(UITextField *)leftPadding:(UITextField *)txtField withImageName:(NSString *)imgName{
    
    return txtField;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField isEqual:userNameTxtField]){
        [scrollView setContentOffset:CGPointMake(0.0, 0) animated:YES];
    }else{
        [scrollView setContentOffset:CGPointMake(0.0,textField.frame.origin.y-100) animated:YES];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
    [self.scrollView setContentOffset:bottomOffset animated:YES];
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
      [scrollView setContentOffset:CGPointMake(0.0,textView.frame.origin.y-100) animated:YES];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location == 0 && [string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location == 0 && [text isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

-(void)setMandatoryField{
    for (UIView *subview in scrollView.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            UILabel * lbl=(UILabel *)subview;
            if(![lbl isEqual:routingLbl]){
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"MandatoryImg"];
                
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:lbl.text];
                [myString appendAttributedString:attachmentString];
                
                lbl.attributedText = myString;
            }
            
        }else if ([subview isKindOfClass:[UITextField class]]){
             UITextField * txtField=(UITextField *)subview;
            UIView *   arrow = [[UILabel alloc] init];
            arrow.frame = CGRectMake(0, 0,20, 20);
            		
            arrow.contentMode = UIViewContentModeScaleToFill;
            txtField.leftView = arrow;
            txtField.leftViewMode = UITextFieldViewModeAlways;
            txtField.layer.cornerRadius=3;
            txtField.layer.borderWidth=1;
            txtField.layer.borderColor=setLightGray.CGColor;
            txtField.layer.masksToBounds=YES;
        }
    }
    
}

- (IBAction)didClickSaveBtn:(id)sender {
    if([self validateTxtFields]){
        [self.view endEditing:YES];
        self.view.userInteractionEnabled=NO;
        [self showActivityIndicator:YES];
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [web saveBankingData:[self setParametersForSaveBank]
                  success:^(NSMutableDictionary *responseDictionary)
         {
              self.view.userInteractionEnabled=YES;
             [self stopActivityIndicator];
             if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
                 BankingRecords * objBankingRecs=[[BankingRecords alloc]init];
                 NSDictionary * dict=responseDictionary[@"response"][@"banking"];
                 objBankingRecs.accUserName=[Theme checkNullValue:dict[@"acc_holder_name"]];
                  objBankingRecs.accUserAddress=[Theme checkNullValue:dict[@"acc_holder_address"]];
                  objBankingRecs.accBankName=[Theme checkNullValue:dict[@"bank_name"]];
                  objBankingRecs.accBranchName=[Theme checkNullValue:dict[@"branch_name"]];
                  objBankingRecs.accNumber=[Theme checkNullValue:dict[@"acc_number"]];
                  objBankingRecs.accBranchAddress=[Theme checkNullValue:dict[@"branch_address"]];
                 objBankingRecs.accIfscCode=[Theme checkNullValue:dict[@"swift_code"]];
                 objBankingRecs.accRoutingNumber=[Theme checkNullValue:dict[@"routing_number"]];
                  [self setDatasToFields:objBankingRecs];
                 [self.view makeToast:@"Bank_account_information"];
             }else{
                 self.view.userInteractionEnabled=YES;
                 [self.view makeToast:kErrorMessage];
             }
         }
                  failure:^(NSError *error)
         {
             self.view.userInteractionEnabled=YES;
             [self stopActivityIndicator];
             [self.view makeToast:kErrorMessage];
             
         }];
    }
}
-(void)setDatasToFields:(BankingRecords *)objBankingRecs{
    userNameTxtField.text=objBankingRecs.accUserName;
    accNumberText.text=objBankingRecs.accNumber;
    branchNameTxtField.text=objBankingRecs.accBranchName;
    ifscTxtField.text=objBankingRecs.accIfscCode;
    routingTxtField.text=objBankingRecs.accRoutingNumber;
    bankNameTxtField.text=objBankingRecs.accBankName;
    accAddressTxtView.text=objBankingRecs.accUserAddress;
    branchAddressTxtview.text=objBankingRecs.accBranchAddress;
}

-(NSDictionary *)setParametersForSaveBank{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"acc_holder_name":userNameTxtField.text,
                                  @"acc_holder_address":accAddressTxtView.text,
                                  @"acc_number":accNumberText.text,
                                  @"bank_name":bankNameTxtField.text,
                                  @"branch_name":branchNameTxtField.text,
                                  @"branch_address":branchAddressTxtview.text,
                                  @"swift_code":ifscTxtField.text,
                                  @"routing_number":[Theme checkNullValue:routingTxtField.text],
                                  };
    return dictForuser;
}
-(BOOL)validateTxtFields{
    if(userNameTxtField.text.length==0){
        [self showErrorMessage:@"Account_Holder_Name_cannot_be_empty"];
        return NO;
    }else if (accAddressTxtView.text.length==0){
        [self showErrorMessage:@"Account_Holder_Address_cannot_be_empty"];
        return NO;
    }
    else if (accNumberText.text.length==0){
        [self showErrorMessage:@"Account_Number_cannot_be_empty"];
        return NO;
    }
    else if (bankNameTxtField.text.length==0){
        [self showErrorMessage:@"Bank_Name_cannot_be_empty"];
        return NO;
    }
    else if (branchNameTxtField.text.length==0){
        [self showErrorMessage:@"Branch_Name_cannot_be_empty"];
        return NO;
    }
    else if (branchAddressTxtview.text.length==0){
        [self showErrorMessage:@"Branch_Address_cannot_be_empty"];
        return NO;
    }
    else if (ifscTxtField.text.length==0){
        [self showErrorMessage:@"SWIFT_IFSC_cannot_be_empty"];
        return NO;
    }
    
    return YES;
}
-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:@"Oops !!!" message:JJLocalizedString(str, nil)];
    [notice show];
}
- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
