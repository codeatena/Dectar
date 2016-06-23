//
//  NewViewController.m
//  Dectar
//
//  Created by Aravind Natarajan on 12/21/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import "NewViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "UrlHandler.h"
#import "Themes.h"
#import "UIImageView+Network.h"
#import "PaymentVC.h"
#import "RatingVC.h"
#import "LanguageHandler.h"
#define ACCEPTABLE_CHARECTERS @"123456789."

const static CGFloat kCustomIOS7MotionEffectExtent = 10.0;

@interface NewViewController ()<UITextFieldDelegate>
{
    float userlat;
    float userlon;
    float drlat;
    float drlng;
    BOOL checkBoxSelected;
    
    
    NSString * RideID;
    NSString * CouponAmount;
    NSString * TipAmount;
    NSString * Currency;
    NSString * FullTotalAmount;
    
    NSString  *stripe_connected;
    NSString * payment_timeout;
    NSTimer *payment_timer;
    NSString *Distance_unit;
    AppDelegate *appDel;



}
@property(strong ,nonatomic) GMSMapView * googlemap;
@property (strong ,nonatomic) GMSCameraPosition*camera;
@end

@implementation NewViewController
@synthesize ObjRc;

- (void)viewDidLoad {
    
    self.retryView.hidden = NO;
    self.retryButton.hidden = YES;
    
    [super viewDidLoad];
    
    [_addView setHidden:YES];
    [_reoveTip setHidden:YES];
    
    [_HeadingTips_Amount setHidden:YES];
    [_title_tips setHidden:YES];
    [_remove_btn setHidden:YES];
    [_goBack setHidden:YES];
    [_coupon_amount setHidden:YES];
    [_title_coupon setHidden:YES];
    
    //RideID=@"1451289130";
    [self setObjRc:ObjRc];
    [self getFareData];
    
    
    
    [_amount_fld setDelegate:self];
    
    _driverImage.layer.cornerRadius = 35.0f;
    _driverImage.layer.masksToBounds = YES;
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1.0f;
    border.borderColor = [UIColor blackColor].CGColor;
    border.frame = CGRectMake(0, _amount_fld.frame.size.height - borderWidth, _amount_fld.frame.size.width, _amount_fld.frame.size.height);
    border.borderWidth = borderWidth;
    [_amount_fld.layer addSublayer:border];
    _amount_fld.layer.masksToBounds = YES;
    
       _googlemap = [GMSMapView mapWithFrame:CGRectMake(0, 0, _mapBGView.frame.size.width , _mapBGView.frame.size.height) camera:_camera];
    
    _googlemap.userInteractionEnabled=NO;
    [_mapBGView addSubview:_googlemap];
   
    
    [self shadow:_add_btn];
   // [self shadow:_remove_btn];
    
    CLLocation * loca=[[CLLocation alloc]initWithLatitude:userlat longitude:userlon];
    CLLocationCoordinate2D coordi=loca.coordinate;
    GMSMarker *marker=[GMSMarker markerWithPosition:coordi];
    marker.appearAnimation=kGMSMarkerAnimationPop;
    UIImage *markerIcon = [UIImage imageNamed:@"pin"];
    marker.icon = markerIcon;
    marker.map = _googlemap;
    
    CLLocation * loca2=[[CLLocation alloc]initWithLatitude:drlat longitude:drlng];
    CLLocationCoordinate2D coordi2=loca2.coordinate;
    GMSMarker *marker2=[GMSMarker markerWithPosition:coordi2];
    marker2.appearAnimation=kGMSMarkerAnimationPop;
    UIImage *markerIcon2 = [UIImage imageNamed:@"pin"];
    marker2.icon = markerIcon2;
    marker2.map = _googlemap;
    
    /*[self test:_driver_View];
    [self applyMotionEffects:_driver_View];*/
    [self.scrolling setContentSize:CGSizeMake(self.scrolling.frame.size.width, 1010)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDismissSecondViewController)
                                                 name:@"SecondViewControllerDismissed"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(WalletUsed)
                                                 name:@"WalletUsed"
                                               object:nil];

    // Do any additional setup after loading the view.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_goBack setTitle:JJLocalizedString(@"GoBack", nil)  forState:UIControlStateNormal];
    [_heading setText:JJLocalizedString(@"Fare_Breakup", nil)];
    [_title_Basefare setText:JJLocalizedString(@"base_fare", nil)];
    [_title_amount setText:JJLocalizedString(@"total",nil)];
    [_title_coupon setText:JJLocalizedString(@"Coupon", nil)];
    [_title_servicetax setText:JJLocalizedString(@"service_tax", nil)];
    [_title_sub_total setText:JJLocalizedString(@"sub_total", nil)];
    [_title_tips setText:JJLocalizedString(@"Tips_Amount", nil)];
    [_hint_tipadriver setText:JJLocalizedString(@"want_tips", nil)];
    [_add_btn setTitle:JJLocalizedString(@"tip", nil) forState:UIControlStateNormal];
    [_remove_btn setTitle:JJLocalizedString(@"minus", nil) forState:UIControlStateNormal];
    [_makePayMent setTitle:JJLocalizedString(@"make_a_payment", nil) forState:UIControlStateNormal];
    
    [_retryButton setTitle:JJLocalizedString(@"Retry", nil) forState:UIControlStateNormal];
    [_wait setText:JJLocalizedString(@"Please_wait", nil)];
    [_hint_processing setText:JJLocalizedString(@"processing", nil)];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)didDismissSecondViewController {
    [_makePayMent setHidden:YES];
    [_tipsView_btn setUserInteractionEnabled:NO];
    [_add_btn setUserInteractionEnabled:NO];
    [_remove_btn setUserInteractionEnabled:NO];
    [_goBack setHidden:NO];


}
-(void)WalletUsed
{
    [_tipsView_btn setUserInteractionEnabled:NO];
    [_add_btn setUserInteractionEnabled:NO];
    [_remove_btn setUserInteractionEnabled:NO];
    [_goBack setHidden:NO];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView==_scrolling){
        float y = scrollView.contentOffset.y;
        CGRect imageFrame = _mapBGView.frame;
        imageFrame.origin.y = y/5.0;
        _mapBGView.frame = imageFrame;
    }
    
}
-(void)setObjRc:(FareRecord *)_ObjRc
{
    ObjRc=_ObjRc;
    RideID=_ObjRc.ride_id;
    [Themes StopView:self.view];
    
}
-(void)getFareData
{
    NSDictionary * parameter=@{@"user_id":[Themes getUserID],
                               @"ride_id":RideID};
    [Themes StartView:self.view];
    UrlHandler * web=[UrlHandler UrlsharedHandler];
    [web FareBreakUp:parameter success:^(NSMutableDictionary *responseDictionary) {
        if ([responseDictionary count]>0)
        {
        [Themes StopView:self.view];
        responseDictionary=[Themes writableValue:responseDictionary];
        NSString * status=[responseDictionary valueForKey:@"status"];
               [Themes StopView:self.view];

            if ([status isEqualToString:@"1"])
            {
                self.retryView.hidden = YES;
                [Themes StopView:self.view];

                Currency=[Themes findCurrencySymbolByCode:[[responseDictionary valueForKey:@"response" ] valueForKey:@"currency"]];
                
                
                NSString * imageStr=[[[responseDictionary valueForKey:@"response" ] valueForKey:@"driverinfo"]valueForKey:@"image"];
                NSString *trimmedString=[imageStr substringFromIndex:MAX((int)[imageStr length]-10, 0)];
                NSString * cacheStr=[NSString stringWithFormat:@"MyRiD_%@",trimmedString];
                [_image_driver loadImageFromURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"menuBG"] cachingKey:cacheStr];
                
                userlon=[[[[responseDictionary valueForKey:@"response" ] valueForKey:@"location"]valueForKey:@"drop_lon"] floatValue];
                userlat=[[[[responseDictionary valueForKey:@"response" ] valueForKey:@"location"]valueForKey:@"drop_long"] floatValue];
                drlat=[[[[responseDictionary valueForKey:@"response" ] valueForKey:@"location"]valueForKey:@"pickup_lat"] floatValue];
                drlng=[[[[responseDictionary valueForKey:@"response" ] valueForKey:@"location"]valueForKey:@"pickup_lon"] floatValue];
                
                _driverName.text=[[[responseDictionary valueForKey:@"response" ] valueForKey:@"driverinfo"]valueForKey:@"name"];
                _contact.text=[[[responseDictionary valueForKey:@"response" ] valueForKey:@"driverinfo"]valueForKey:@"contact_number"];
                _cab.text=[[[responseDictionary valueForKey:@"response" ] valueForKey:@"driverinfo"]valueForKey:@"cab_no"];
                _cab_type.text=[[[responseDictionary valueForKey:@"response" ] valueForKey:@"driverinfo"]valueForKey:@"cab_model"];
                
                
                _date.text=[[[responseDictionary valueForKey:@"response" ] valueForKey:@"fare"]valueForKey:@"trip_date"];

                NSString * category=[[[responseDictionary valueForKey:@"response" ] valueForKey:@"fare"]valueForKey:@"cab_type"];
                
                
                _basefare.text=[NSString stringWithFormat:@"%@ x %@",category,[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"base_fare"]];
                _service_Amount.text=[NSString stringWithFormat:@"%@%@",Currency,[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"tax_amount"]];
                CouponAmount=[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"coupon_amount"];
               
                if ([CouponAmount isEqualToString:@"0.00"]) {
                    [_coupon_amount setHidden:YES];
                    [_title_coupon setHidden:YES];
                }
                
                TipAmount=[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"tip_amount"];
                if ([TipAmount isEqualToString:@"0.00"]) {
                    [_HeadingTips_Amount setHidden:YES];
                    [_title_tips setHidden:YES];
                    [_remove_btn setHidden:YES];

                }
                
                FullTotalAmount=[NSString stringWithFormat:@"%@%@",Currency,[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"total"]];
                _FulTotal_Amount.text=FullTotalAmount;
                Distance_unit=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"distance_unit"]];

                _rideDistance.text=[NSString stringWithFormat:@"%@ %@",[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"ride_distance"],Distance_unit]; //left
                _distanceAmount.text=[NSString stringWithFormat:@"%@%@",Currency,[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"base_fare"]]; //right
                
                _rideminutes.text=[NSString stringWithFormat:@"%@ Minutes",[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"ride_duration"]];
                _miniutesAmount.text=[NSString stringWithFormat:@"%@%@",Currency,[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"time_fare"]];
                _totalAmount.text=[NSString stringWithFormat:@"%@%@",Currency,[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"sub_total"]];
                _totalAmount.text=[NSString stringWithFormat:@"%@%@",Currency,[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"sub_total"]];
               
                stripe_connected=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"stripe_connected"]];
                
                
                payment_timeout=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"payment_timeout"]];

                if([stripe_connected  isEqual: @"Yes"])
                {
                float Timing = [payment_timeout floatValue];

                    payment_timer=[NSTimer scheduledTimerWithTimeInterval: Timing
                                                                   target: self
                                                                 selector:@selector(invoke_payment)
                                                                 userInfo: nil repeats:YES];
    
                }
                
    
                [self DirectionPath];


            }
            else
            {
                self.retryView.hidden = NO;
                self.retryButton.hidden = NO;
                
                [Themes StopView:self.view];
            }
        }
    } failure:^(NSError *error) {
        
        self.retryView.hidden = NO;
        self.retryButton.hidden = NO;
        [Themes StopView:self.view];
        
    }];
    
}


