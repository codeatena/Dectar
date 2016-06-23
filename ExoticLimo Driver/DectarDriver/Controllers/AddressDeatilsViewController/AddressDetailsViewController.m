//
//  AddressDetailsViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/8/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "AddressDetailsViewController.h"
#import "IQActionSheetPickerView.h"
#import "WBErrorNoticeView.h"
@interface AddressDetailsViewController () <IQActionSheetPickerViewDelegate,countryStateDelegate>

@end

@implementation AddressDetailsViewController
@synthesize headerLbl,addressHeaderLbl,addressTxtField,countryLbl,stateTxtField,cityTxtField,postalCodeTxtField,countryCodeTxtField,mobileNoTxtField,scrollView,objRegRecs,OTPTxtField,countryNameArr,countryMainArr,otpStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMandatoryField];
   // objRegRecs=[[RegistrationRecords alloc]init];
    [self setFontAndColor];
    // Do any additional setup after loading the view.

}
-(void)setMandatoryField{
    for (UIView *subview in scrollView.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            UILabel * lbl=(UILabel *)subview;
            if([lbl isEqual:addressHeaderLbl]){
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"MandatoryBig"];
                
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:lbl.text];
                [myString appendAttributedString:attachmentString];
                
                lbl.attributedText = myString;
            }
        }
    }
    
}
-(void)setFontAndColor{
    [self setPlaceHolderColor];
    headerLbl=[Theme setHeaderFontForLabel:headerLbl];
    addressHeaderLbl=[Theme setBoldFontForLabel:addressHeaderLbl];
    addressTxtField=[Theme setNormalFontForTextfield:addressTxtField];
    stateTxtField=[Theme setNormalFontForTextfield:stateTxtField];
    cityTxtField=[Theme setNormalFontForTextfield:cityTxtField];
    postalCodeTxtField=[Theme setNormalFontForTextfield:postalCodeTxtField];
    countryCodeTxtField=[Theme setNormalFontForTextfield:countryCodeTxtField];
    mobileNoTxtField=[Theme setNormalFontForTextfield:mobileNoTxtField];
    OTPTxtField=[Theme setNormalFontForTextfield:OTPTxtField];
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width, OTPTxtField.frame.origin.y+OTPTxtField.frame.size.height+70);
}
-(void)setPlaceHolderColor{
    [self setPlaceHolder:addressTxtField withText:@"Address" withImage:@"AddressEdit"];
    [self setPlaceHolder:stateTxtField withText:@"State / Province / Region" withImage:@"AddressEdit"];
    [self setPlaceHolder:cityTxtField withText:@"City" withImage:@"AddressEdit"];
    [self setPlaceHolder:postalCodeTxtField withText:@"Postal code" withImage:@"AddressEdit"];
     [self setPlaceHolder:mobileNoTxtField withText:@"Mobile number" withImage:@"AddressEdit"];
    [self setPlaceHolder:countryCodeTxtField withText:@"+ 91" withImage:@""];
     [self setPlaceHolder:OTPTxtField withText:@"OTP" withImage:@"AddressEdit"];
}
-(void)setPlaceHolder:(UITextField *)txtField withText:(NSString *)text withImage:(NSString *)imgName{
    if ([txtField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    if(imgName.length>0){
         txtField=[self leftPadding:txtField withImageName:imgName];
    }
   
}
-(UITextField *)leftPadding:(UITextField *)txtField withImageName:(NSString *)imgName{
    UIView *   arrow = [[UILabel alloc] init];
    arrow.frame = CGRectMake(0, 0,50, 50);
    UIImageView *   Img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    Img.frame = CGRectMake(10, 20,20, 20);
    [arrow addSubview:Img];
    arrow.contentMode = UIViewContentModeScaleToFill;
    txtField.leftView = arrow;
    txtField.leftViewMode = UITextFieldViewModeAlways;
    return txtField;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location == 0 && [string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField isEqual:addressTxtField]){
        [scrollView setContentOffset:CGPointMake(0.0, 0) animated:YES];
    }else{
        [scrollView setContentOffset:CGPointMake(0.0,textField.frame.origin.y-100) animated:YES];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if([textField isEqual:addressTxtField] ||[textField isEqual:stateTxtField]){
          [scrollView setContentOffset:CGPointMake(0.0, 0) animated:YES];
    }else{
        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
        [self.scrollView setContentOffset:bottomOffset animated:YES];

    }
  
    return YES;
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

- (IBAction)didClickSelectCountryBtn:(id)sender {
    [self.view endEditing:YES];
    CountryStateViewController * objCountryVCSID=[self.storyboard instantiateViewControllerWithIdentifier:@"CountriesStateVCSID"];
    objCountryVCSID.delegate=self;
    [self.navigationController pushViewController:objCountryVCSID animated:YES];
   
}


- (IBAction)didClickRewindBtn:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickNextBtn:(id)sender {
    objRegRecs.driverAddress=addressTxtField.text;
    objRegRecs.driverState=stateTxtField.text;
    objRegRecs.driverCity= cityTxtField.text;
    objRegRecs.driverPostalCode=postalCodeTxtField.text;
    objRegRecs.driverMobileNumber=mobileNoTxtField.text;
    objRegRecs.driverMobileNumberOTP=OTPTxtField.text;
    if([self validateFields]){
      
        
        VehicleInfoViewController * objVehDetails=[self.storyboard instantiateViewControllerWithIdentifier:@"VehicleInfoVCSID"];
        [objVehDetails setObjRegRecs:objRegRecs];
        [self.navigationController pushViewController:objVehDetails animated:YES];
    }
}

- (IBAction)didClickOTPBtn:(id)sender {
    objRegRecs.driverMobileNumber=[Theme checkNullValue:mobileNoTxtField.text];
    if (objRegRecs.driverCountryCode.length==0){
        [self showErrorMessage:@"Please enter CountryCode"];
    }
    else if (objRegRecs.driverMobileNumber.length==0){
        [self showErrorMessage:@"Please enter Mobile Number"];
        
    }else{
        [self.view endEditing:YES];
        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
        [self.scrollView setContentOffset:bottomOffset animated:YES];
        [self getOtp];
    }
    
}
-(BOOL)validateFields{
    if(objRegRecs.driverAddress.length==0){
        [self showErrorMessage:@"Please enter Address"];
        return NO;
    }else if (objRegRecs.driverCountryCode.length==0){
        [self showErrorMessage:@"Please select Country"];
        return NO;
    }
    else if (objRegRecs.driverState.length==0){
        [self showErrorMessage:@"Please enter State / Province / Region"];
        return NO;
    }
    else if (objRegRecs.driverCity.length==0){
        [self showErrorMessage:@"Please enter City"];
        return NO;
    }
    else if (objRegRecs.driverPostalCode.length==0){
        [self showErrorMessage:@"Please enter Postal Code"];
        return NO;
    }
    else if (objRegRecs.driverCountryCode.length==0){
        [self showErrorMessage:@"Please enter CountryCode"];
        return NO;
    }
    else if (objRegRecs.driverMobileNumber.length==0){
        [self showErrorMessage:@"Please enter Mobile Number"];
        return NO;
    }
    else if (objRegRecs.driverMobileNumberOTP.length==0){
        [self showErrorMessage:@"Please enter OTP"];
        return NO;
    }else if (![objRegRecs.driverMobileNumberOTP isEqualToString:otpStr]){
        [self showErrorMessage:@"Please enter valid OTP"];
        return NO;
    }
    return YES;
}

-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:@"Error !!!" message:str];
    [notice show];
}

-(void)GetCountryAndStateInfo:(DriverLoRecords *)objRecs{
    if(objRecs.countryId.length>0){
        countryLbl.text=objRecs.countryName;
        objRegRecs.driverCountryId=objRecs.countryId;
        objRegRecs.driverCountryCode=objRecs.dialCode;
        objRegRecs.driverCountry=objRecs.countryName;
        countryCodeTxtField.text=[Theme checkNullValue:objRecs.dialCode];
    }else{
        [self.view makeToast:@"can't able to fetch country"];
    }
}

-(void)getOtp{
    
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getRegOtp:[self parameterForMobOtp]
                    success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             
           
             otpStr=[Theme checkNullValue:[responseDictionary objectForKey:@"otp"]];
             NSString * devStatus=[Theme checkNullValue:[responseDictionary objectForKey:@"otp_status"]];
             if([devStatus isEqualToString:@"development"]){
                 OTPTxtField.text=otpStr;
             }
               [self.view makeToast:[Theme checkNullValue:[responseDictionary objectForKey:@"response"]]];
         }else{
             
             [self.view makeToast:[Theme checkNullValue:[responseDictionary objectForKey:@"response"]]];
         }
     }
                    failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [self.view makeToast:kErrorMessage];
         
     }];
}
-(NSDictionary *) parameterForMobOtp{
    //    NSString * driverId=@"";
    //    if([Theme UserIsLogin]){
    //        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
    //        driverId=[myDictionary objectForKey:@"driver_id"];
    //    }
    NSDictionary *dictForuser = @{
                                  @"dail_code":objRegRecs.driverCountryCode,
                                  @"mobile_number" : objRegRecs.driverMobileNumber
                                  };
    return dictForuser;
}

@end
