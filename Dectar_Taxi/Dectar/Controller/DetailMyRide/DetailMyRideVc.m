//
//  DetailMyRideVc.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/26/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "DetailMyRideVc.h"
#import <CoreLocation/CoreLocation.h>
#import "UrlHandler.h"
#import "Themes.h"
#import "Blurview.h"
#import "Constant.h"
#import "RatingVC.h"
#import "DriverRecord.h"
#import "WebViewVC.h"
#import <MessageUI/MessageUI.h>
#import "NewTrackVC.h"
#import "CancelRideVC.h"
#import "PaymentVC.h"
#import "HelpVC.h"
@interface DetailMyRideVc ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate,UITextFieldDelegate>
{
    NSString * payment_Name,*paymnet_code;
    Blurview*bgView;
    NSString * Mobile_ID;
    NSString * statusCancel;
    NSString * Curerncysymbol;
    UIAlertView * AddTitlel;
    UITextField * title;
    UITextField * Email_fld,*ShareFld,*shareCountryCode;
    UIAlertView * EmailAlert,*ShareAlert;
    NSMutableArray * reasonArray;
    UITableView * reasontabl;
    DriverRecord *TrackObj;
    BOOL isCanceled;
    BOOL isVerified;
    NSString * resonID;
    NSIndexPath * _lastSelectedIndexPath;
    NSString * Display;
    GMSMarker * PickUP , *DropMarker;
    
    
}

@end

@implementation DetailMyRideVc
@synthesize CarDetailsLabel,RideIDlabel,StatusLabl,mapBGView,Addresslabel,dateandtime_label,distancelabel,durationlbl,waitinglbl,totalbill,totalpaid,DetailsView,addressObj,Latitude,longitude,googlemap,camera,StatusPay,PayBTn,paymentArry,paymnetTabel,Submit,paymentView,PaymentWebView,cancel_btn,TitleView,TrackCab,Drop_label,favourite,Scrolling,Mail_Btn,Repprt_btn,Coupon_Label,Wallet_usage,shareMyRide_btn,Status_Track,Status_Favour;
@synthesize Amount_txtFld,AmountTip_lbl,AddindTip_View,remove_btn,RemoveTip_View,Apply_tip,Drop_Latitude,Drop_longitude;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    TrackObj=[[DriverRecord alloc]init];
    paymentView.layer.cornerRadius = 5;
    paymentView.layer.masksToBounds = YES;
    
    _PanicBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    _PanicBtn.layer.shadowOpacity = 0.5;
    _PanicBtn.layer.shadowRadius = 2;
    _PanicBtn.layer.shadowOffset = CGSizeMake(5.0f,5.0f);
    
    PayBTn.layer.cornerRadius = 5;
    PayBTn.layer.shadowColor = [UIColor blackColor].CGColor;
    PayBTn.layer.shadowOpacity = 0.5;
    PayBTn.layer.shadowRadius = 2;
    PayBTn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    Mail_Btn.layer.cornerRadius = 5;
    Mail_Btn.layer.shadowColor = [UIColor blackColor].CGColor;
    Mail_Btn.layer.shadowOpacity = 0.5;
    Mail_Btn.layer.shadowRadius = 2;
    Mail_Btn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    Repprt_btn.layer.cornerRadius = 5;
    Repprt_btn.layer.shadowColor = [UIColor blackColor].CGColor;
    Repprt_btn.layer.shadowOpacity = 0.5;
    Repprt_btn.layer.shadowRadius = 2;
    Repprt_btn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    PaymentWebView.hidden=YES;
    
    cancel_btn.layer.cornerRadius = 5;
    cancel_btn.layer.shadowColor = [UIColor blackColor].CGColor;
    cancel_btn.layer.shadowOpacity = 0.5;
    cancel_btn.layer.shadowRadius = 2;
    cancel_btn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    TrackCab.layer.cornerRadius = 5;
    TrackCab.layer.shadowColor = [UIColor blackColor].CGColor;
    TrackCab.layer.shadowOpacity = 0.5;
    TrackCab.layer.shadowRadius = 2;
    TrackCab.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    shareMyRide_btn.layer.cornerRadius = 5;
    shareMyRide_btn.layer.shadowColor = [UIColor blackColor].CGColor;
    shareMyRide_btn.layer.shadowOpacity = 0.5;
    shareMyRide_btn.layer.shadowRadius = 2;
    shareMyRide_btn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
        
   // [PaymentWebView addSubview:cancel_btn];

