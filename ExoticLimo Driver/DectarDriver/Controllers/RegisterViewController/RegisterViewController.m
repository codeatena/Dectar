//
//  RegisterViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/21/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "RegisterViewController.h"
#import "WBErrorNoticeView.h"
#import "IQActionSheetPickerView.h"

@interface RegisterViewController ()<IQActionSheetPickerViewDelegate>

@end

@implementation RegisterViewController
@synthesize basicView,locationLbl,categoryLbl,userImageView,scrollView,imagePicker,objRegRecs,driveCatMainArray,driveMainLocArray,LocNamearr,catNameArr;
- (void)viewDidLoad {
    [super viewDidLoad];
    objRegRecs=[[RegistrationRecords alloc]init];
    [self setMandatoryField];
    [self setFontAndColor];
}

-(void)setFontAndColor{
    
    _headerLbl=[Theme setHeaderFontForLabel:_headerLbl];
    _driveLocHeaderLbl=[Theme setBoldFontForLabel:_driveLocHeaderLbl];
     _DriverCatgHeaderLbl=[Theme setBoldFontForLabel:_DriverCatgHeaderLbl];
    locationLbl=[Theme setNormalFontForLabel:locationLbl];
    categoryLbl=[Theme setNormalFontForLabel:categoryLbl];
    userImageView.layer.cornerRadius=userImageView.frame.size.width/2;
    userImageView.layer.masksToBounds=YES;
    userImageView.layer.borderWidth=1;
    userImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width, categoryLbl.frame.origin.y+categoryLbl.frame.size.height+80);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickLocationBtn:(id)sender {
    [self getDriverLocation];
    
}

- (IBAction)didClickCategoryBtn:(id)sender {
    if(objRegRecs.driverLocationId.length==0){
          [self showErrorMessage:@"Please select driver location before selecting category"];
    }else{
        [self getDriverCategory];
    }
   
}

- (IBAction)didClickUserImageBtn:(id)sender {
    if(TARGET_IPHONE_SIMULATOR)
    {
        imagePicker=[[UIImagePickerController alloc]init];
        imagePicker.delegate=self;
        imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [imagePicker setAllowsEditing:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload image from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Gallery", @"Camera", nil];
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
   
        if(buttonIndex==0){
            imagePicker=[[UIImagePickerController alloc]init];
            imagePicker.delegate=self;
            imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [imagePicker setAllowsEditing:YES];
            if(IS_OS_8_OR_LATER)
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Place image picker on the screen
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }];
            }
            else
            {
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }else if (buttonIndex==1){
            imagePicker=[[UIImagePickerController alloc]init];
            imagePicker.delegate=self;
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            [imagePicker setAllowsEditing:YES];
            if(IS_OS_8_OR_LATER)
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Place image picker on the screen
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }];
            }
            else
            {
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
  
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    image=[Theme imageWithImage:image scaledToSize:CGSizeMake(500, 500)];
    [userImageView setImage:image forState:UIControlStateNormal];
    NSString * imgStr=[self encodeToBase64String:image];
    [self uploadDriverImage:imgStr];
    
}

