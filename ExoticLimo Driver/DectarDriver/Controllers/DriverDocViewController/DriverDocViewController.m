//
//  DriverDocViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/8/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "DriverDocViewController.h"

@interface DriverDocViewController ()

@end

@implementation DriverDocViewController
@synthesize saveBtn,scrollView,
activeSegmentControl,headerLbl,
driverDocHeaderLbl,
vehDocHeaderLbl,
policeVerLbl,
drivLicLbl,
drivExpLbl,
certOfRegLbl,
insuranceLbl,
statuslbl,imagePicker,selectedBtn,insuranceBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFont];
    
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width, insuranceBtn.frame.origin.y+insuranceBtn.frame.size.height+80);
    // Do any additional setup after loading the view.
}
-(void)setFont{
    [self getAllImageViewInsideScroll];
    saveBtn=[Theme setBoldFontForButton:saveBtn];
    [saveBtn setBackgroundColor:SetThemeColor];
    saveBtn.layer.cornerRadius=2;
    saveBtn.layer.masksToBounds=YES;
    
    headerLbl=[Theme setHeaderFontForLabel:headerLbl];
    driverDocHeaderLbl=[Theme setBoldFontForLabel:driverDocHeaderLbl];
    vehDocHeaderLbl=[Theme setBoldFontForLabel:vehDocHeaderLbl];
    policeVerLbl=[Theme setNormalFontForLabel:policeVerLbl];
    drivLicLbl=[Theme setNormalFontForLabel:drivLicLbl];
    drivExpLbl=[Theme setNormalFontForLabel:drivExpLbl];
    certOfRegLbl=[Theme setNormalFontForLabel:certOfRegLbl];
    insuranceLbl=[Theme setNormalFontForLabel:insuranceLbl];
    statuslbl=[Theme setNormalFontForLabel:statuslbl];
}
-(void)getAllImageViewInsideScroll{
    for (UIView *subview in scrollView.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            UIButton * imageView=(UIButton *)subview;
           // [imageView setImage:[UIImage imageNamed:@"PlaceHolderImg"]forState:UIControlStateNormal];
            imageView.layer.borderWidth=1;
            imageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
            imageView.layer.cornerRadius=8;
            imageView.layer.masksToBounds=YES;
            UILabel * lbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 52, imageView.frame.size.width-20, 27)];
            [imageView addSubview:lbl];
            [lbl setText:@"Tap to upload"];
            [lbl setTextColor:SetDarkBlueColor];
            [lbl setTextAlignment:NSTextAlignmentCenter];
            lbl.font=[UIFont systemFontOfSize:12];
            lbl.backgroundColor =setTransparentBlack;
            lbl.layer.cornerRadius=3;
            lbl.layer.masksToBounds=YES;
            [imageView bringSubviewToFront:lbl];
        }
    }
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

- (IBAction)didClickmageSelect:(id)sender {
    UIButton * btn=sender;
    selectedBtn=btn;
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
    }else{
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
    [selectedBtn setImage:image forState:UIControlStateNormal];
}
- (IBAction)didClickForwardBtn:(id)sender {
}

- (IBAction)didClickRewindBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