//    [paymentView.layer setCornerRadius:30.0f];
    
    // border
    [paymentView.layer setBorderColor:[UIColor clearColor].CGColor];
    [paymentView.layer setBorderWidth:1.5f];
    
    // drop shadow
    [paymentView.layer setShadowColor:[UIColor whiteColor].CGColor];
    [paymentView.layer setShadowOpacity:0.8];
    [paymentView.layer setShadowRadius:3.0];
    [paymentView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [_Option_View.layer setShadowColor:[UIColor blackColor].CGColor];
    [_Option_View.layer setShadowOpacity:0.8];
    [_Option_View.layer setShadowRadius:3.0];
    [_Option_View.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    
    camera = [GMSCameraPosition cameraWithLatitude:Latitude
                                         longitude:longitude
                                              zoom:15];
    [googlemap animateToCameraPosition:camera];
    googlemap = [GMSMapView mapWithFrame:CGRectMake(0, 0, mapBGView.frame.size.width , mapBGView.frame.size.height) camera:camera];

    googlemap.userInteractionEnabled=NO;
    [mapBGView addSubview:googlemap];
    [Themes statusbarColor:self.view];
    
    paymnetTabel.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [Amount_txtFld setDelegate:self];
    
    [self setdatastoView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDismissSecondViewController)
                                                 name:@"SecondViewControllerDismissed"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Walletamountused)
                                                 name:@"WalletUsed"
                                               object:nil];
    
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_heading setText:JJLocalizedString(@"Ride_Details", nil)];
    
    [cancel_btn setTitle:JJLocalizedString(@"Cancel_Trip", nil) forState:UIControlStateNormal];
    [shareMyRide_btn setTitle:JJLocalizedString(@"Share_My_Ride", nil) forState:UIControlStateNormal];
    [TrackCab setTitle:JJLocalizedString(@"Track_Driver", nil) forState:UIControlStateNormal];
    [PayBTn setTitle:JJLocalizedString(@"Payment", nil) forState:UIControlStateNormal];
    
    [Mail_Btn setTitle:JJLocalizedString(@"Mail_Invoice", nil) forState:UIControlStateNormal];
    [Repprt_btn setTitle:JJLocalizedString(@"Report", nil) forState:UIControlStateNormal];
    
    [_hint_ride_distance setText:JJLocalizedString(@"ride_distance", nil)];
    [_hint_time_taken setText:JJLocalizedString(@"time_taken", nil)];
    [_hint_wait_time setText:JJLocalizedString(@"wait_time", nil)];
    
    [_hint_totalbill setText:JJLocalizedString(@"Total_Bill", nil)];
    [_hint_totaloaid setText:JJLocalizedString(@"Total_Paid", nil)];
    
    [remove_btn setTitle:JJLocalizedString(@"Remove", nil) forState:UIControlStateNormal];
    [Apply_tip setTitle:JJLocalizedString(@"Apply", nil) forState:UIControlStateNormal];
    
 }


-(IBAction)Panic_action:(id)sender
{
    HelpVC * ObjHelpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpVCID"];
    [self.navigationController pushViewController:ObjHelpVC animated:YES];
    
}

