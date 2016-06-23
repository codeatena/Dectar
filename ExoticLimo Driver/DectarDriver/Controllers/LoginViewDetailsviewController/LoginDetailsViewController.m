//
//  LoginDetailsViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/8/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "LoginDetailsViewController.h"
#import "WBErrorNoticeView.h"

@interface LoginDetailsViewController ()

@end

@implementation LoginDetailsViewController
@synthesize loginDetHeaderLbl,driverNameTxtField,emailTxtField,passwordTxtField,conFirmPasswordTxtField,scrollView,objRegRecs;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setMandatoryField];
    [self setFontAndColor];
    // Do any additional setup after loading the view.
}
-(void)setMandatoryField{
    for (UIView *subview in scrollView.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            UILabel * lbl=(UILabel *)subview;
            if([lbl isEqual:loginDetHeaderLbl]){
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
    _headerLbl=[Theme setHeaderFontForLabel:_headerLbl];
    loginDetHeaderLbl=[Theme setBoldFontForLabel:loginDetHeaderLbl];
    driverNameTxtField=[Theme setNormalFontForTextfield:driverNameTxtField];
     emailTxtField=[Theme setNormalFontForTextfield:emailTxtField];
     passwordTxtField=[Theme setNormalFontForTextfield:passwordTxtField];
     conFirmPasswordTxtField=[Theme setNormalFontForTextfield:conFirmPasswordTxtField];
}
-(void)setPlaceHolderColor{
    [self setPlaceHolder:driverNameTxtField withText:@"Driver Name" withImage:@"UserName"];
    [self setPlaceHolder:emailTxtField withText:@"Email" withImage:@"EmailImg"];
    [self setPlaceHolder:passwordTxtField withText:@"Password" withImage:@"PasswordLock"];
    [self setPlaceHolder:conFirmPasswordTxtField withText:@"Confirm Password" withImage:@"PassConfirm"];
}
-(void)setPlaceHolder:(UITextField *)txtField withText:(NSString *)text withImage:(NSString *)imgName{
    if ([txtField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    txtField=[self leftPadding:txtField withImageName:imgName];
}
-(UITextField *)leftPadding:(UITextField *)txtField withImageName:(NSString *)imgName{
    UIView *   arrow = [[UILabel alloc] init];
    arrow.frame = CGRectMake(0, 0,50, 50);
    UIImageView *   Img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    Img.frame = CGRectMake(10, 10,30, 30);
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
    if([textField isEqual:driverNameTxtField]){
        [scrollView setContentOffset:CGPointMake(0.0, 0) animated:YES];
    }else{
        [scrollView setContentOffset:CGPointMake(0.0,textField.frame.origin.y-100) animated:YES];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0.0, 0) animated:YES];
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

- (IBAction)didClickRewindBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickNextBtn:(id)sender {
    
    objRegRecs.driverName=driverNameTxtField.text;
    objRegRecs.driverEmail=emailTxtField.text;
    objRegRecs.driverPassword=passwordTxtField.text;
    objRegRecs.driverConfirmPassword=conFirmPasswordTxtField.text;
    if([self validateFields]){
        AddressDetailsViewController * objAddressDetails=[self.storyboard instantiateViewControllerWithIdentifier:@"AddressDetailsVCSID"];
        [objAddressDetails setObjRegRecs:objRegRecs];
        [self.navigationController pushViewController:objAddressDetails animated:YES];
    }
}

-(BOOL)validateFields{
    if(objRegRecs.driverName.length==0){
        [self showErrorMessage:@"Please enter Driver Name"];
        return NO;
    }else if (objRegRecs.driverEmail.length==0){
        [self showErrorMessage:@"Please enter Email"];
        return NO;
    }
    else if (![Theme NSStringIsValidEmail:objRegRecs.driverEmail]){
        [self showErrorMessage:@"Please enter valid Email"];
        return NO;
    }
    else if (objRegRecs.driverPassword.length==0){
        [self showErrorMessage:@"Please enter Password"];
        return NO;
    }
    else if (objRegRecs.driverConfirmPassword.length==0){
        [self showErrorMessage:@"Please enter Confirm Password"];
        return NO;
    }
    else if (![objRegRecs.driverConfirmPassword isEqualToString:objRegRecs.driverPassword]){
        [self showErrorMessage:@"Confirm Password doesnot matches the Password"];
        return NO;
    }
    return YES;
}
-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:@"Oops !!!" message:str];
    [notice show];
}

@end
