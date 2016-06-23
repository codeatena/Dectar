//
//  VehicleInfoViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/8/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "VehicleInfoViewController.h"
#import "IQActionSheetPickerView.h"

@interface VehicleInfoViewController ()<IQActionSheetPickerViewDelegate>

@end

@implementation VehicleInfoViewController
@synthesize vehInfoHeaderLbl,
headerLbl,
vehicleTypeLbl,
vehicleMakerLbl,
vehicleModelLbl,vehNumTxtField,scrollView,airConditionLbl,airConditionSegment,objRegRecs,vehListMainArr,vehListArr,vehMakerMainArr,vehMakerArr,vehModelMainArr,vehModelArr,vehYearMainArr,vehYearArr,yearLbl,saveBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMandatoryField];
    [self setFontAndColor];
    //objRegRecs=[[RegistrationRecords alloc]init];
    // Do any additional setup after loading the view.
}
-(void)setFontAndColor{
    [self setPlaceHolderColor];
    saveBtn=[Theme setBoldFontForButton:saveBtn];
    [saveBtn setBackgroundColor:SetThemeColor];
    saveBtn.layer.cornerRadius=2;
    saveBtn.layer.masksToBounds=YES;
    headerLbl=[Theme setHeaderFontForLabel:headerLbl];
    vehInfoHeaderLbl=[Theme setBoldFontForLabel:vehInfoHeaderLbl];
    vehNumTxtField=[Theme setNormalFontForTextfield:vehNumTxtField];
    vehicleTypeLbl=[Theme setNormalFontForLabel:vehicleTypeLbl];
    vehicleMakerLbl=[Theme setNormalFontForLabel:vehicleMakerLbl];
    vehicleModelLbl=[Theme setNormalFontForLabel:vehicleModelLbl];
    airConditionLbl=[Theme setNormalFontForLabel:airConditionLbl];
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width, airConditionLbl.frame.origin.y+airConditionLbl.frame.size.height+70);
   
}
-(void)setMandatoryField{
    for (UIView *subview in scrollView.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            UILabel * lbl=(UILabel *)subview;
            if([lbl isEqual:vehInfoHeaderLbl]){
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
-(void)setPlaceHolderColor{
    [self setPlaceHolder:vehNumTxtField withText:@"Vehicle Number" withImage:@"AddressEdit"];
    
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
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  
        [scrollView setContentOffset:CGPointMake(0.0,textField.frame.origin.y-100) animated:YES];
  
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(IS_IPHONE_6P){
        [scrollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];
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

- (IBAction)didChangeAirConditionSegment:(id)sender {
    
}

- (IBAction)didClickVehType:(id)sender {
    [self.view endEditing:YES];
    [self getVehicleList];
}

- (IBAction)didClickVehMaker:(id)sender {
     [self.view endEditing:YES];
    [self getVehicleMaker];
}

- (IBAction)didClickVehModel:(id)sender {
     [self.view endEditing:YES];
    if(objRegRecs.driverVehTypeId.length==0){
        [self showErrorMessage:@"Please select vehicle type"];
    }else if (objRegRecs.driverVehMakerId.length==0){
          [self showErrorMessage:@"Please select vehicle maker"];
    }else{
        [self getVehicleModelList];
    }
    
}

- (IBAction)didClickRewindBtn:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickForwardBtn:(id)sender {
    [self.view endEditing:YES];
    objRegRecs.driverVehNumber=[Theme checkNullValue:vehNumTxtField.text];
    if(airConditionSegment.selectedSegmentIndex == 0)
    {
       objRegRecs.driverAircCondition=@"Yes";
    }else{
        objRegRecs.driverAircCondition=@"No";
    }
    if([self validateFields]){
        [self registerDriver];
    }
    
}
-(BOOL)validateFields{
    if(objRegRecs.driverVehTypeId.length==0){
        [self showErrorMessage:@"Please select vehicle type"];
        return NO;
    }else if (objRegRecs.driverVehMakerId.length==0){
        [self showErrorMessage:@"Please select vehicle maker"];
        return NO;
    }
    else if (objRegRecs.driverVehModelId.length==0){
        [self showErrorMessage:@"Please select vehicle model"];
        return NO;
    }
    else if (objRegRecs.driverVehYear.length==0){
        [self showErrorMessage:@"Please select make year"];
        return NO;
    }
    else if (objRegRecs.driverVehNumber.length==0){
        [self showErrorMessage:@"Please enter vehicle number"];
        return NO;
    }
    else if (objRegRecs.driverAircCondition.length==0){
        [self showErrorMessage:@"Please select aircondition status"];
        return NO;
    }
    return YES;
}

-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:@"Error !!!" message:str];
    [notice show];
}
- (IBAction)didClickVehicleYear:(id)sender {
    [self.view endEditing:YES];
    if(objRegRecs.driverVehTypeId.length==0){
        [self showErrorMessage:@"Please select vehicle type"];
    }else if (objRegRecs.driverVehMakerId.length==0){
        [self showErrorMessage:@"Please select vehicle maker"];
    }
    else if (objRegRecs.driverVehModelId.length==0){
        [self showErrorMessage:@"Please select vehicle model"];
    }else{
        [self getVehicleYearList];
    }
}

-(void)getVehicleList{
    
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getVehicleList:[self parameterForCategory]
                    success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             
             NSArray * locArr=responseDictionary[@"response"][@"vehicle"];
             vehListArr = [[NSMutableArray alloc]init];
             if([locArr count]>0){
                 vehListMainArr=[[NSMutableArray alloc]init];
                 for(NSDictionary * locDict in locArr){
                     DriverLoRecords * objDrivRecs=[[DriverLoRecords alloc]init];
                     objDrivRecs.vehTypeId=[Theme checkNullValue:[locDict objectForKey:@"id"]];
                     objDrivRecs.vehType=[Theme checkNullValue:[locDict objectForKey:@"vehicle_type"]];
                     [vehListMainArr addObject:objDrivRecs];
                     [vehListArr addObject:objDrivRecs.vehType];
                     
                 }
                 IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Select Vehicle Type" delegate:self];
                 [picker setTag:4];
                 [picker setTitlesForComponenets:@[vehListArr]];
                 [picker show];
             }else{
                 [self.view makeToast:@"No Vehicles found"];
             }
             
             
             
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
-(NSDictionary *) parameterForCategory{
    //    NSString * driverId=@"";
    //    if([Theme UserIsLogin]){
    //        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
    //        driverId=[myDictionary objectForKey:@"driver_id"];
    //    }
    NSDictionary *dictForuser = @{
                                  @"category_id":objRegRecs.driverCategoryId
                                  };
    return dictForuser;
}



-(void)getVehicleMaker{
    
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getVehicleMakerList:nil
                success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             
             NSArray * locArr=responseDictionary[@"response"][@"maker"];
             vehMakerArr = [[NSMutableArray alloc]init];
             if([locArr count]>0){
                 vehMakerMainArr=[[NSMutableArray alloc]init];
                 for(NSDictionary * locDict in locArr){
                     DriverLoRecords * objDrivRecs=[[DriverLoRecords alloc]init];
                     objDrivRecs.vehMakerID=[Theme checkNullValue:[locDict objectForKey:@"id"]];
                     objDrivRecs.vehMaker=[Theme checkNullValue:[locDict objectForKey:@"brand_name"]];
                     [vehMakerMainArr addObject:objDrivRecs];
                     [vehMakerArr addObject:objDrivRecs.vehMaker];
                     
                 }
                 IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Select Vehicle Type" delegate:self];
                 [picker setTag:5];
                 [picker setTitlesForComponenets:@[vehMakerArr]];
                 [picker show];
             }else{
                 [self.view makeToast:@"No Vehicle Maker found"];
             }
             
             
             
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



-(void)getVehicleModelList{
    
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getVehicleModelList:[self parameterForVahModel]
                success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             
             NSArray * locArr=responseDictionary[@"response"][@"model"];
             vehModelArr = [[NSMutableArray alloc]init];
             if([locArr count]>0){
                 vehModelMainArr=[[NSMutableArray alloc]init];
                 for(NSDictionary * locDict in locArr){
                     DriverLoRecords * objDrivRecs=[[DriverLoRecords alloc]init];
                     objDrivRecs.vehModelId=[Theme checkNullValue:[locDict objectForKey:@"id"]];
                     objDrivRecs.vehModel=[Theme checkNullValue:[locDict objectForKey:@"name"]];
                     [vehModelMainArr addObject:objDrivRecs];
                     [vehModelArr addObject:objDrivRecs.vehModel];
                     
                 }
                 IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Select Vehicle Model" delegate:self];
                 [picker setTag:6];
                 [picker setTitlesForComponenets:@[vehModelArr]];
                 [picker show];
             }else{
                 [self.view makeToast:@"No Vehicles model found"];
             }
             
             
             
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
-(NSDictionary *) parameterForVahModel{
    //    NSString * driverId=@"";
    //    if([Theme UserIsLogin]){
    //        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
    //        driverId=[myDictionary objectForKey:@"driver_id"];
    //    }
    NSDictionary *dictForuser = @{
                                  @"vehicle_id":objRegRecs.driverVehTypeId,
                                  @"maker_id":objRegRecs.driverVehMakerId
                                  };
    return dictForuser;
}


-(void)getVehicleYearList{
    
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getVehicleYearList:[self parameterForVehYear]
                     success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             
             NSArray * locArr=responseDictionary[@"response"][@"model"];
             vehYearArr = [[NSMutableArray alloc]init];
             if([locArr count]>0){
                 vehYearMainArr=[[NSMutableArray alloc]init];
                 for(NSString * locDict in locArr){
                     DriverLoRecords * objDrivRecs=[[DriverLoRecords alloc]init];
                     objDrivRecs.vehYearId=[Theme checkNullValue:locDict];
                     objDrivRecs.vehYear=[Theme checkNullValue:locDict];
                     [vehYearMainArr addObject:objDrivRecs];
                     [vehYearArr addObject:objDrivRecs.vehYear];
                     
                 }
                 IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Select Vehicle Model" delegate:self];
                 [picker setTag:7];
                 [picker setTitlesForComponenets:@[vehYearArr]];
                 [picker show];
             }else{
                 [self.view makeToast:@"No Vehicles model found"];
             }
             
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
-(NSDictionary *) parameterForVehYear{
    //    NSString * driverId=@"";
    //    if([Theme UserIsLogin]){
    //        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
    //        driverId=[myDictionary objectForKey:@"driver_id"];
    //    }
    NSDictionary *dictForuser = @{
                                  @"model_id":objRegRecs.driverVehModelId
                                  };
    return dictForuser;
}



-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles{
    if (pickerView.tag==4) {
        NSString * str=[Theme checkNullValue:[titles lastObject]];
        if(str.length>0){
            [vehicleTypeLbl setText:[Theme checkNullValue:str]];
            if([vehListArr containsObject:str]){
                for (int i =0; i<[vehListArr count]; i++) {
                    NSString * loSt=[Theme checkNullValue:[vehListArr objectAtIndex:i]];
                    DriverLoRecords * objDrecs=[[DriverLoRecords alloc]init];
                    objDrecs=[vehListMainArr objectAtIndex:i];
                    if([loSt isEqualToString:objDrecs.vehType]){
                        objRegRecs.driverVehTypeId=objDrecs.vehTypeId;
                        objRegRecs.driverVehMakerId=@"";
                        objRegRecs.driverVehModelId=@"";
                        objRegRecs.driverVehYear=@"";
                        vehicleMakerLbl.text=@"Select Vehicle Maker";
                        vehicleModelLbl.text=@"Select Vehicle Model";
                        yearLbl.text=@"Select Make Year";
                        break;
                    }
                }
            }
        }else{
            [self.view makeToast:@"Unable to select Vehicle Type"];
        }
        
    }
    
    else if (pickerView.tag==5) {
        NSString * str=[Theme checkNullValue:[titles lastObject]];
        if(str.length>0){
            [vehicleMakerLbl setText:[Theme checkNullValue:str]];
            if([vehMakerArr containsObject:str]){
                for (int i =0; i<[vehMakerArr count]; i++) {
                    NSString * loSt=[Theme checkNullValue:[vehMakerArr objectAtIndex:i]];
                    DriverLoRecords * objDrecs=[[DriverLoRecords alloc]init];
                    objDrecs=[vehMakerMainArr objectAtIndex:i];
                    if([loSt isEqualToString:objDrecs.vehMaker]){
                        objRegRecs.driverVehMakerId=objDrecs.vehMakerID;
                        objRegRecs.driverVehModelId=@"";
                        objRegRecs.driverVehYear=@"";
                        vehicleModelLbl.text=@"Select Vehicle Model";
                        yearLbl.text=@"Select Make Year";
                        break;
                    }
                }
            }
        }else{
            [self.view makeToast:@"Unable to select Vehicle Maker"];
        }
    }
    else if (pickerView.tag==6) {
        NSString * str=[Theme checkNullValue:[titles lastObject]];
        if(str.length>0){
            [vehicleModelLbl setText:[Theme checkNullValue:str]];
            if([vehModelArr containsObject:str]){
                for (int i =0; i<[vehModelArr count]; i++) {
                    NSString * loSt=[Theme checkNullValue:[vehModelArr objectAtIndex:i]];
                    DriverLoRecords * objDrecs=[[DriverLoRecords alloc]init];
                    objDrecs=[vehModelMainArr objectAtIndex:i];
                    if([loSt isEqualToString:objDrecs.vehModel]){
                        objRegRecs.driverVehModelId=objDrecs.vehModelId;
                        objRegRecs.driverVehYear=@"";
                        yearLbl.text=@"Select Make Year";
                        break;
                    }
                }
            }
        }else{
            [self.view makeToast:@"Unable to select Vehicle Model"];
        }
        
    }
    else if (pickerView.tag==7) {
        NSString * str=[Theme checkNullValue:[titles lastObject]];
        if(str.length>0){
            [yearLbl setText:[Theme checkNullValue:str]];
            if([vehYearArr containsObject:str]){
                for (int i =0; i<[vehYearArr count]; i++) {
                    NSString * loSt=[Theme checkNullValue:[vehYearArr objectAtIndex:i]];
                    DriverLoRecords * objDrecs=[[DriverLoRecords alloc]init];
                    objDrecs=[vehYearMainArr objectAtIndex:i];
                    if([loSt isEqualToString:objDrecs.vehYear]){
                        objRegRecs.driverVehYear=objDrecs.vehYear;
                        break;
                    }
                }
            }
        }else{
            [self.view makeToast:@"Unable to select year"];
        }
        
    }
    
}

#pragma mark Final Registration
-(void)registerDriver{
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web RegistrationDriverByApp:[self parameterForReg]
                 success:^(NSMutableDictionary *responseDictionary)
     {
        
         [self stopActivityIndicator];
         
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             
             @try {
                 TAlertView *alert = [[TAlertView alloc] initWithTitle:[Theme project_getAppName]
                                                               message:[Theme checkNullValue:[responseDictionary objectForKey:@"response"]]
                                                               buttons:@[@"OK"]
                                                           andCallBack:^(TAlertView *alertView, NSInteger buttonIndex) {
                                                               [self.navigationController popToRootViewControllerAnimated:YES];
                                                           }];
                 alert.buttonsAlign = TAlertViewButtonsAlignHorizontal;
                 [alert showAsMessage];
             }
             @catch (NSException *exception) {
                 
             }
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
-(NSDictionary *) parameterForReg{
    //    NSString * driverId=@"";
    //    if([Theme UserIsLogin]){
    //        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
    //        driverId=[myDictionary objectForKey:@"driver_id"];
    //    }
    NSDictionary *dictForuser = @{
                                  @"driver_location":[Theme checkNullValue:objRegRecs.driverLocationId],
                                   @"category":[Theme checkNullValue:objRegRecs.driverCategoryId],
                                   @"driver_name":[Theme checkNullValue:objRegRecs.driverName],
                                  @"email":[Theme checkNullValue:objRegRecs.driverEmail],
                                  @"password":[Theme checkNullValue:objRegRecs.driverPassword],
                                   @"address":[Theme checkNullValue:objRegRecs.driverAddress],
                                   @"county":[Theme checkNullValue:objRegRecs.driverCountry],
                                  @"state":[Theme checkNullValue:objRegRecs.driverState],
                                  @"city":[Theme checkNullValue:objRegRecs.driverCity],
                                   @"postal_code":[Theme checkNullValue:objRegRecs.driverPostalCode],
                                  @"dail_code":[Theme checkNullValue:objRegRecs.driverCountryCode],
                                  @"mobile_number":[Theme checkNullValue:objRegRecs.driverMobileNumber],
                                   @"mobile_otp":[Theme checkNullValue:objRegRecs.driverMobileNumberOTP],
                                   @"vehicle_type":[Theme checkNullValue:objRegRecs.driverVehTypeId],
                                   @"vehicle_maker":[Theme checkNullValue:objRegRecs.driverVehMakerId],
                                   @"vehicle_model":[Theme checkNullValue:objRegRecs.driverVehModelId],
                                   @"vehicle_model_year":[Theme checkNullValue:objRegRecs.driverVehYear],
                                   @"vehicle_number":[Theme checkNullValue:objRegRecs.driverVehNumber],
                                  @"image":[Theme checkNullValue:objRegRecs.driverImage],
                                   @"ac":[Theme checkNullValue:objRegRecs.driverAircCondition]
                                  };
    return dictForuser;
}

@end