-(void)didDismissSecondViewController {
    [_Option_View setHidden:YES];
    [AddindTip_View setHidden:YES];
    [RemoveTip_View setHidden:YES];
}
-(void)Walletamountused
{
    [AddindTip_View setHidden:YES];
    [RemoveTip_View setHidden:YES];
    NSString * tipamount=JJLocalizedString(@"Tips_Amount", nil);
    
    _TipsAmount_lbl.text=[NSString stringWithFormat:@"%@%@%@",tipamount,Curerncysymbol,addressObj.Tip_Amount];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)BackTo:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setdatastoView
{
    PickUP=[[GMSMarker alloc]init];
    DropMarker=[[GMSMarker alloc]init];

    Curerncysymbol=[Themes findCurrencySymbolByCode:addressObj.Currency];
    CarDetailsLabel.text=addressObj.cab_type;
    RideIDlabel.text=addressObj.ride_id_detls;
    Display=addressObj.ride_status;
    
    StatusLabl.text=addressObj.DisPlay_status;
    
    NSString * Discount=JJLocalizedString(@"Coupon_Discount", nil);

    Coupon_Label.text=[NSString stringWithFormat:@"%@%@%@",Discount,Curerncysymbol,addressObj.Coupon_Discount];
    
    NSString * Usage=JJLocalizedString(@"Wallet_Usage", nil);

    Wallet_usage.text=[NSString stringWithFormat:@"%@%@%@",Usage,Curerncysymbol,addressObj.Wallet_usage];
    
    NSString * tipamount=JJLocalizedString(@"Tips_Amount", nil);

    _TipsAmount_lbl.text=[NSString stringWithFormat:@"%@%@%@",tipamount,Curerncysymbol,addressObj.Tip_Amount];
    Addresslabel.text=addressObj.location;
    NSString * pickup=JJLocalizedString(@"pick_up", nil);
    
    dateandtime_label.text=[NSString stringWithFormat:@"%@%@",pickup,addressObj.pickup_date];
    totalbill.text=[NSString stringWithFormat:@"%@%@",Curerncysymbol,addressObj.grand_Bill];
    totalpaid.text=[NSString stringWithFormat:@"%@%@",Curerncysymbol,addressObj.total_paid];
    longitude=[addressObj.lon floatValue];
    Latitude=[addressObj.lat floatValue];
    distancelabel.text=[NSString stringWithFormat:@"%@ %@",addressObj.ride_distance,addressObj.distance_unit];
    durationlbl.text=[NSString stringWithFormat:@"%@mins",addressObj.ride_duration];
    waitinglbl.text=[NSString stringWithFormat:@"%@mins",addressObj.waiting_duration];
    StatusPay=addressObj.payStatus;
    statusCancel=addressObj.CancelStatus;
    Status_Track=addressObj.Track_Status;
    Status_Favour=addressObj.Favourite_Status;
    
    Drop_Latitude=[addressObj.Drop_lat floatValue];
    Drop_longitude=[addressObj.Drop_lon floatValue];
    
    [self conditin:addressObj];
    
    
}
-(void)conditin:(MyRideRecord *)Str
{
    float lat;
    lat=Drop_longitude;
    if (lat > 0) {
        
        [self DirectionPath];
    }
    else
    {
        PickUP.position=CLLocationCoordinate2DMake(Latitude, longitude);
        PickUP.appearAnimation=kGMSMarkerAnimationPop;
        UIImage *markerIcon2 = [UIImage imageNamed:@"pin"];
        PickUP.icon = markerIcon2;
        PickUP.map = googlemap;

        camera = [GMSCameraPosition cameraWithLatitude:Latitude
                                             longitude:longitude
                                                  zoom:15];
        [googlemap animateToCameraPosition:camera];
    }
    
    float coupon;
    coupon=[Str.Coupon_Discount floatValue];
    if (coupon > 0)
    {
        Coupon_Label.hidden=NO;
    }
    else
    {
        Coupon_Label.hidden=YES;
    }
    
    coupon=[Str.Wallet_usage floatValue];
    if (coupon > 0)
    {
        Wallet_usage.hidden=NO;
    }
    else
    {
        Wallet_usage.hidden=YES;
    }
    
    if (![Str.drop_date isEqualToString:@""])
    {
        Drop_label.text=[NSString stringWithFormat:@"Drop: %@",Str.drop_date];
        
    }
    
    if ([Str.ride_status isEqualToString:@"Completed"]|| [Str.ride_status isEqualToString:@"Finished"])
    {
        DetailsView.hidden=NO;
    }
    else {
        DetailsView.hidden=YES;
        
    }
    if ([Str.ride_status isEqualToString:@"Completed"]) {
        Mail_Btn.hidden=NO;
        Repprt_btn.hidden=NO;
        favourite.hidden=NO;
        [AddindTip_View setHidden:YES];
        [RemoveTip_View setHidden:YES];
        [_Option_View setHidden:YES];
        Mail_Btn.frame=CGRectMake(Mail_Btn.frame.origin.x, DetailsView.frame.origin.y+DetailsView.frame.size.height+10, Mail_Btn.frame.size.width, Mail_Btn.frame.size.height);
        Repprt_btn.frame=CGRectMake(Repprt_btn.frame.origin.x, DetailsView.frame.origin.y+DetailsView.frame.size.height+10, Repprt_btn.frame.size.width, Repprt_btn.frame.size.height);
        
    }
    else {
        Mail_Btn.hidden=YES;
        Repprt_btn.hidden=YES;
        favourite.hidden=YES;

    }
    if ([Str.ride_status isEqualToString:@"Onride"]) {
    
        [_PanicBtn setHidden:NO];
    }
    if ([Str.Favourite_Status isEqualToString:@"1"])
    {
        //favourite.hidden=NO;
        [favourite setImage:[UIImage imageNamed:@"Nolike"] forState:UIControlStateNormal];
    }
    else
    {
        //favourite.hidden=NO;
        [favourite setImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];

    }
    if ([StatusPay isEqualToString:@"Pending"])
    {
        PayBTn.hidden=NO;
        [_Option_View setHidden:NO];
        [AddindTip_View setHidden:NO];
    }
    
    if ([statusCancel isEqualToString:@"1"])
    {
        cancel_btn.hidden=NO;
        
    }
    if ([Str.ride_status isEqualToString:@"Cancelled"])
    {
        StatusLabl.textColor=[UIColor redColor];
        [_Option_View setHidden:YES];
    }
    if ([Str.Track_Status isEqualToString:@"1"])
    {
        TrackCab.hidden=NO;
        shareMyRide_btn.hidden=NO;
    }
    else
    {
        TrackCab.hidden=YES;
        shareMyRide_btn.hidden=YES;

    }
    if (![Str.Tip_Amount isEqualToString:@"0"])
    {
        [AddindTip_View setHidden:YES];
        [RemoveTip_View setHidden:NO];
        NSString * Tip=JJLocalizedString(@"Tips_Amount", nil);
        
        AmountTip_lbl.text=[Themes writableValue:[NSString stringWithFormat:@"%@ %@%@",Tip,Curerncysymbol,Str.Tip_Amount]];
        [_TipsAmount_lbl setHidden:YES];
        

    }
    if ([StatusPay isEqualToString:@"Paid"]) {
        
        [AddindTip_View setHidden:YES];
        [RemoveTip_View setHidden:YES];
        [_TipsAmount_lbl setHidden:NO];
        [AmountTip_lbl setHidden:NO];



    }
    if ([StatusPay isEqualToString:@"Processing"])
    {
        PayBTn.hidden=NO;
        [AddindTip_View setHidden:YES];
        [RemoveTip_View setHidden:YES];
        [_TipsAmount_lbl setHidden:NO];
        [AmountTip_lbl setHidden:NO];

    }
    if (DetailsView.hidden==YES)
    {
        float y = [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - _Option_View.frame.size.height-40;
        [_Option_View setFrame:CGRectMake(0, y, _Option_View.frame.size.width, _Option_View.frame.size.height)];
       // _Option_View.frame=CGRectMake(0, DetailsView.frame.origin.y+DetailsView.frame.size.height-50, self.view.frame.size.width, 70);
    }
    else
    {
        float y = [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - _Option_View.frame.size.height-40;
        [_Option_View setFrame:CGRectMake(0, y, _Option_View.frame.size.width, _Option_View.frame.size.height)];
    }
    Scrolling.contentSize = CGSizeMake(self.Scrolling.frame.size.width, _Option_View.frame.origin.y+_Option_View.frame.size.height+150);
    
    

}
- (IBAction)Payment_mode:(id)sender {
    
    //[self listPayment];
    PaymentVC * PaymentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentVCID"];
    [PaymentVC setRideID:RideIDlabel.text];
    [self.navigationController pushViewController:PaymentVC animated:YES];

}
-(void)listPayment

{
    isCanceled=NO;
    
    Submit.backgroundColor=[UIColor lightGrayColor];
    Submit.userInteractionEnabled=NO;
    paymentArry=[NSMutableArray array];

    NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                               @"ride_id":RideIDlabel.text};
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
             
             if ([comfiramtion isEqualToString:@"1"])
             {
                 [Themes StopView:self.view];
                 
                 for (NSDictionary * objCatDict in responseDictionary[@"response"][@"payment"]) {
                     addressObj=[[MyRideRecord alloc]init];
                     addressObj.paymentname=[objCatDict valueForKey:@"name"];
                     addressObj.paymentCode =[objCatDict valueForKey:@"code"];
                     
                     [paymentArry addObject:addressObj];
                     
                 }
                 paymnetTabel.delegate=self;
                 paymnetTabel.dataSource=self;
                 TitleView.text=@"Payment Mode";
                 
                 [paymnetTabel reloadData];
                 
                 bgView=[[[NSBundle mainBundle] loadNibNamed:@"Blurview" owner:self options:nil] objectAtIndex:0];
                 bgView.frame=self.view.frame;
                 bgView.isNeed=NO;
                 [self.view addSubview:bgView];
                 [self.view addSubview:paymentView];
                 paymentView.hidden=NO;
                 
                 
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [paymentArry count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    /*if (paymentArry == nil || [paymentArry count] == 0)
    {
        if ( [paymentArry containsObject:indexPath]  )
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }*/
    
    NSIndexPath* selection = [tableView indexPathForSelectedRow];
    if (selection && selection.row == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    MyRideRecord *objRec=(MyRideRecord*)[paymentArry objectAtIndex:indexPath.row];
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 14.0 ];
    cell.textLabel.font  = myFont;
    cell.textLabel.text=objRec.paymentname;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   /* NSInteger catIndex = [paymentArry indexOfObject:addressObj];
    if (catIndex == indexPath.row) {
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:catIndex inSection:0];
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        addressObj = [paymentArry objectAtIndex:indexPath.row];
        
        payment_Name=addressObj.paymentname;
        paymnet_code=addressObj.paymentCode;
        
        Submit.backgroundColor=[UIColor orangeColor];
        Submit.userInteractionEnabled=YES;
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];*/
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    addressObj = [paymentArry objectAtIndex:indexPath.row];
    payment_Name=addressObj.paymentname;
    paymnet_code=addressObj.paymentCode;
    
    Submit.backgroundColor=[UIColor orangeColor];
    Submit.userInteractionEnabled=YES;
//    cell.accessoryType = (cell.accessoryType == UITableViewCellAccessoryCheckmark) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
   /* if (_lastSelectedIndexPath != nil)
    {
        UITableViewCell *lastSelectedCell = [tableView cellForRowAtIndexPath:_lastSelectedIndexPath];
        lastSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        payment_Name=addressObj.paymentname;
        paymnet_code=addressObj.paymentCode;
        
        Submit.backgroundColor=[UIColor orangeColor];
        Submit.userInteractionEnabled=YES;
    }
    _lastSelectedIndexPath = indexPath;*/
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_6) {
        return 59;
    }
    else if (IS_IPHONE_6P)
        return 69;
    return 40;
}
-(void)CloseBlurView
{
    [paymentView setHidden:YES];
    if (PaymentWebView.hidden==NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Warning !"
                                  message:@"If you Close the view your transcation will be cancelled"
                                  delegate:self
                                  cancelButtonTitle:@"CANCEL"
                                  otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}
- (IBAction)Submit_pay:(id)sender {
    
    UIButton *btnAuthOptions=(UIButton*)sender;
    if (btnAuthOptions.tag==1) {
        
        [bgView setHidden:YES];
        [paymentView setHidden:YES];
        if (isCanceled ==YES)
        {
            cancel_btn.hidden=NO;

        }
    } else if (btnAuthOptions.tag==2) {
        
        if (isCanceled==NO)
        {
            [self sumbitpaymethod];

        }
        else if (isCanceled==YES)
        {
            [self SubmitCancel];

        }
    }
}
-(void)sumbitpaymethod
{
    
    if ([paymnet_code isEqualToString:@"cash"])
    {
        NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                    @"ride_id":RideIDlabel.text};
        
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
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:JJLocalizedString(@"Your_Payment_successfully_finished", nil)   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     [AddindTip_View setHidden:YES];
                     [RemoveTip_View setHidden:YES];
                     [bgView setHidden:YES];
                     [paymentView setHidden:YES];
                     [paymnetTabel setHidden:YES];
                     [PayBTn setHidden:YES];
                     [TrackCab setHidden:YES];
                     [shareMyRide_btn setHidden:YES];

                     //[self dismissViewControllerAnimated:YES completion:nil];
                     
                     /* RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
                      [objLoginVC setRideID_Rating:RideIDlabel.text];
                      [self presentViewController:objLoginVC animated:YES completion:nil];*/
                     
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
    else if ([paymnet_code isEqualToString:@"wallet"])
    {
        NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                    @"ride_id":RideIDlabel.text};
        
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
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:JJLocalizedString(@"Your_Payment_successfully_finished", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     [bgView setHidden:YES];
                     [paymentView setHidden:YES];
                     
                      RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
                      [objLoginVC setRideID_Rating:RideIDlabel.text];
                     [self.navigationController pushViewController:objLoginVC animated:YES];

                     
                     
                 }
                 else if ([comfiramtion isEqualToString:@"2"])
                 {
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:JJLocalizedString(@"Your_Wallet_amount_successfully_used", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     [self listPayment];
                     [paymnetTabel reloadData];
                     [bgView setHidden:YES];
                     [paymentView setHidden:YES];
                     
                 }
                 
                 else if ([comfiramtion isEqualToString:@"0"])
                 {
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:JJLocalizedString(@"Your_wallet_is_empty", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     [self listPayment];
                     [paymnetTabel reloadData];
                     [bgView setHidden:YES];
                     [paymentView setHidden:YES];
                     
                     
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
                                    @"ride_id":RideIDlabel.text};
        
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
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:JJLocalizedString(@"Your_Payment_successfully_finished", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     /* [bgView setHidden:YES];
                      [paymentView setHidden:YES];*/
                     
                     RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
                     [objLoginVC setRideID_Rating:RideIDlabel.text];
                     [self.navigationController pushViewController:objLoginVC animated:YES];

                     
                 }
                 /* else if ([comfiramtion isEqualToString:@"2"])
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
    else
    {
        NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                    @"ride_id":RideIDlabel.text,
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
                     addfavour.FromComing=NO;
                     addfavour.parameters=Mobile_ID;
                     addfavour.Ride_ID=RideIDlabel.text;
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
    /*  else if ([paymnet_code isEqualToString:@"1"])
     {
     NSDictionary * parameters=@{@"user_id":[Themes getUserID],
     @"ride_id":RideIDlabel.text,
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
     addfavour.FromComing=NO;
     addfavour.parameters=Mobile_ID;
     addfavour.Ride_ID=RideIDlabel.text;
     [self presentViewController:addfavour animated:YES completion:nil];
     
     
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
     else if ([paymnet_code isEqualToString:@"2"])
     {
     NSDictionary * parameters=@{@"user_id":[Themes getUserID],
     @"ride_id":RideIDlabel.text,
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
     addfavour.FromComing=NO;
     addfavour.parameters=Mobile_ID;
     addfavour.Ride_ID=RideIDlabel.text;
     [self presentViewController:addfavour animated:YES completion:nil];
     
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
     }*/
    
}


#pragma mark -
#pragma mark UIWebViewDelegate

/*- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSURL *currentURL = [[webView request] URL];
    NSLog(@"%@",[currentURL description]);
    
    if ([[currentURL description] containsString:@"pay-failed"]) {
                 PaymentWebView.hidden=YES;
        [bgView setHidden:NO];
        [paymentView setHidden:NO];
    }
    else  if ([[currentURL description] containsString:@"pay-completed"])
    {
        [PaymentWebView setHidden:YES];
        [bgView setHidden:YES];
        [paymentView setHidden:YES];
        PayBTn.hidden=YES;
        RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
        [objLoginVC setRideID_Rating:RideIDlabel.text];
        [self presentViewController:objLoginVC animated:YES completion:nil];

    }
    
   else if ([[currentURL description] containsString:@"failed"]) {
        PaymentWebView.hidden=YES;
        [bgView setHidden:NO];
        [paymentView setHidden:NO];
    }
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[request description] containsString:@"pay-failed"]) {
        PaymentWebView.hidden=YES;
        [bgView setHidden:NO];
        [paymentView setHidden:NO];
    }
    else  if ([[request description] containsString:@"pay-completed"])
    {
        [PaymentWebView setHidden:YES];
        [bgView setHidden:YES];
        [paymentView setHidden:YES];
        PayBTn.hidden=YES;
        RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
        [objLoginVC setRideID_Rating:RideIDlabel.text];
        [self presentViewController:objLoginVC animated:YES completion:nil];

    }
  else  if ([[request description] containsString:@"Cancel"]) {
        PaymentWebView.hidden=YES;
        [bgView setHidden:NO];
        [paymentView setHidden:NO];
    }
    
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // report the error inside the webview
       
    PaymentWebView.hidden=YES;
    [bgView setHidden:NO];
    [paymentView setHidden:NO];
}*/
- (IBAction)CancelTrip:(id)sender
{
    /*cancel_btn.hidden=YES;
    isCanceled=YES;

    Submit.backgroundColor=[UIColor lightGrayColor];
    Submit.userInteractionEnabled=NO;
    paymentArry=[NSMutableArray array];
    NSDictionary * parameters=@{@"user_id":[Themes getUserID]};
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web CancelReason:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];

         if ([responseDictionary count]>0)
         {
             NSLog(@"%@",responseDictionary);
             responseDictionary=[Themes writableValue:responseDictionary];
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             
             if ([comfiramtion isEqualToString:@"1"])
             {
                 [Themes StopView:self.view];
                 
                 for (NSDictionary * objCatDict in responseDictionary[@"response"][@"reason"]) {
                     addressObj=[[MyRideRecord alloc]init];
                     addressObj.paymentname=[objCatDict valueForKey:@"reason"];
                     addressObj.paymentCode =[objCatDict valueForKey:@"id"];
                     resonID= addressObj.paymentCode;
                     [paymentArry addObject:addressObj];
                     
                 }
                 paymnetTabel.delegate=self;
                 paymnetTabel.dataSource=self;
                 
                 [paymnetTabel reloadData];
                 TitleView.text=@"Cancel Reason";
                 
                 bgView=[[[NSBundle mainBundle] loadNibNamed:@"Blurview" owner:self options:nil] objectAtIndex:0];
                 bgView.frame=self.view.frame;
                 bgView.isNeed=NO;
                 [self.view addSubview:bgView];
                 [self.view addSubview:paymentView];
                 paymentView.hidden=NO;
                 
                 
             }
             else
             {
                 
             }
             
         }
         
         //cancel_btn.hidden=NO;

     }
             failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];*/
    CancelRideVC * ObjCancelRideVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CancelRideVCID"];
    [ObjCancelRideVC setRide_ID:RideIDlabel.text];
    [self.navigationController pushViewController:ObjCancelRideVC animated:YES];


}
- ( void )SubmitCancel
{
    NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                @"ride_id":RideIDlabel.text,
                                @"reason":resonID};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web CancelRide:parameters success:^(NSMutableDictionary *responseDictionary)
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
                 NSString * message=[[responseDictionary valueForKey:@"response"] valueForKey:@"message"];

                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
                 
                /* AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 [del LogIn];*/
                 [self.navigationController popViewControllerAnimated:YES];

             }
             else
             {
                 NSString * message=[responseDictionary valueForKey:@"response"];

                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:[NSString stringWithFormat:JJLocalizedString(@"your_ride_already_cancelled", nil),message] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
                 [self.navigationController popViewControllerAnimated:YES];
             }
             
         }
         
         
         
     }
            failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
    
    
}
- (IBAction)TrackADriver:(id)sender {
    /*UIAlertView * alert=[[UIAlertView  alloc]initWithTitle:@"Thanks" message:@"We are under construction" delegate:nil cancelButtonTitle:@"Coming soon!" otherButtonTitles:nil, nil];
    [alert show];*/
    [self TrackaDriver];
}
-(void)TrackaDriver
{
    NSDictionary * parameters=@{@"ride_id":RideIDlabel.text};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web Track_Driver:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         NSLog(@"%@",responseDictionary);
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
             responseDictionary=[Themes writableValue:responseDictionary];
             NSString * comfiramtion=[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"status"]];
             [Themes StopView:self.view];
             
             if ([comfiramtion isEqualToString:@"1"])
             {
                 TrackObj.Driver_Name=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"driver_name"];
                 TrackObj.Car_Name=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"vehicle_model"];
                 TrackObj.Car_Number=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"vehicle_number"];
                 TrackObj.latitude_driver=[[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"driver_lat"] doubleValue];
                 TrackObj.longitude_driver=[[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"driver_lon"] doubleValue];
                 TrackObj.Driver_moblNumber=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"phone_number"];
                 TrackObj.ETA=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"min_pickup_duration"];
                 TrackObj.rating=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"driver_review"];
                 TrackObj.latitude_User=[addressObj.lat doubleValue];
                 TrackObj.longitude_User=[addressObj.lon doubleValue];
                 TrackObj.Ride_ID=[[responseDictionary valueForKey:@"response"]valueForKey:@"ride_id"];
                 TrackObj.message=[[responseDictionary valueForKey:@"response"]valueForKey:@"message"];
                 TrackObj.isCancel=NO;
                 TrackObj.DriverImage=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"driver_image"];;
                 TrackObj.Status=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"]valueForKey:@"ride_status"];
                 NSDictionary * Drop=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"]valueForKey:@"drop"];
                 if (![Drop count]<=0) {
                     TrackObj.Drop_latitude_User=[[[Drop valueForKey:@"latlong"]valueForKey:@"lat"] doubleValue];
                     TrackObj.Drop_longitude_User=[[[Drop valueForKey:@"latlong"]valueForKey:@"lon"] doubleValue];

                     
                 }
                 
                 /*NSString *coordinates = [NSString stringWithFormat:@"%@ Driver Will Arrive with in , %@ to your address", Message, TimeETA];
                  ConfrimNowAlert =[[UIAlertView alloc]initWithTitle:@"Success!" message:coordinates delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                  [ConfrimNowAlert show];
                  showinAlert=YES;*/
                 //TrackRideVC*objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"TrackRideVCID"];
                 NewTrackVC*objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
                 [objLoginVC setTrackObj:TrackObj];
                 [self.navigationController pushViewController:objLoginVC animated:YES];

             }
             else
             {
                 NSString * messageString=[responseDictionary valueForKey:@"response"];
                 NSString *titleStr = JJLocalizedString(@"Oops", nil);
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
                 
             }
             
         }
         
         
     }
     
             failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];

}
- (void)dismissAndPush:(UIViewController *)vc {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController pushViewController:vc animated:NO];
    }];
    
}
- (IBAction)Report_Action:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
         NSArray *usersTo = [NSArray arrayWithObject: [NSString stringWithFormat:@"%@",SupportMail] ];
        [composeViewController setToRecipients:usersTo];//@[@"info@zoplay.com"]
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setSubject:@""];
        [composeViewController setMessageBody:@"" isHTML:NO];
        [composeViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"Mail", nil) message:JJLocalizedString(@"please_config_your_mail_account", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
- (IBAction)addFavour:(id)sender {
    
    if ([addressObj.Favourite_Status isEqualToString:@"1"])
    {
        UIAlertView * AlreadyExits = [[UIAlertView alloc]
                     initWithTitle:@"Sorry\xF0\x9F\x9A\xAB"
                     message:JJLocalizedString(@"You_already_add_this_location", nil)
                     delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil, nil];
        [AlreadyExits show];
    }
    else
    {
        AddTitlel = [[UIAlertView alloc]
                     initWithTitle:JJLocalizedString(@"ENTER_YOUR_FAVORITE_ADDRESS", nil)
                     message:@""
                     delegate:self
                     cancelButtonTitle:JJLocalizedString(@"CANCEL", nil)
                     otherButtonTitles:JJLocalizedString(@"APPLY", nil), nil];
        [AddTitlel setAlertViewStyle:UIAlertViewStylePlainTextInput];
        title=[AddTitlel textFieldAtIndex:0];
        title.textAlignment=NSTextAlignmentCenter;
        [title setBorderStyle:UITextBorderStyleNone];
        [title setKeyboardType:UIKeyboardTypeEmailAddress];
        title.autocapitalizationType=NO;
        [AddTitlel show];
    }
    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==AddTitlel)
    {
        if (buttonIndex==1)
        {
            if ([title.text isEqualToString:@""])
            {
                UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Sorry\xF0\x9F\x9A\xAB" message:JJLocalizedString(@"Please_Enter_the_title_for_your_favorite", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [Alert show];
            }
        else
        {
            [self setFavourite];
        }
            
            
        }
    }
    else if (alertView==EmailAlert)
    {
        if (buttonIndex==1)
        {
            if (![self validateEmail:Email_fld.text])

            {
                UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Sorry\xF0\x9F\x9A\xAB" message:JJLocalizedString(@"Please_Enter_Valid_Email", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [Alert show];
                 isVerified=NO;
            }
            else
            {
                 isVerified=YES;
                [self Mail_Invoice];
            }
        }
    }
    else if (alertView==ShareAlert)
    {
        if (buttonIndex==1)
        {
            if ([ShareFld.text length]<=0)
            {
                UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Sorry\xF0\x9F\x9A\xAB" message:JJLocalizedString(@"Please_Enter_Mobile_Number", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [Alert show];
            }
            else
            {
                [self sendMSG];
            }
        }
    }
}
-(void)sendMSG
{
    NSDictionary * Parameter=@{@"ride_id":RideIDlabel.text,
                               @"mobile_no":ShareFld.text};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web ETAshare:Parameter success:^(NSMutableDictionary *responseDictionary) {
        
        NSLog(@"%@",responseDictionary);
        [Themes StopView:self.view];
        
        if ([responseDictionary count]>0)
        {
            responseDictionary=[Themes writableValue:responseDictionary];
            NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
            [Themes StopView:self.view];
            
            if ([comfiramtion isEqualToString:@"1"])
            {
                NSString * messageString=[responseDictionary valueForKey:@"response"];
                UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [Alert show];
                
                
            }
            else
            {
                NSString * messageString=[responseDictionary valueForKey:@"response"];
                NSString *titleStr = JJLocalizedString(@"Oops", nil);
                UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [Alert show];
                
            }
            
        }
    } failure:^(NSError *error) {
        [Themes StopView:self.view];

    }];
    
}
-(void)setFavourite
{
    
//    NSString*PicklatitudeStr=[NSString stringWithFormat:@"%f",Latitude];
//    NSString*PicklongitudeStr=[NSString stringWithFormat:@"%f",longitude];
    
    NSDictionary * parameters=@{@"title":title.text,
                                @"latitude":addressObj.lat,
                                @"longitude":addressObj.lon,
                                @"address":Addresslabel.text,
                                @"user_id":[Themes getUserID]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web SaveFavourite:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         NSLog(@"%@",responseDictionary);
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
             responseDictionary=[Themes writableValue:responseDictionary];
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             [Themes StopView:self.view];
             
             if ([comfiramtion isEqualToString:@"1"])
             {
                 NSString * messageString=[responseDictionary valueForKey:@"message"];
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
                 favourite.hidden=YES;

                 
             }
             else
             {
                 NSString * messageString=[responseDictionary valueForKey:@"message"];
                 NSString *titleStr = JJLocalizedString(@"Oops", nil);
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
                 
             }
             
         }
         
         
     }
     
               failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
}
- (IBAction)Mail_invoice:(id)sender {
    EmailAlert = [[UIAlertView alloc]
                 initWithTitle:@"ENTER YOUR E-MAIL ID"
                 message:@""
                 delegate:self
                 cancelButtonTitle:@"CANCEL"
                 otherButtonTitles:@"SEND", nil];
    [EmailAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    Email_fld=[EmailAlert textFieldAtIndex:0];
    Email_fld.textAlignment=NSTextAlignmentCenter;
    Email_fld.delegate=self;
    [Email_fld setBorderStyle:UITextBorderStyleNone];
    Email_fld.autocapitalizationType=YES;
    [EmailAlert show];
}
- (IBAction)Report_issues:(id)sender {
}
- (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==Email_fld)
    {
        if (![self validateEmail:Email_fld.text])
        {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(@"Please_Enter_Valid_Email", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
           /// [textField becomeFirstResponder];
            isVerified=NO;
        }
        else
        {
            [textField resignFirstResponder];
            isVerified=YES;
        }
    }
    if (textField==ShareFld)
    {
        
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==Amount_txtFld)
    {
        
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= 3 || returnKey;

    }
    if (textField==Amount_txtFld)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"123456789"] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else if (textField==ShareFld)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    else
    {
        NSString *resultingString = [Email_fld.text stringByReplacingCharactersInRange: range withString: string];
        NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
        if  ([resultingString rangeOfCharacterFromSet:whitespaceSet].location == NSNotFound)
        {
            return YES;
        }  else  {
            return NO;
        }
    }
   
}
-(void)Mail_Invoice