-(void)test:(UIView*)view
{
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-10);
    verticalMotionEffect.maximumRelativeValue = @(10);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-10);
    horizontalMotionEffect.maximumRelativeValue = @(10);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [view addMotionEffect:group];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)DirectionPath
{
    NSString *urlStr=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f",userlon,userlat,drlat,drlng];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr=[ urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLResponse *res;
    NSError *err;
    NSData *data=[NSURLConnection sendSynchronousRequest:[[NSURLRequest alloc] initWithURL:url] returningResponse:&res error:&err];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *routes=dic[@"routes"];
    if([routes count]>0){
        GMSPath *path =[GMSPath pathFromEncodedPath:dic[@"routes"][0][@"overview_polyline"][@"points"]];
        GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path];
        singleLine.strokeWidth = 3;
        singleLine.strokeColor = [UIColor blueColor];
        singleLine.map = _googlemap;
    }
    _camera = [GMSCameraPosition cameraWithLatitude:drlat
                                          longitude:drlng
                                               zoom:17];
    [_googlemap animateToCameraPosition:_camera];

    //[_googlemap animateToZoom:15.0f];
    CLLocation * loca=[[CLLocation alloc]initWithLatitude:userlat longitude:userlon];
    CLLocationCoordinate2D coordi=loca.coordinate;
    GMSMarker *marker=[GMSMarker markerWithPosition:coordi];
    marker.appearAnimation=kGMSMarkerAnimationPop;
    UIImage *markerIcon = [UIImage imageNamed:@"pin"];
    marker.icon = markerIcon;
    marker.map = _googlemap;
    
    CLLocation * loca2=[[CLLocation alloc]initWithLatitude:drlat longitude:drlng];
    CLLocationCoordinate2D coordi2=loca2.coordinate;
    GMSMarker *marker2=[GMSMarker markerWithPosition:coordi2];
    marker2.appearAnimation=kGMSMarkerAnimationPop;
    UIImage *markerIcon2 = [UIImage imageNamed:@"pin"];
    marker2.icon = markerIcon2;
    marker2.map = _googlemap;
}