-(void)uploadDriverImage:(NSString *)driveImgStr{
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web sendDriverImage:[self parameterForImg:driveImgStr]
           success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             objRegRecs.driverImage=[Theme checkNullValue:[[responseDictionary objectForKey:@"response"] objectForKey:@"image_name"]];
             
         
             [self.view makeToast:@"Image uploaded successfully"];
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
-(NSDictionary *) parameterForImg:(NSString *)str{
    //    NSString * driverId=@"";
    //    if([Theme UserIsLogin]){
    //        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
    //        driverId=[myDictionary objectForKey:@"driver_id"];
    //    }
    NSDictionary *dictForuser = @{
                                  @"image":str
                                  };
    return dictForuser;
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (IBAction)didClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickForwardBtn:(id)sender {
    if(self.custIndicatorView.isAnimating){
        [self.view makeToast:@"Please wait... image uploading is on progress"];
    }else{
        if([self validateAndMoveToNextPage]){
            LoginDetailsViewController * objLoginDetails=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginDetailsVCSID"];
            [objLoginDetails setObjRegRecs:objRegRecs];
            [self.navigationController pushViewController:objLoginDetails animated:YES];
        }
    }
    
   
}
-(BOOL)validateAndMoveToNextPage{
    
    if(objRegRecs.driverLocationId.length==0){
      [self showErrorMessage:@"Please select Driver Location"];
        return NO;
    }else if (objRegRecs.driverCategoryId.length==0){
       [self showErrorMessage:@"Please select Driver Category"];
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
            if([lbl isEqual:_driveLocHeaderLbl]||[lbl isEqual:_DriverCatgHeaderLbl]){
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
-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:JJLocalizedString(@"Error !!!", nil) message:JJLocalizedString(str, nil) ];
    [notice show];
}


-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles{
    if (pickerView.tag==1) {
        NSString * str=[Theme checkNullValue:[titles lastObject]];
        if(str.length>0){
           [locationLbl setText:[Theme checkNullValue:str]];
            if([LocNamearr containsObject:str]){
                for (int i =0; i<[LocNamearr count]; i++) {
                    NSString * loSt=[Theme checkNullValue:[LocNamearr objectAtIndex:i]];
                    DriverLoRecords * objDrecs=[[DriverLoRecords alloc]init];
                    objDrecs=[driveMainLocArray objectAtIndex:i];
                    if([loSt isEqualToString:objDrecs.LocName]){
                        objRegRecs.driverLocationId=objDrecs.locId;
                        objRegRecs.driverCategoryId=@"";
                        categoryLbl.text=@"Select_Driver_Category";
                        break;
                    }
                }
            }
        }else{
            [self.view makeToast:@"Unable_to_select_location"];
        }
        
    }
    else if (pickerView.tag==2){
        NSString * str=[Theme checkNullValue:[titles lastObject]];
        if(str.length>0){
            [categoryLbl setText:[Theme checkNullValue:str]];
            if([catNameArr containsObject:str]){
                for (int i =0; i<[catNameArr count]; i++) {
                    NSString * loSt=[Theme checkNullValue:[catNameArr objectAtIndex:i]];
                    DriverLoRecords * objDrecs=[[DriverLoRecords alloc]init];
                    objDrecs=[driveCatMainArray objectAtIndex:i];
                    if([loSt isEqualToString:objDrecs.catName]){
                        objRegRecs.driverCategoryId=objDrecs.catId;
                        break;
                    }
                }
            }
        }else{
            [self.view makeToast:@"Unable_to_select_driver_category"];
        }
    }
}



-(void)getDriverLocation{
    
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getDriverLocations:nil
                    success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             
             NSArray * locArr=responseDictionary[@"response"][@"locations"];
             LocNamearr = [[NSMutableArray alloc]init];
             if([locArr count]>0){
                 driveMainLocArray=[[NSMutableArray alloc]init];
                 for(NSDictionary * locDict in locArr){
                     DriverLoRecords * objDrivRecs=[[DriverLoRecords alloc]init];
                     objDrivRecs.locId=[Theme checkNullValue:[locDict objectForKey:@"id"]];
                     objDrivRecs.LocName=[Theme checkNullValue:[locDict objectForKey:@"city"]];
                     [driveMainLocArray addObject:objDrivRecs];
                     [LocNamearr addObject:objDrivRecs.LocName];
                     
                 }
                 IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Select Driver Location" delegate:self];
                 [picker setTag:1];
                 [picker setTitlesForComponenets:@[LocNamearr]];
                 [picker show];
             }else{
                  [self.view makeToast:@"No Locations Found"];
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

-(void)getDriverCategory{
    if (objRegRecs.driverLocationId.length>0) {
        [self showActivityIndicator:YES];
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [web getDriverCategory:[self parameterForCategory]
                       success:^(NSMutableDictionary *responseDictionary)
         {
             [self stopActivityIndicator];
             if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
                 
                 NSArray * locArr=responseDictionary[@"response"][@"category"];
                 catNameArr = [[NSMutableArray alloc]init];
                 if([locArr count]>0){
                     driveCatMainArray=[[NSMutableArray alloc]init];
                     for(NSDictionary * locDict in locArr){
                         DriverLoRecords * objDrivRecs=[[DriverLoRecords alloc]init];
                         objDrivRecs.catId=[Theme checkNullValue:[locDict objectForKey:@"id"]];
                         objDrivRecs.catName=[Theme checkNullValue:[locDict objectForKey:@"category"]];
                         [driveCatMainArray addObject:objDrivRecs];
                         [catNameArr addObject:objDrivRecs.catName];
                         
                     }
                     IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Select driver category" delegate:self];
                     [picker setTag:2];
                     [picker setTitlesForComponenets:@[catNameArr]];
                     [picker show];
                 }else{
                     [self.view makeToast:@"No Category Found"];
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
    }else{
        [self showErrorMessage:@"Please select Location before selecting the driver category"];
    }
    
    
}

-(NSDictionary *) parameterForCategory{
//    NSString * driverId=@"";
//    if([Theme UserIsLogin]){
//        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
//        driverId=[myDictionary objectForKey:@"driver_id"];
//    }
    NSDictionary *dictForuser = @{
                                  @"location_id":objRegRecs.driverLocationId
                                  };
    return dictForuser;
}
@end