{
    if (isVerified==YES)
    {
        NSDictionary * parameters=@{@"email":Email_fld.text,
                                    @"ride_id":RideIDlabel.text};
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        [web MailInvoice:parameters success:^(NSMutableDictionary *responseDictionary)
         
         {
             NSLog(@"%@",responseDictionary);
             [Themes StopView:self.view];
             
             if ([responseDictionary count]>0)
             {
                 responseDictionary=[Themes writableValue:responseDictionary];
                 NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                 [Themes StopView:self.view];
                 
                 if ([comfiramtion isEqualToString:@"1"])
                 {
                     NSString * messageString=[responseDictionary valueForKey:@"response"];
                     UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [Alert show];
                     favourite.hidden=YES;
                     
                     
                 }
                 else
                 {
                     NSString * messageString=[responseDictionary valueForKey:@"response"];
                     NSString *titleStr = JJLocalizedString(@"Oops", nil);
                     UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [Alert show];
                     
                 }
                 
             }
             
             
         }
         
                 failure:^(NSError *error)
         {
             [Themes StopView:self.view];
         }];
    }
    else{
        UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:JJLocalizedString(@"Please_Enter_Valid_Email", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];}
    }
   

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==Amount_txtFld)
    {
        Scrolling.contentOffset=CGPointMake(0, 250);
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (Amount_txtFld) {
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(doneClicked:)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        Amount_txtFld.inputAccessoryView = keyboardDoneButtonView;
    }
    if (ShareFld) {
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(doneClickedAction:)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        ShareFld.inputAccessoryView = keyboardDoneButtonView;
    }
}
- (void)doneClicked:(id)sender
{
    [Amount_txtFld resignFirstResponder];
    Scrolling.contentOffset=CGPointMake(0, 0);
}
- (void)doneClickedAction:(id)sender
{
    [ShareFld resignFirstResponder];
}
  - (IBAction)Remove_action:(id)sender {
      
      NSDictionary * parameters=@{@"ride_id":RideIDlabel.text};
      
      UrlHandler *web = [UrlHandler UrlsharedHandler];
      [Themes StartView:self.view];
      
      [web Remove_Tips:parameters success:^(NSMutableDictionary *responseDictionary)
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
                   AddindTip_View.hidden=NO;
                   RemoveTip_View.hidden=YES;
                   Amount_txtFld.text=@"";
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
- (IBAction)Apply_action:(id)sender {
    
    NSDictionary * parameters=@{@"tips_amount":Amount_txtFld.text,
                                @"ride_id":RideIDlabel.text};
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    
    [web Add_Tips:parameters success:^(NSMutableDictionary *responseDictionary)
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
                 AddindTip_View.hidden=YES;
                 RemoveTip_View.hidden=NO;
                 [Amount_txtFld resignFirstResponder];
                 Scrolling.contentOffset=CGPointMake(0, 0);
                 NSString*str=[[responseDictionary valueForKey:@"response"] valueForKey: @"tips_amount"];
                 NSString * Tip=JJLocalizedString(@"Tips_Amount", nil);

                 AmountTip_lbl.text=[Themes writableValue:[NSString stringWithFormat:@"%@%@%@",Tip,Curerncysymbol,str]];
                 //[AmountTip_lbl sizeToFit];


             }
             else
             {
                 UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Oops!!!" message:@"Kindly enter your tips amount" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }
         
     }
          failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
    

   }


-(IBAction)ShareMyRide_Action:(id)sender
{
    ShareAlert = [[UIAlertView alloc]
                  initWithTitle:JJLocalizedString(@"ENTER_MOBILE_NUMBER", nil)
                  message:@""
                  delegate:self
                  cancelButtonTitle:JJLocalizedString(@"CANCEL", nil)
                  otherButtonTitles:JJLocalizedString(@"SEND", nil), nil];
    [ShareAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    ShareFld=[ShareAlert textFieldAtIndex:0];
    ShareFld.textAlignment=NSTextAlignmentCenter;
    ShareFld.delegate=self;
    ShareFld.keyboardType=UIKeyboardTypePhonePad;
    [ShareFld setBorderStyle:UITextBorderStyleNone];
    ShareFld.autocapitalizationType=YES;
    [ShareAlert show];
}

-(void)DirectionPath
{
    NSString *urlStr=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f",Latitude,longitude,Drop_Latitude,Drop_longitude];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr=[ urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLResponse *res;
    NSError *err;
    NSData *data=[NSURLConnection sendSynchronousRequest:[[NSURLRequest alloc] initWithURL:url] returningResponse:&res error:&err];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *routes=dic[@"routes"];
    GMSPath *path;
    if([routes count]>0){
         path=[GMSPath pathFromEncodedPath:dic[@"routes"][0][@"overview_polyline"][@"points"]];
        GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path];
        singleLine.strokeWidth = 3;
        singleLine.strokeColor = [UIColor blueColor];
        singleLine.map = googlemap;
    }
   
  
    
    PickUP.position=CLLocationCoordinate2DMake(Latitude, longitude);
    PickUP.appearAnimation=kGMSMarkerAnimationPop;
    UIImage *markerIcon = [UIImage imageNamed:@"pin"];
    PickUP.icon = markerIcon;
    DropMarker.map = googlemap;
    
    DropMarker.position=CLLocationCoordinate2DMake(Drop_Latitude, Drop_longitude);
    DropMarker.appearAnimation=kGMSMarkerAnimationPop;
    UIImage *markerIcon2 = [UIImage imageNamed:@"pin"];
    DropMarker.icon = markerIcon2;
    DropMarker.map = googlemap;
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0f];
    bounds=[bounds  initWithCoordinate:PickUP.position coordinate:DropMarker.position];
    [googlemap animateWithCameraUpdate:update];
}

//-(void)UpdateAlternativeroutBetweenTwoPoints{
//    NSString *joinedString=@"";
//    if(wayArray.count>0){
//        joinedString = [wayArray componentsJoinedByString:@"|"];
//    }
//    wpoint++;
//    [self.view makeToast:[NSString stringWithFormat:@"%d ways count",wpoint ]];
//    
//    NSString *urlString = [NSString stringWithFormat:
//                           @"%@?origin=%f,%f&destination=%f,%f&waypoints=%@&sensor=true",
//                           @"https://maps.googleapis.com/maps/api/directions/json",
//                           startLocationDriver.coordinate.latitude,
//                           startLocationDriver.coordinate.longitude,
//                           riderLattitude,
//                           riderLongitude,joinedString];
//    NSURL *directionsURL = [NSURL URLWithString:urlString];
//    
//    UrlHandler *web = [UrlHandler UrlsharedHandler];
//    [Themes StartView:self.view];
//    
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:directionsURL];
//    [request startSynchronous];`
//    NSError *error = [request error];
//    [self stopActivityIndicator];
//    if (!error) {
//        NSString *response = [request responseString];
//        NSLog(@" %@",response);
//        NSDictionary *json =[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&error];
//        NSLog(@"%@",json);
//        NSArray * arr=[json objectForKey:@"routes"];
//        if([arr count]>0){
//            if(singleLine!=nil){
//                [singleLine setMap:nil];
//            }
//            pathDrawn =[GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
//            singleLine = [GMSPolyline polylineWithPath:pathDrawn];
//            singleLine.strokeWidth = 10;
//            singleLine.strokeColor = SetThemeColor;
//            singleLine.map = self.GoogleMap;
//            GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:pathDrawn];
//            GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0f];
//            //bounds = [bounds includingCoordinate:PickUpmarker.position   coordinate:Dropmarker.position];
//            [GoogleMap animateWithCameraUpdate:update];
//            [_locationManager stopUpdatingLocation];
//        }else{
//            //  [self UpdateAlternativeroutBetweenTwoPoints];
//            // [self.view makeToast:@"can't find route"];
//        }
//        
//        // }
//        
//    }
//}

@end