-(void)shadow:(UIView*)View
{
    View.layer.shadowColor = [UIColor blackColor].CGColor;
    View.layer.shadowOpacity = 0.5;
    View.layer.shadowRadius = 1;
    View.layer.shadowOffset = CGSizeMake(1.5f,1.5f);
}
- (IBAction)payment_action:(id)sender {
    
    [self invoke_payment];

}
-(void)invoke_payment
{
    
    [payment_timer invalidate];

    if([stripe_connected  isEqual: @"Yes"])
    {
        NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                    @"ride_id":RideID};
        
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
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:JJLocalizedString(@"Your_Payment_successfully finished", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     
                     RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
                     [objLoginVC setRideID_Rating:RideID];
                     [self.navigationController pushViewController:objLoginVC animated:YES];
                     
                 }
                 /*  else if ([comfiramtion isEqualToString:@"2"])
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
        PaymentVC * PaymentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentVCID"];
        [PaymentVC setRideID:RideID];
        [self.navigationController pushViewController:PaymentVC animated:YES];

    }

}
- (IBAction)check_Action:(id)sender {
    
    checkBoxSelected = !checkBoxSelected;
    UIButton* check = (UIButton*) sender;
    if (checkBoxSelected == NO)
    {
        [check setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];  //hide
        [self viewSlideInFromTopToBottom:_addView];
        [_addView setHidden:YES];

        
    }
    
    else
    {
        [check setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];  //show
        [self viewSlideInFromBottomToTop:_addView];
        [_addView setHidden:NO];
       // _scrolling.contentOffset=CGPointMake(0, 400);

        
    }

}
- (IBAction)removeAction:(id)sender {
   
   
    
    [self viewSlideInFromTopToBottom:_reoveTip];
    [self viewSlideInFromBottomToTop:_addView];
    
    [self RemoveTips];
   
}
- (IBAction)add_Action:(id)sender {
   
    if (![_amount_fld.text isEqualToString:@""]) {
        [self viewSlideInFromTopToBottom:_addView];
        [self viewSlideInFromBottomToTop:_reoveTip];
        
        
        [self addingTips];
    }
   
    //_scrolling.contentOffset=CGPointMake(0, 0);

    
    
}
-(void)viewSlideInFromBottomToTop:(UIView *)views    //show
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromTop ;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}
-(void)viewSlideInFromTopToBottom:(UIView *)views    //hide
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromBottom ;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}
/*-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==_amount_fld)
    {
        _scrolling.contentOffset=CGPointMake(0, 350);
    }
    return YES;
}*/
- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   
    
    if (textField==_amount_fld)
    {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 3 || returnKey;
    }
    else if (textField==_amount_fld)
    {
        if ([string isEqualToString:@"0"] && range.location == 0) {
            return NO;
        }
    }
    else if (textField==_amount_fld)
        
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"123456789"] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
   
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_amount_fld) {
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStylePlain target:self
                                                                      action:@selector(doneClicked:)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        _amount_fld.inputAccessoryView = keyboardDoneButtonView;
        _scrolling.contentOffset=CGPointMake(0, 450);
    }
}
- (void)doneClicked:(id)sender
{
    [_amount_fld resignFirstResponder];
    CGPoint bottomOffset = CGPointMake(0, _scrolling.contentSize.height - _scrolling.bounds.size.height);
    [_scrolling setContentOffset:bottomOffset animated:YES];

}
- (void)applyMotionEffects:(UIView *)View {
    if (NSClassFromString(@"UIInterpolatingMotionEffect")) {
        UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                        type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
        horizontalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);
        UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                      type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
        verticalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);
        UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
        motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
        [View addMotionEffect:motionEffectGroup];
    }
}
-(void)addingTips
{
    if(![_amount_fld.text  isEqual: @"0"])
    {
    NSDictionary * parameters=@{@"tips_amount":_amount_fld.text,
                                @"ride_id":RideID};
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
                 /*Amount_View.hidden=YES;
                 Remove_View.hidden=NO;
                 [Amount_fld resignFirstResponder];
                 Scrooling.contentOffset=CGPointMake(0, 0);
                 NSString * value=[[responseDictionary valueForKey:@"response"] valueForKey: @"tips_amount"];
                 Amount_lbl.text=[Themes writableValue:[NSString stringWithFormat:@"tips amount%@%@",currency,value]];*/
                 
                 [_addView setHidden:YES];
                 [_reoveTip setHidden:NO];
                 [_tipsView_btn setUserInteractionEnabled:NO];
                 [_amount_fld resignFirstResponder];
                 FullTotalAmount=[NSString stringWithFormat:@"%@%@",Currency,[[responseDictionary valueForKey:@"response"]valueForKey:@"total"]];
                 _FulTotal_Amount.text=FullTotalAmount;
                 [_HeadingTips_Amount setHidden:NO];
                 [_title_tips setHidden:NO];
                 [_added_lbl setText:[NSString stringWithFormat:@"Your tips amount %@%@",Currency,[[responseDictionary valueForKey:@"response"] valueForKey:@"tips_amount"]]];
                 [_HeadingTips_Amount setText:[NSString stringWithFormat:@"%@%@",Currency,[[responseDictionary valueForKey:@"response"] valueForKey:@"tips_amount"]]];
                 [_remove_btn setHidden:NO];

             }
             else
             {
                 NSString* mesg=[responseDictionary valueForKey:@"response"];
                 UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:mesg delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }
         
         
     }
          failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:[Themes getAppName] message:@"Amount is low" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];

    }
}
-(void)RemoveTips
{
    NSDictionary * parameters=@{@"ride_id":RideID};
    
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
                 /*Amount_View.hidden=NO;
                 Remove_View.hidden=YES;
                 Amount_fld.text=@"";*/
                 
                 [_addView setHidden:NO];
                 [_reoveTip setHidden:YES];
                 [_tipsView_btn setUserInteractionEnabled:YES];
                 [_amount_fld setText:@""];
                 [_HeadingTips_Amount setHidden:YES];
                 [_title_tips setHidden:YES];
                 FullTotalAmount=[NSString stringWithFormat:@"%@%@",Currency,[[responseDictionary valueForKey:@"response"]valueForKey:@"total"]];
                 _FulTotal_Amount.text=FullTotalAmount;
                 [_remove_btn setHidden:YES];


             }
             else
             {
                 NSString* mesg=[responseDictionary valueForKey:@"response"];
                 UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:mesg delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }
         
         
     }
             failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];

}
-(IBAction)goback_Action:(id)sender
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [del LogIn];
}

#pragma mark Did Click retry

- (IBAction)didClickRetry:(id)sender {
    
    @try {
        
        if (!appDel) {
            appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        }
        
        if (appDel.isNetworkAvailable) {
            
            self.retryView.hidden=NO;
            self.retryButton.hidden = YES;
            [self getFareData];
        }
        else
        {
            self.retryView.hidden=NO;
            self.retryButton.hidden = NO;
            [self.view makeToast:@"No Network Connection"];
        }
       
    }
    @catch (NSException *exception) {
        
    }
    

}
@end
