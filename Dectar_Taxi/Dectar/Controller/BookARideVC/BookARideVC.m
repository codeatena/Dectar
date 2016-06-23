//
//  BookARideVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 16/07/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import "BookARideVC.h"
#import <GoogleMaps/GoogleMaps.h>
#import <UIKit/UIKit.h>
#import "Themes.h"
#import "UrlHandler.h"
#import "Search.h"
#import "BookingRecord.h"
#import "CarCtryCell.h"
#import "EstimationRecord.h"
#import "Constant.h"
#import "FavorVC.h"
#import "AddressRecord.h"
#import "AddFavrVC.h"
#import "DriverRecord.h"
#import "FareRecord.h"
#import "FareVC.h"
#import "RateCardViewVC.h"
#import "RatingVC.h"
#import "NewViewController.h"
#import "NewTrackVC.h"
#import "CopounVC.h"
#import "HelpVC.h"
#import "ATAppUpdater.h"
#import "DropVC.h"
#import "REFrostedViewController.h"
#import "LanguageHandler.h"
#import "UIImageView+WebCache.h"


@interface BookARideVC ()<GMSMapViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UISearchBarDelegate,CLLocationManagerDelegate,UITextFieldDelegate>
{
    NSIndexPath * selectedindex;
    NSString * pickUptime;
    NSString * pickupdate;
    UITextField *CouponTextField;
    FavourRecord *message;
    NSString * nameofcar;
    NSString * couponCode;
    UIAlertView *couponAlert;
    NSTimer*timingLoading;
    NSTimer*timingLoading2;
    NSMutableDictionary *SearchResponDict;
    NSMutableArray *SearchResultArray;
    
    UIAlertView*RetryAlert;
    UIAlertView * ConfrimAlertlater;
    NSString * ETAtimeTaking;
    BOOL isRetry;
    BOOL showinAlert;
    NSString * iswhichEstimate;
    NSString * Currency;

}

@property(nonatomic,strong)NSTimer *connectionTimer;

@property (strong, nonatomic) IBOutlet UIView *RideView;
@property (strong, nonatomic) IBOutlet JTImageButton *rideLater_btn;
@property (strong, nonatomic) IBOutlet JTImageButton *rideNow_btn;

@property (nonatomic, strong) IBOutlet UIView * BGmapView;
@property (nonatomic, strong) IBOutlet JTImageButton *btnMenu;
@property (strong, nonatomic) GMSMapView * GoogleMap;
@property (strong, nonatomic) GMSCameraPosition * Camera;
@property (strong, nonatomic) IBOutlet UIButton *defaultAnno;
@property (strong, nonatomic) IBOutlet UITextField *AddressField;
@property (strong ,nonatomic) NSString * CarCategoryString;
@property  CLLocationCoordinate2D center;
@property (strong ,nonatomic) NSString * UserID;
@property (strong , nonatomic) NSMutableArray * categoryArray;
@property (strong ,nonatomic)BookingRecord * categaory;
@property (assign ,nonatomic) BOOL SearchControl;
@property(strong,nonatomic) NSString * ButtontypeStr;
@property (strong,nonatomic)NSString * DropAddressSrting;

@property (assign ,nonatomic) BOOL Favour;
@property (assign ,nonatomic) BOOL IsPickerView;
@property (assign ,nonatomic) BOOL isETAView;
@property (assign ,nonatomic) BOOL isChangingNetwork;

@property (strong ,nonatomic) NSArray * TimeArray;
@property (strong, nonatomic) NSMutableArray *nameArray;
@property (strong ,nonatomic) NSMutableDictionary * ResponseArray;
@property (strong ,nonatomic) UITapGestureRecognizer * tapges;
@property (strong,nonatomic) NSString * TimeString;
@property (strong,nonatomic) NSString * DateString;
@property (strong,nonatomic) NSString * DelayTimeStr;
@property (strong,nonatomic) NSString * DelayDateStr;

@property(strong ,nonatomic) EstimationRecord * estiamtion;
@property(strong ,nonatomic) AddressRecord * AddObj;
@property(strong,nonatomic) DriverRecord *Record_Driver;
@property (strong, nonatomic) IBOutlet BLMultiColorLoader *loadingView_View;
@property (strong, nonatomic) IBOutlet UILabel *timing_label;
@property (strong, nonatomic) IBOutlet UIImageView *clock_imageview;

@property (strong, nonatomic) IBOutlet UILabel *staticMinus_Lbl;

@property (strong, nonatomic) IBOutlet UIImageView *ConfirmPin;

@end

@implementation BookARideVC
@synthesize Camera,GoogleMap,BGmapView,addressString,AddressField,currentLocation,latitude,longitude,center,searchView,filteredContentList,tblContentList,search,isLocationSelected,Annotation,CarCategoryString,UserID,categoryArray,categaory,ResponseArray,ButtontypeStr,SearchControl,locationBtn,DropAddressSrting,TimeString,DateString,droplatitude,droplongitude,estiamtion,EstimationDetailView,maxlable,minilable,attLable,dropLable,pickUplable,noteLable,RidelatePicker,pickerView,DelayTimeStr,DelayDateStr,infoPicktimeLable,EstiamtionCloseButton,LateInfoView,latecabtypeView,latePickUpView,lateEstiamteionView,lateRateView,lateCouponView,lateCabLable,lateCouponlbl,latePickUplbl,AddObj,isInitialButtonSelected,Favour,RideView,CouponCoudLable,isNoCabsButtonSelectedIndex,Record_Driver,TimeViewTiming,IsPickerView,selectedBtnIndex,isETAView,FavoriteBTN,RideNow_WalletAmount_lbl,RideLater_WalletAmount_lbl,isChangingNetwork,bookingIdStr;

@synthesize CtryViewCell;
@synthesize nameArray;
@synthesize TimeArray;
@synthesize DownView;
@synthesize CancelButton;
@synthesize ConfirmButton;
@synthesize InfoView;
@synthesize PickUptimeView;
@synthesize CategoryView;
@synthesize CouponView;
@synthesize EstimationView;
@synthesize RateCardView;
@synthesize pickupLable;
@synthesize CategoryLable;
@synthesize tapges;
@synthesize RateCardDetailView;
@synthesize RateCardCatLable;
@synthesize RateCardVechielLable;
@synthesize Minfare_text;
@synthesize MinFarelable;
@synthesize notelabel;
@synthesize Afterfare_text;
@synthesize AfterFareLable;
@synthesize waitingfare_text;
@synthesize WaitingfareLable;


- (void)viewDidLoad {
    [super viewDidLoad];
    
     selectedBtnIndex=0;
     categoryArray=[[NSMutableArray alloc]init];
    // nameArray=[[NSMutableArray alloc]init];
    filteredContentList=[[NSMutableArray alloc]init];
    estiamtion=[[EstimationRecord alloc]init];
    Record_Driver=[[DriverRecord alloc]init];
    AddObj =[[AddressRecord alloc]init];
    NSLog(@"%@",[Themes GetCoupon]);
    [self loadBookrideUI];
    
    if ([Themes GetCoupon].length==0)
    {
        CouponCoudLable.text=JJLocalizedString(@"Apply_Coupon", nil) ;
        lateCouponlbl.text=JJLocalizedString(@"Apply_Coupon", nil);
        
    }
    else
    {
        CouponCoudLable.text=[Themes GetCoupon];
        lateCouponlbl.text=[Themes GetCoupon];
    }
    categoryArray=[NSMutableArray array];
    
    currentLocation = [[CLLocationManager alloc] init];
    [currentLocation requestWhenInUseAuthorization];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        [currentLocation requestAlwaysAuthorization];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        [currentLocation requestAlwaysAuthorization];
        
    }
    [currentLocation startUpdatingLocation];
    
    currentLocation.delegate=self;
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language hasPrefix:@"es"]){
        [_defaultAnno setImage:[UIImage imageNamed:@"pindropes"] forState:UIControlStateNormal];
    }
    else
    {
        [_defaultAnno setImage:[UIImage imageNamed:@"pindrop"] forState:UIControlStateNormal];
    }
    
    [_rideLater_btn createTitle:@"BOOK RIDE FOR LATER" withIcon:[UIImage imageNamed:@"Invoice"]
                           font:[UIFont fontWithName:@"RobotoCondensed-Bold" size:14.0f]
                     iconHeight:20
                    iconOffsetY:-4];
    [self configCustomButton:_rideLater_btn];
    
    [_rideNow_btn createTitle:@"BOOK RIDE FOR NOW" withIcon:[UIImage imageNamed:@"ok_icon"]
                         font:[UIFont fontWithName:@"RobotoCondensed-Bold" size:14.0f]
                   iconHeight:24
                  iconOffsetY:-4];
    [self configCustomButton1:_rideNow_btn];
    
    [CancelButton createTitle:@"CANCEL BOOKING" withIcon:[UIImage imageNamed:@"cancel_icon"]
                         font:[UIFont fontWithName:@"RobotoCondensed-Bold" size:14.0f]
                   iconHeight:24
                  iconOffsetY:-4];
    [self configCustomButton:CancelButton];
    
    [ConfirmButton createTitle:@"CONFIRM BOOKING" withIcon:[UIImage imageNamed:@"ok_icon"]
                          font:[UIFont fontWithName:@"RobotoCondensed-Bold" size:14.0f]
                    iconHeight:24
                   iconOffsetY:-4];
    [self configCustomButton1:ConfirmButton];
    
    [_btnMenu createTitle:@"MENU" withIcon:[UIImage imageNamed:@"Menu"]
                         font:[UIFont fontWithName:@"RobotoCondensed-Bold" size:17.0f]
                   iconHeight:24
                  iconOffsetY:-6];
    _btnMenu.bgColor = [UIColor clearColor];
    _btnMenu.borderWidth = 0.0f;
    _btnMenu.iconColor = [UIColor grayColor];
    _btnMenu.titleColor = [UIColor grayColor];
    
    [self.view bringSubviewToFront:EstimationDetailView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

-(void)loadBookrideUI{
    
    [_rideNow_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_rideNow_btn setUserInteractionEnabled:NO];
    
    [_rideLater_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_rideLater_btn setUserInteractionEnabled:NO];
    
//    _loadingView_View.frame=CGRectMake(_loadingView_View.frame.origin.x-05, _loadingView_View.frame.origin.y, _loadingView_View.frame.size.width, _loadingView_View.frame.size.width);
    _loadingView_View.lineWidth = 2.0;
    _loadingView_View.colorArray = [NSArray arrayWithObjects:BGCOLOR, nil];
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor colorWithRed:41.0/255.0 green:180.0/255.0 blue:219.0/255.0 alpha:1.0]];
    
    locationBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    locationBtn.layer.shadowOpacity = 0.5;
    locationBtn.layer.shadowRadius = 2;
    locationBtn.layer.shadowOffset = CGSizeMake(5.0f,5.0f);
    
    [_AddressView setHidden:YES];
    AddressField.delegate=self;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    AddressField.leftView = paddingView;
    AddressField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    _DropField.leftView = paddingView1;
    _DropField.leftViewMode = UITextFieldViewModeAlways;
    
    
    RateCardDetailView.layer.cornerRadius = 10;
    RateCardDetailView.layer.masksToBounds = YES;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    DateString = [formatter stringFromDate:[NSDate date]];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    TimeString = [dateFormatter stringFromDate:now];
    
    RidelatePicker.minimumDate=[[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) 3600 ];
    //RidelatePicker.maximumDate=[[NSDate alloc] initWithTimeIntervalSinceNow:(NSTimeInterval)3600*24*14];
    
    UITapGestureRecognizer * estimate=[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(Estimate:)];
    estimate.numberOfTapsRequired = 1;
    [lateEstiamteionView addGestureRecognizer:estimate];
    
    UITapGestureRecognizer * NowEstimation=[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(Estimate:)];
    NowEstimation.numberOfTapsRequired = 1;
    [EstimationView addGestureRecognizer:NowEstimation];
    
    UITapGestureRecognizer * Coupon=[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(CallCoupon)];
    Coupon.numberOfTapsRequired = 1;
    [lateCouponView addGestureRecognizer:Coupon];
    
    UITapGestureRecognizer * currerntcoupon=[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(CallCoupon)];
    currerntcoupon.numberOfTapsRequired = 1;
    [CouponView addGestureRecognizer:currerntcoupon];
    
    UserID=[Themes getUserID];
    CarCategoryString=[Themes getCategoryString];
    
    tapges = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(rateCard:)] ;
    tapges.numberOfTapsRequired = 1;
    [lateRateView addGestureRecognizer:tapges];
    
    UITapGestureRecognizer * Nowrate = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(rateCard:)] ;
    Nowrate.numberOfTapsRequired = 1;
    [RateCardView addGestureRecognizer:Nowrate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotification:) name:@"PushView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushnotification:) name:@"pushnotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveTimer:) name:@"removeView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ApplyCoupoun:) name:@"CouponApplied" object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewVc:) name:@"payment_paid" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"ride_completed" object:nil];
}

-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [AddressField setText:JJLocalizedString(@"Getting_Address", nil)];
    [lateCouponlbl setText:JJLocalizedString(@"Apply_Coupon", nil)];
    [CouponCoudLable setText:JJLocalizedString(@"Apply_Coupon", nil)];

    [_info_title_cabtype setText:JJLocalizedString(@"Cab_type", nil)];
    [_info_title_estimate setText:JJLocalizedString(@"Estimation", nil)];
    [_info_title_pickuptime setText:JJLocalizedString(@"Pick_up_time", nil)];
    [_info_title_rateCard setText:JJLocalizedString(@"Rate_card", nil)];
    
    
    [_late_title_cabtype setText:JJLocalizedString(@"Cab_type", nil)];
    [_late_title_estimate setText:JJLocalizedString(@"Estimation", nil)];
    [_late_title_pickuptime setText:JJLocalizedString(@"Pick_up_time", nil)];
    [_late_title_ratecard setText:JJLocalizedString(@"Rate_card", nil)];
    
    [_Header_confrimation_lbl setText:JJLocalizedString(@"Confirmation", nil)];
    [_PickUpAddress_label setText:JJLocalizedString(@"Pickup_location", nil)];
    [_DropField setPlaceholder:JJLocalizedString(@"Drop_location", nil)];
    
    [_eta_drop_hint setText:JJLocalizedString(@"Drop", nil)];
    [_eta_header_lbl setText:JJLocalizedString(@"Ride_Estimation", nil)];
    [_eta_pickup_hinty setText:JJLocalizedString(@"Pickup", nil)];
    [EstiamtionCloseButton setTitle:JJLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    
    //[_rideLater_btn setTitle:JJLocalizedString(@"RIDE_LATER", nil) forState:UIControlStateNormal];
    //[_rideNow_btn setTitle:JJLocalizedString(@"RIDE_NOW", nil) forState:UIControlStateNormal];
    //[CancelButton setTitle:JJLocalizedString(@"CANCEL", nil) forState:UIControlStateNormal];
    //[ConfirmButton setTitle:JJLocalizedString(@"CONFIRM", nil) forState:UIControlStateNormal];
    
//    [_rideLater_btn createTitle:@"BOOK RIDE FOR LATER" withIcon:[UIImage imageNamed:@"Invoice"]
//                font:[UIFont fontWithName:@"RobotoCondensed-Bold" size:13.0f]
//                iconHeight:28
//                iconOffsetY:-4];

    NSString * YourWallet=JJLocalizedString(@"Your_wallet_money", nil);
    YourWallet= @"WALLET :";
    RideNow_WalletAmount_lbl.text=[NSString stringWithFormat:@"%@ %@",YourWallet,[Themes GetFullWallet]];
    
}

- (void)configCustomButton:(JTImageButton *)btn
{
    btn.titleColor = [UIColor whiteColor];
    btn.padding = JTImageButtonPaddingBig;
    btn.bgColor = [UIColor clearColor];
    btn.cornerRadius = 0.0;
    btn.borderWidth = 1.0;
    btn.borderColor = [UIColor whiteColor];
    btn.iconSide = JTImageButtonIconSideRight;
}

- (void)configCustomButton1:(JTImageButton *)btn
{
    btn.titleColor = [UIColor whiteColor];
    btn.padding = JTImageButtonPaddingBig;
    btn.cornerRadius = 0.0;
    btn.borderWidth = 1.0;
    btn.bgColor = BGCOLOR;
    btn.borderColor = [UIColor whiteColor];
    btn.iconSide = JTImageButtonIconSideRight;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * loc=[locations lastObject];
    if(loc.coordinate.latitude!=0){
        currentLocation=manager;
        latitude =loc.coordinate.latitude;
        longitude =loc.coordinate.longitude;
         if(self.isLoadSingleTime==NO){
            Camera = [GMSCameraPosition cameraWithLatitude: loc.coordinate.latitude
                                                 longitude: loc.coordinate.longitude
                                                      zoom:17];
            GoogleMap = [GMSMapView mapWithFrame:BGmapView.frame camera:Camera];
            self.isLoadSingleTime=YES;
            CGRect mapFrame=GoogleMap.frame;
            mapFrame.origin.y=0;
            GoogleMap.frame=mapFrame;
            GoogleMap.delegate = self;
            [BGmapView addSubview:GoogleMap];
            [BGmapView addSubview:_defaultAnno];
            GoogleMap.myLocationEnabled = YES;
            GoogleMap.userInteractionEnabled=YES;
            BGmapView.userInteractionEnabled=YES;
            [self updateUserLocation];
         }
    }
}

-(void)enteredForeground{
    if(self.view.window){
        [[ATAppUpdater sharedUpdater] showUpdateWithForce];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[ATAppUpdater sharedUpdater] showUpdateWithForce];
    ConfirmButton.enabled=YES;
    [currentLocation startUpdatingLocation];
    if(latitude!=0){
        [self updateUserLocation];
    }
    _connectionTimer = [NSTimer scheduledTimerWithTimeInterval: 20
                                                        target: self
                                                      selector: @selector(refreshLocation)
                                                      userInfo: nil
                                                       repeats: YES];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_connectionTimer invalidate];
    _connectionTimer=nil;
    [currentLocation stopUpdatingLocation];
 
}

-(void)refreshLocation{
    
    
    @try {
        [NSThread detachNewThreadSelector:@selector(CheckHomepage) toTarget:self withObject:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in checkConnectionTimer..");
    }

}

-(void)CheckHomepage
{
    
    [self mapView:GoogleMap idleAtCameraPosition:GoogleMap.camera];

}
-(void)checklocation:(CLLocationManager *)location
{
    if (location.location.coordinate.latitude == 0 && location.location.coordinate.longitude == 0)
    {
        
        currentLocation = [[CLLocationManager alloc] init];
        [currentLocation requestWhenInUseAuthorization];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
            [currentLocation requestAlwaysAuthorization];
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
            [currentLocation requestAlwaysAuthorization];
            
        }
        //[currentLocation startUpdatingLocation];
        [currentLocation startMonitoringSignificantLocationChanges];
        currentLocation.delegate=self;
        
        Camera = [GMSCameraPosition cameraWithLatitude: currentLocation.location.coordinate.latitude
                                             longitude: currentLocation.location.coordinate.longitude
                                                  zoom:17];
    }
    else
    {
//        [currentLocation startUpdatingLocation];
        latitude=location.location.coordinate.latitude;
        longitude=location.location.coordinate.longitude;
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if([CLLocationManager locationServicesEnabled])
    {
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            NSString * titlemsg=JJLocalizedString(@"App_Permission_Denied", nil);
            NSString * messagecontant=JJLocalizedString(@"To_reenable_please", nil);
            
            
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:titlemsg
                                                               message:messagecontant
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
        }
    }
}
-(void)ApplyCoupoun:(NSNotification *)notification

{
    if ([Themes GetCoupon].length>0)
    {
        CouponCoudLable.text=[Themes GetCoupon];
        lateCouponlbl.text=[Themes GetCoupon];
    }
    else{
        CouponCoudLable.text=JJLocalizedString(@"Apply_Coupon", nil) ;
        lateCouponlbl.text=JJLocalizedString(@"Apply_Coupon", nil) ;
    }
}
- (void) RemoveTimer:(NSNotification *)notification
{
    [self view:InfoView boolen:YES];
    [self view:FavoriteBTN boolen:YES];
    [self view:CancelButton boolen:YES];
    [self view:ConfirmButton boolen:YES];
    [self view:AddressField boolen:YES];
    [self view:_btnMenu boolen:YES];
    [self view:_HeaderConfirmation_View boolen:YES];
     [self view:_DropField boolen:YES];
    [timingLoading2 invalidate];
    [timingLoading invalidate];
    
}

/*- (void) notification:(NSNotification *)notification
 {
 if ([notification.object isKindOfClass:[FareRecord class]])
 {
 
 // FareVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"FareVCID"];
 NewViewController * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"NewFareVCID"];
 FareRecord*Rec=(FareRecord*)notification.object;
 Rec=[notification object];
 [addfavour setObjRc:Rec];
 [self presentViewController:addfavour animated:YES completion:nil];
 }
 
 }*/
//- (void) reviewVc:(NSNotification *)notification
//{
//    if ([notification.object isKindOfClass:[FareRecord class]])
//    {
//        //if(self.view.window){
//        RatingVC *objRatingVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
//        FareRecord*Rec=(FareRecord*)notification.object;
//        [objRatingVC setRideID_Rating :Rec.ride_id];
//        [self.navigationController pushViewController:objRatingVC animated:YES];
//        //}
//        
//    }
//}

- (void) incomingNotification:(NSNotification *)notification{
    
    if ([notification.object isKindOfClass:[FavourRecord class]])
    {
        message = [notification object];
        latitude=message.latitudeStr;
        longitude=message.longitude;
        AddressField.text=message.Address;
        selectedBtnIndex=0;
        Favour=YES;
        Camera = [GMSCameraPosition cameraWithLatitude: latitude
                                             longitude: longitude
                                                  zoom:17];
        [GoogleMap animateToCameraPosition:Camera];
        
        
        
    }
    else
    {
        NSLog(@"Error, object not recognised.");
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [nameArray count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CarCtryCell *cell = (CarCtryCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if([nameArray count]>0){
        BookingRecord *objRecord=(BookingRecord*)[nameArray objectAtIndex:indexPath.row];
        
        [cell setDelegate:self];
        [cell setSelectiveIndexpath:indexPath];
        [cell setDatasToCategoryCell:objRecord];
        
    }
    return cell;

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    //return  (space > 0) ? space : 0;
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    CGSize screenSize      = [[UIScreen mainScreen] bounds].size;
    CGFloat widthOfScreen  = screenSize.width;
    CGFloat space = (widthOfScreen - 304) / 2;
    return space;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)getCurrentLocation:(id)sender
{
    
    CLLocation *location = GoogleMap.myLocation;
    if (location) {
        CLLocationCoordinate2D myCoordinate = GoogleMap.myLocation.coordinate;
        latitude=myCoordinate.latitude;
        longitude=myCoordinate.longitude;
        
        [GoogleMap animateToLocation:location.coordinate];
        [GoogleMap animateToZoom:15.0];
        GoogleMap.padding = UIEdgeInsetsMake(64, 0, 64, 0);
        
        [Themes StopView:self.view];
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField==AddressField)
    {
        SearchControl=YES;
        
        searchView.hidden=NO;
        searchView.alpha = 0.1;
        [UIView animateWithDuration:0.50 animations:^{
            searchView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            searchView.hidden=NO;
            [search becomeFirstResponder];
            AddressField.text=@"";
            search.text=@"";
            filteredContentList=nil;
            
            [tblContentList reloadData];
        }];
    }
    else if (textField==_DropField)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DropVC *objDropVC=[storyboard instantiateViewControllerWithIdentifier:@"DropVCID"];
        objDropVC.delegate=self;
        [self.navigationController pushViewController:objDropVC animated:YES];
    }
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (SearchControl==YES)
    {
        searchView.hidden=YES;
        [searchBar resignFirstResponder];
        [UIView animateWithDuration:1.0 animations:^{
            [searchView setAlpha:0.1f];
        } completion:^(BOOL finished) {
            searchView.hidden = YES;
            
        }];
    }
    
    else if (SearchControl==NO)
    {
        [_HeaderConfirmation_View setHidden:NO];
        searchView.hidden=YES;
        [searchBar resignFirstResponder];
        [UIView animateWithDuration:1.0 animations:^{
            [searchView setAlpha:0.1f];
        } completion:^(BOOL finished) {
            searchView.hidden = YES;
            
        }];
        
        if ([iswhichEstimate isEqualToString:@"RideNow"])
        {
            InfoView.hidden=NO;
            LateInfoView.hidden=YES;
        }
        else if ([iswhichEstimate isEqualToString:@"RideLater"])
        {
            InfoView.hidden=YES;
            LateInfoView.hidden=NO;

        }
        
        [_AddressView setHidden:NO];
        DownView.hidden=NO;
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
}
-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    self.isMoveStarted=YES;
    if (Favour==YES)
    {
        AddressField.text=message.Address;
        [self GetHomePages:selectedBtnIndex];
    }
    else if (Favour==NO)
    {
        [AddressField resignFirstResponder];
        if(isLocationSelected==NO){
            AddressField.placeholder=JJLocalizedString(@"Getting_Address", nil);
        }
        
        latitude=mapView.camera.target.latitude;
        longitude=mapView.camera.target.longitude;
        //[Themes StartView:self.view];
        
        
        [self getGoogleAdrressFromLatLong:latitude lon:longitude];
    }
    Favour=NO;
}

-(void)ifNoAddress{
    AddressField.placeholder =JJLocalizedString(@"Sorry_we_couldnt_fetch", nil);
    
    //[CtryViewCell setHidden:YES];
    [_CtryView setHidden:YES];

    [_rideNow_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_rideNow_btn setUserInteractionEnabled:NO];
    
    [_rideLater_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_rideLater_btn setUserInteractionEnabled:NO];
    [_defaultAnno setUserInteractionEnabled:NO];
}

-(void)isHaveAddress:(NSString *)addStr{
    AddressField.text=[Themes checkNullValue:addStr];
//    [CtryViewCell setHidden:NO];
    [_CtryView setHidden:NO];

    [_rideNow_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rideNow_btn setUserInteractionEnabled:YES];
    
    [_rideLater_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rideLater_btn setUserInteractionEnabled:YES];
    [_defaultAnno setUserInteractionEnabled:YES];
    
    isLocationSelected=NO;
    nameArray=[NSMutableArray new];
    [nameArray removeAllObjects];
    if(self.isMoveStarted==YES){
    [self GetHomePages:selectedBtnIndex];
    }
    [Themes StopView:self.view];
    
}





- (NSRange)fullRange
{
    return (NSRange){0, [addressString length]};
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField==AddressField)
    {
        if(range.location==0&&[string isEqualToString:@","]){
            return NO;
        }
    }
    
    return YES;
}

#pragma Address From Lat And Lng

/*-(NSString*)getAddressFromLatLong :(CGFloat )lat longitude:(CGFloat )lng
 
 {
 
 NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%f,%f", lat,lng];
 NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
 NSMutableDictionary *data = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingMutableContainers error:nil];
 NSMutableArray *dataArray = (NSMutableArray *)[data valueForKey:@"results" ];
 if (dataArray.count == 0) {
 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter a valid address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
 [alert show];
 }else{
 for (id firstTime in dataArray) {
 NSString *jsonStr1 = [firstTime valueForKey:@"formatted_address"];
 return jsonStr1;
 }
 }
 
 return nil;
 }*/
-(void)getGoogleAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon{
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getGoogleLatLongToAddress:[self setParametersForAddr:lat withLon:lon]
                           success:^(NSMutableDictionary *responseDictionary)
     {
         @try {
             NSArray* jsonResults = [[responseDictionary valueForKey:@"results"]valueForKey:@"formatted_address"];
             if([jsonResults count]>0){
                 NSString * str;
                 if(jsonResults.count>=2){
                     str=[Themes checkNullValue: [jsonResults objectAtIndex:0]];
                 }else{
                     str=[Themes checkNullValue: [jsonResults objectAtIndex:0]];
                 }
                 if(str.length==0){
                     [self ifNoAddress];
                 }else{
                     [self isHaveAddress:str];
                 }
                 
             }else{
                 [self Toast:@"can't find address"];
                 [self ifNoAddress];
             }
         }
         @catch (NSException *exception) {
             
         }
         
        
     }
                           failure:^(NSError *error)
     {
         [self Toast:@"can't find address"];
          [self ifNoAddress];
         
     }];
    
}

-(NSDictionary *)setParametersForAddr:(float )lat withLon:(float)lon{
    
    NSDictionary *dictForuser = @{
                                  @"latlng":[NSString stringWithFormat:@"%f,%f",lat,lon],
                                  @"sensor":@"false",
                                  @"key":GoogleServerKey
                                  };
    return dictForuser;
}
/*-(void)latitude:(CGFloat )lat longitude:(CGFloat )lng
 {
 [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(lat, lng) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
 
 GMSAddress * address=[response firstResult];
 NSString * temp1=[address.lines objectAtIndex:0];
 NSString *temp2=[address.lines objectAtIndex:1];
 //NSString * final=[NSString stringWithFormat:@"%@, %@", temp1 ,temp2];
 
 NSString *undesired = @"(null),(null)";
 NSString *desired   = @"";
 
 addressString=[NSString stringWithFormat:@"%@,%@",temp1,temp2];
 
 if ([addressString isEqualToString:@"(null),(null)"])
 {
 AddressField.text=@"Getting Address..";
 }
 
 else
 {
 
 AddressField.text = [addressString stringByReplacingOccurrencesOfString:undesired
 withString:desired];
 AddressField.text = addressString;
 }
 }];
 
 
 }*/

//Anand
-(void)getGoogleAdrressFromStr:(NSString *)addrStr{
    

    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getGoogleLatLongToAddress:[self setParametersToaddr:addrStr]
                           success:^(NSMutableDictionary *responseDictionary)
     {
         @try {
             NSArray* jsonResults = [responseDictionary valueForKey:@"results"][0][@"geometry"][@"location"];
             if([jsonResults count]>0){
                 double latitude1 = 0, longitude1 = 0;
                 
                 latitude1 = [[jsonResults valueForKey:@"lat"] doubleValue];
                 longitude1 = [[jsonResults valueForKey:@"lng"] doubleValue];
                 
                 
                 
                 
                 NSArray *results = (NSArray *) responseDictionary[@"results"];
                 
                 if ([results count]>0)
                 {
                     
                     if (SearchControl==YES)
                     {
                         center.latitude = latitude1;
                         center.longitude = longitude1;
                         
                         [GoogleMap animateToLocation:CLLocationCoordinate2DMake(center.latitude, center.longitude)];
                         [GoogleMap animateToZoom:14.0];
                         isLocationSelected=YES;
                         
                         latitude=latitude1;
                         longitude=longitude1;
                         
                         
                         [Themes StopView:self.view];
                         SearchControl=NO;
                         
                     }
                     
                     else if (SearchControl==NO)
                     {
                         
                         //japahar
                                         droplatitude=latitude1;
                                         droplongitude=longitude1;
                         [self dataEstiamtion];

                     }
                 }
                 else
                 {
                     //Anand
                     //                 UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Cabily" message:@"" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                     //                 [alert show];
                     
                     [self Toast:@"Can't_fetch_Address"];
                 }
                 
                 
                 
             }else{
                 [self Toast:@"Can't_fetch_Address"];
             }
         }
         @catch (NSException *exception) {
             
         }
        
         
        
     }
                           failure:^(NSError *error)
     {
         
         [self Toast:@"Can't_fetch_Address"];
         [Themes StopView:self.view];
         
         
     }];
 }


-(NSDictionary *)setParametersToaddr:(NSString *)addr{
    
    NSDictionary *dictForuser = @{
                                  @"address":addr,
                                  @"sensor":@"false",
                                  @"key":GoogleServerKey
                                  };
    return dictForuser;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [filteredContentList count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.text = [filteredContentList objectAtIndex:indexPath.row];
    return cell;
    
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([searchBar.text isEqualToString:@""])
    {
        filteredContentList=nil;
        
    }
    else
    {
        
        NSString *text1=[searchBar.text stringByAppendingString:text];
        if ([text1 containsString:@"\n"])
        {
            [search resignFirstResponder];
            
        }
        else
        {
            
            @try{

            NSString *searchbartxt=[text1 stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&language=en&key=AIzaSyDe-8elGxbNPtTNn6k_uBo983Mw245XEug",searchbartxt];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *responseObject)
             {
                 
                 NSError *error = [operation error];
                 
                 NSDictionary *json =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                 if (json==nil)
                 {
                     NSString * wrongaddress=JJLocalizedString(@"kindly_Search_valid_Address", nil);
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:wrongaddress delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 if (json>0) {
                     SearchResultArray= (NSMutableArray *) json[@"predictions"];
                     filteredContentList  = (NSMutableArray *) [SearchResultArray valueForKey:@"description"];
                     
                     [self updateTableWithFilteredData:filteredContentList];
                     
                 }
             }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"Error: %@", error);
                 }];
                
            }
            @catch (NSException *e) {
                
                NSLog(@"Exception in Reachability Notification..%@",e);
            }

            
        }
    }
    return YES;
}
- (void)updateTableWithFilteredData:(NSMutableArray *)filteredData
{
    filteredContentList = filteredData;
    [tblContentList reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [search resignFirstResponder];
    GoogleMap.padding = UIEdgeInsetsMake(64, 0, 64, 0);
    
    isLocationSelected=YES;
    search.text=[filteredContentList objectAtIndex:indexPath.row];
    //Anand
    if (SearchControl==YES)
    {
        [self getGoogleAdrressFromStr:[filteredContentList objectAtIndex:indexPath.row]];
        [searchView setHidden:YES];
        AddressField.text=[filteredContentList objectAtIndex:indexPath.row];
//        SearchControl=NO;
        
        
    }
    else if (SearchControl==NO)
    {
        DropAddressSrting=[filteredContentList objectAtIndex:indexPath.row];
        [self getGoogleAdrressFromStr:[filteredContentList objectAtIndex:indexPath.row]];
    }
    
    
}

-(void)updateUserLocation
{
    
    NSString*latitudeStr=[NSString stringWithFormat:@"%f",latitude];
    NSString*longitudeStr=[NSString stringWithFormat:@"%f",longitude];
    
    NSDictionary * parameters=@{@"user_id":UserID,
                                @"latitude":latitudeStr,
                                @"longitude":longitudeStr};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
     [web GetGoeUpate:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];
         if ([responseDictionary count]>0)
         {
             //[RideView setBackgroundColor:BGCOLOR];
             [RideView setUserInteractionEnabled:YES];
             responseDictionary=[Themes writableValue:responseDictionary];
             
             NSString * comfiramtion=[Themes checkNullValue:[responseDictionary valueForKey:@"status"]];
             NSString * alert=[Themes checkNullValue:[responseDictionary valueForKey:@"message"]];
             [Themes StopView:self.view];
             if ([comfiramtion isEqualToString:@"1"])
             {
                
                 [Themes StopView:self.view];
                 
                 [Themes SaveWallet:[Themes checkNullValue:[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"wallet_amount"]]]];
                 CarCategoryString=[Themes checkNullValue:[Themes writableValue:[responseDictionary valueForKey:@"category_id"]]];
                 
                 Currency=[Themes checkNullValue:[responseDictionary valueForKey:@"currency"]];
                 Currency=[Themes findCurrencySymbolByCode:Currency];
                 [Themes SaveFullWallet:[NSString stringWithFormat:@"%@%@",Currency,[Themes GetWallet]]];
                 if(_isFirstTime==NO){
                     _isFirstTime=YES;
                     
                 }
                 
                 
             }
             else
             {
                  [self Toast:@"Error in connection"];
                 
                 [Themes StopView:self.view];
                 
             }
             
         }
         
         
     }
             failure:^(NSError *error)
     {
         [Themes StopView:self.view];
//         [RideView setBackgroundColor:[UIColor lightGrayColor]];
         [RideView setUserInteractionEnabled:NO];
         [_defaultAnno setUserInteractionEnabled:NO];
     }];
    
}
#pragma  mark --- CategoryButton action

-(void)buttonWasPressed:(NSIndexPath *)SelectedIndexPath
{
    isInitialButtonSelected=YES;
    if([nameArray count]>0){
        BookingRecord * objBookingRecord=[nameArray objectAtIndex:SelectedIndexPath.row];
        CarCategoryString=objBookingRecord.categoryID;
        selectedBtnIndex=SelectedIndexPath.row;
        [GoogleMap animateToZoom:15.0];
        [Themes StartView:self.view];
       
        [self GetHomePages:SelectedIndexPath.row];
    }
}

#pragma  mark --- Timer
-(void)timerBlock
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Timer called");
    });
}
#pragma  mark --- GetHomePages

-(void)GetHomePages:(NSInteger)index
{
    [_rideNow_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_rideNow_btn setUserInteractionEnabled:NO];
    
    [_rideLater_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_rideLater_btn setUserInteractionEnabled:NO];
    [_defaultAnno setUserInteractionEnabled:NO];

    [Themes StopView:self.view];
    
    NSString*latitudeStr=[NSString stringWithFormat:@"%f",latitude];
    NSString*longitudeStr=[NSString stringWithFormat:@"%f",longitude];
    
    NSDictionary * parameters=@{@"user_id":UserID,
                                @"lat":latitudeStr,
                                @"lon":longitudeStr,
                                @"category":CarCategoryString};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    //[Themes StartView:self.view];
    [_loadingView_View startAnimation];
    [_timing_label setHidden:YES];
    [_clock_imageview setHidden:YES];
    [_staticMinus_Lbl setHidden:YES];
    nameArray=[[NSMutableArray alloc]init];
    
    [web GetMapView:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         [_rideNow_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [_rideNow_btn setUserInteractionEnabled:YES];
         
         [_rideLater_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [_rideLater_btn setUserInteractionEnabled:YES];
         
         if([responseDictionary count]==0 || responseDictionary==nil)
         {
             
             
             [_rideNow_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
             [_rideNow_btn setUserInteractionEnabled:NO];
             
             [_rideLater_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
             [_rideLater_btn setUserInteractionEnabled:NO];
             [_defaultAnno setUserInteractionEnabled:NO];
             [_defaultAnno setUserInteractionEnabled:NO];

             [Themes StopView:self.view];
             
         }
         else
         {
             [_defaultAnno setUserInteractionEnabled:YES];

             ResponseArray=[[NSMutableDictionary alloc]initWithDictionary:responseDictionary];
             //NSLog(@"%@",responseDictionary);
             responseDictionary=[Themes writableValue:responseDictionary];
             [Themes StopView:self.view];
             
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             NSString * alert=[responseDictionary valueForKey:@"response"];
             [Themes StopView:self.view];
             [_loadingView_View stopAnimation];
             
             if ([comfiramtion isEqualToString:@"1"])
             {
                 //[CtryViewCell setHidden:NO];
                 [_CtryView setHidden:NO];
                 
                 [_rideNow_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 [_rideNow_btn setUserInteractionEnabled:YES];
                 
                 [_rideLater_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 [_rideLater_btn setUserInteractionEnabled:YES];
                 [_defaultAnno setUserInteractionEnabled:YES];
                 
                 if([nameArray count]!=0)
                 {
                     [nameArray removeAllObjects];
                 }
                 //Anand
//                 else
//                 {
                     for (NSDictionary * objCatDict in responseDictionary[@"response"][@"category"]) {
                         categaory=[[BookingRecord alloc]init];
                         categaory.categoryID=[objCatDict valueForKey:@"id"];
                         categaory.categoryETA=[objCatDict valueForKey:@"eta"];
                         categaory.categoryName=[objCatDict valueForKey:@"name"];
                         categaory.Normal_image=[objCatDict valueForKey:@"icon_normal"];
                         categaory.Active_Image=[objCatDict valueForKey:@"icon_active"];
                         categaory.isSelected=NO;
                         [nameArray addObject:categaory];
                         //   }
                     }
                     
//                 }
                 
                 categaory.currency=[[ResponseArray valueForKey:@"response"] valueForKey:@"currency"];
                 NSDictionary * rateCard=[[ResponseArray valueForKey:@"response"] valueForKey:@"ratecard"];
                 
                 if ([rateCard count]>0)
                 {
                     categaory.note=[rateCard valueForKey:@"note"];
                     
                     NSDictionary * FareDict=[rateCard valueForKey:@"farebreakup"];
                     if ([FareDict count]>0)
                     {
                         categaory.vehicletypes=[FareDict valueForKey:@"vehicletypes"];
                         categaory.amountafter_fare=[[FareDict valueForKey:@"after_fare"]valueForKey:@"amount"];
                         categaory.after_fare_text=[[FareDict valueForKey:@"after_fare"]valueForKey:@"text"];
                         categaory.amountmin_fare=[[FareDict valueForKey:@"min_fare"]valueForKey:@"amount"];
                         categaory.min_fare_text=[[FareDict valueForKey:@"min_fare"]valueForKey:@"text"];
                         categaory.amountother_fare=[[FareDict valueForKey:@"other_fare"]valueForKey:@"amount"];
                         categaory.other_fare_text=[[FareDict valueForKey:@"other_fare"]valueForKey:@"text"];
                         categaory.categorySubName=[FareDict valueForKey:@"category"];
                     }
                     
                 }
                 
                 Currency=[Themes findCurrencySymbolByCode:categaory.currency];
                 [Themes SaveCurrency:Currency];
                 
                 if([nameArray count]>0){
                     
                     
                     for (int i=0; i<[nameArray count]; i++) {
                         BookingRecord * objBookingRecord=[nameArray objectAtIndex:i];
                         if(index==i){
                             objBookingRecord.isSelected=YES;
                             nameofcar=objBookingRecord.categoryName;
                             CarCategoryString=objBookingRecord.categoryID;
                             ETAtimeTaking=objBookingRecord.categoryETA;
                             [_timing_label setHidden:NO];
                             [_clock_imageview setHidden:NO];
                             [_staticMinus_Lbl setHidden:NO];
                             NSString*tep =[ETAtimeTaking stringByReplacingOccurrencesOfString:@" Mins" withString:@""];
                             if ([tep containsString:@"mins"])
                             {
                                 tep =[ETAtimeTaking stringByReplacingOccurrencesOfString:@" mins" withString:@""];
                             }
                             if ([tep isEqualToString:@"1"] ||[tep isEqualToString:@"0"])
                             {
                                 [_staticMinus_Lbl setText:@"Min"];
                             }
                             else
                             {
                                 [_staticMinus_Lbl setText:@"Mins"];
                             }
                             
                             [_timing_label setText:tep];
                             
                         }
                         else
                         {
                             objBookingRecord.isSelected=NO;
                             
                         }
                         
                         [nameArray setObject:objBookingRecord atIndexedSubscript:i];
                     }
                 }
                 
                 if ([nameArray count]<=0)
                 {
                     
                     [_rideNow_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                     [_rideNow_btn setUserInteractionEnabled:NO];
                     
                     [_rideLater_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                     [_rideLater_btn setUserInteractionEnabled:NO];
                     [_defaultAnno setUserInteractionEnabled:NO];
                     
                     //[CtryViewCell setHidden:YES];
                     [_CtryView setHidden:YES];

                     [Themes StopView:self.view];
                     [_loadingView_View stopAnimation];
                     
                 }
                 else
                 {
                     //[CtryViewCell setHidden:NO];
                     [_CtryView setHidden:NO];

                     
                     [_rideNow_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                     [_rideNow_btn setUserInteractionEnabled:YES];
                     
                     [_rideLater_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                     [_rideLater_btn setUserInteractionEnabled:YES];
                     [_defaultAnno setUserInteractionEnabled:YES];
                     
                     [self AddAndRemooveAnnotation];
                     [CtryViewCell reloadData];
                 }
                 
                 if ([ETAtimeTaking isEqualToString:@"No cabs"] || [ETAtimeTaking isEqualToString:@"no cabs"])
                 {
                     
                     //[CtryViewCell setHidden:NO];
                     [_CtryView setHidden:NO];

                     [_rideNow_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                     [_rideNow_btn setUserInteractionEnabled:NO];
                     
                    
                     NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
                     if([language hasPrefix:@"es"]){
                          [_defaultAnno setImage:[UIImage imageNamed:@"nopindropes"] forState:UIControlStateNormal];
                     }
                     else
                     {
                          [_defaultAnno setImage:[UIImage imageNamed:@"nopindrop"] forState:UIControlStateNormal];
                     }
                     [_loadingView_View setHidden:NO];
                     [_timing_label setHidden:YES];
                     [_clock_imageview setHidden:YES];
                     [_staticMinus_Lbl setHidden:YES];
                     [_defaultAnno setUserInteractionEnabled:NO];
                 }
                 else
                 {
                     
                     //[CtryViewCell setHidden:NO];
                     [_CtryView setHidden:NO];

                     [_rideNow_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                     [_rideNow_btn setUserInteractionEnabled:YES];
                     
                     [_rideLater_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                     [_rideLater_btn setUserInteractionEnabled:YES];
                     
                     NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
                     if([language hasPrefix:@"es"]){
                         [_defaultAnno setImage:[UIImage imageNamed:@"pindropes"] forState:UIControlStateNormal];
                     }
                     else
                     {
                         [_defaultAnno setImage:[UIImage imageNamed:@"pindrop"] forState:UIControlStateNormal];
                     }
                     
                     [_loadingView_View setHidden:NO];
                     [_timing_label setHidden:NO];
                     [_clock_imageview setHidden:NO];
                     [_staticMinus_Lbl setHidden:NO];
                     [_defaultAnno setUserInteractionEnabled:YES];
                     
                 }
                 
             }
             else
             {
                 //[CtryViewCell setHidden:YES];
                 [_CtryView setHidden:YES];

                 [_rideNow_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                 [_rideNow_btn setUserInteractionEnabled:NO];
                 [_defaultAnno setUserInteractionEnabled:NO];
                 [_rideLater_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                 [_rideLater_btn setUserInteractionEnabled:NO];
                 NSString *titleStr = JJLocalizedString(@"Oops", nil);
                 if ([alert isEqualToString:@"Error in connection"]) {
                     
                     alert = JJLocalizedString(@"Error in connection", nil);
                 }
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
             }
         }
     }
     
            failure:^(NSError *error)
     {
         [Themes StopView:self.view];
         [_loadingView_View stopAnimation];
         
         
     }];
    
}
#pragma  mark --- AddAndRemooveAnnotation

-(void)AddAndRemooveAnnotation
{
    NSMutableArray *aray =[[ResponseArray valueForKey:@"response"] valueForKey:@"drivers"];
    
    if ([aray count]>0) {
        NSString * result = [aray componentsJoinedByString:@""];
        
        [GoogleMap clear];
        if ([result isEqualToString:@""])
        {
            
            
        }
        for(int i=0;i<[aray count];i++){
            NSDictionary *dict=(NSDictionary *)[aray objectAtIndex:i];
            double la=[[dict objectForKey:@"lat"] doubleValue];
            double lo=[[dict objectForKey:@"lon"] doubleValue];
            
            CLLocation * loca=[[CLLocation alloc]initWithLatitude:la longitude:lo];
            CLLocationCoordinate2D coordi=loca.coordinate;
            
            GMSMarker*marker=[[GMSMarker alloc]init];
            marker=[GMSMarker markerWithPosition:coordi];
            marker.map = GoogleMap;
            marker.appearAnimation=kGMSMarkerAnimationPop;
            
            UIImage *mapicon=[UIImage imageNamed:[self getMapMarkerImage]];
            marker.icon = mapicon;
            
            [CtryViewCell reloadData];
            
        }
    }
    else
    {
        [GoogleMap clear];
        
    }
}

-(NSString *)getMapMarkerImage{
    NSString * imgStr;
    if([nameofcar isEqualToString:@"MINI"]||[nameofcar isEqualToString:@"Cabily Mini"] ||[nameofcar isEqualToString:@"Mini"]){
        imgStr=@"MiniCab";
    }else if ([nameofcar isEqualToString:@"Seedan"]||[nameofcar isEqualToString:@"Cabily Sedan"]||[nameofcar isEqualToString:@"Sedan"]){
        imgStr=@"SedanCab";
    }else if ([nameofcar isEqualToString:@"Prime"]||[nameofcar isEqualToString:@"Cabily Prime"]||[nameofcar isEqualToString:@"Prime"]){
        imgStr=@"PrimCab";
    }
    else
    {
        imgStr=@"Othercab";
    }
    return imgStr;
}

#pragma  mark --- ViewAnimation

-(void)ViewShowing:(UIView *)views
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

-(void)ViewHidding:(UIView *)views
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

#pragma  mark --- RideNow
- (IBAction)Anno_Action:(id)sender {
    UIButton *btnAuthOptions=(UIButton*)sender;
    btnAuthOptions.tag=2;
    [_PickUpAddress_label setText:AddressField.text];
    [self RideNow:sender];
}

-(IBAction)RideNow:(id)sender
{
    if (![AddressField.text isEqualToString:@""])
    {
        UIButton *btnAuthOptions=(UIButton*)sender;
        if (btnAuthOptions.tag==1)//LAter
        {
            [_defaultAnno setUserInteractionEnabled:NO];
            //[_loadingView_View setHidden:YES];
            [_defaultAnno setHidden:YES];
            [_ConfirmPin setHidden:NO];
            [_AddressView setHidden:NO];
            
            [_PickUpAddress_label setText:AddressField.text];
            
            [_Header_view setHidden:YES];
            [_HeaderConfirmation_View setHidden:NO];
            _topLbl.text = @"  SELECT YOUR DROP OFF LOCATION";
            
            [_DropField setText:@""];
            ButtontypeStr=@"1";
            IsPickerView=YES;
            isETAView=YES;
            AddressField.enabled=NO;
            GoogleMap.userInteractionEnabled=NO;
            BGmapView.userInteractionEnabled=NO;
            locationBtn.hidden=YES;
            pickerView.hidden=NO;
            FavoriteBTN.userInteractionEnabled=NO;
        }
        else if (btnAuthOptions.tag==2) { //NOW
            if([nameArray count]>0){
            
            [_defaultAnno setUserInteractionEnabled:NO];
            //[_loadingView_View setHidden:YES];
            [_defaultAnno setHidden:YES];
            [_ConfirmPin setHidden:NO];
            [_AddressView setHidden:NO];
            [_PickUpAddress_label setText:AddressField.text];
            [_DropField setText:@""];
            
            [_Header_view setHidden:YES];
            [_HeaderConfirmation_View setHidden:NO];
            _topLbl.text = @"  SELECT YOUR DROP OFF LOCATION";

            ButtontypeStr=@"0";
            //CtryViewCell.hidden=YES;
            [_CtryView setHidden:YES];

            DownView.hidden=NO;
            AddressField.enabled=NO;
            [AddressField setTextColor:[UIColor lightGrayColor]];
            GoogleMap.userInteractionEnabled=NO;
            BGmapView.userInteractionEnabled=NO;
            locationBtn.hidden=YES;
            isETAView=NO;
            InfoView.hidden=NO;
            NSString * YourWallet=JJLocalizedString(@"Your_wallet_money", nil);
            YourWallet= @"WALLET :";
            RideNow_WalletAmount_lbl.text=[NSString stringWithFormat:@"%@ %@",YourWallet,[Themes GetFullWallet]];
            
            BookingRecord *record = [nameArray objectAtIndex:selectedBtnIndex];
                
            // xiao
            _infotimeLbl.text=record.categoryETA;
            _infocarnameLbl.text=record.categoryName;
            _infocarnameLbl.text = [_infocarnameLbl.text stringByReplacingOccurrencesOfString:@"Exotic " withString:@""];
                
            [_infocarImageView sd_setImageWithURL:[NSURL URLWithString:record.Active_Image] placeholderImage:[UIImage imageNamed:@"CabPlaceholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
                
                
            [UIView animateWithDuration:0.50 animations:^{
                InfoView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                
                NSString * FromNow=JJLocalizedString(@"from_now", nil);
                infoPicktimeLable.text=[NSString stringWithFormat:@"%@ %@",ETAtimeTaking,FromNow];
                CategoryLable.text=nameofcar;
                
            }];
            FavoriteBTN.userInteractionEnabled=NO;
        }
        }
    }
    else
    {
        [self Toast:@"We_are_fetching_your"];
    }
    
}

#pragma  mark --- LateinfoView Pickerdate change

-(IBAction)latepickerDate:(id)sender
{
    ButtontypeStr=@"1";
    
    AddressField.enabled=NO;
    GoogleMap.userInteractionEnabled=NO;
    BGmapView.userInteractionEnabled=NO;
    locationBtn.hidden=YES;
    LateInfoView.hidden=YES;
    IsPickerView=NO;
    pickerView.hidden=NO;
}
#pragma  mark --- LateinfoView name change

-(IBAction)lateCategoryName:(id)sender
{
    AddressField.enabled=NO;
    GoogleMap.userInteractionEnabled=NO;
    BGmapView.userInteractionEnabled=NO;
    locationBtn.hidden=YES;
    LateInfoView.hidden=YES;
    _latepicker.delegate=self;
    _latepicker.dataSource=self;
    _latepickerView.hidden=NO;
}
#pragma  mark --- UIPickerview Datasource
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [nameArray count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    BookingRecord *object=(BookingRecord*)[nameArray objectAtIndex:row];
    return object.categoryName;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    BookingRecord *object=(BookingRecord*)[nameArray objectAtIndex:row];
    _latepicker.showsSelectionIndicator=YES;
    nameofcar=object.categoryName;
    CarCategoryString=object.categoryID;
    selectedBtnIndex=[_latepicker selectedRowInComponent:0];
}
#pragma  mark --- Header Cancel

- (IBAction)backfrom_action:(id)sender {
    UIButton *btnAuthOptions=(UIButton*)sender;
    btnAuthOptions.tag=1;
    
    [_defaultAnno setUserInteractionEnabled:YES];
    [_loadingView_View setHidden:NO];
    [_defaultAnno setHidden:NO];
    [_ConfirmPin setHidden:YES];
    
    [self Confimation:sender];
    //[self PickerAction:sender];
    [_defaultAnno setUserInteractionEnabled:YES];
    [_loadingView_View setHidden:NO];
    [_defaultAnno setHidden:NO];
    [_ConfirmPin setHidden:YES];
    pickerView.hidden=YES;
    _latepickerView.hidden=YES;
}
#pragma  mark --- Cancel and Confirm

-(IBAction)Confimation:(id)sender
{
    
    UIButton *btnAuthOptions=(UIButton*)sender;
    if (btnAuthOptions.tag==1) {    //Cancel
        [_defaultAnno setUserInteractionEnabled:YES];
        [_loadingView_View setHidden:NO];
        [_defaultAnno setHidden:NO];
        [_ConfirmPin setHidden:YES];
        DownView.hidden=YES;
        //CtryViewCell.hidden=NO;
        [_CtryView setHidden:NO];

        [_Header_view setHidden:NO];
        [_HeaderConfirmation_View setHidden:YES];
        _topLbl.text = @"  SELECT YOUR PICK UP LOCATION";

        AddressField.enabled=YES;
        GoogleMap.userInteractionEnabled=YES;
        BGmapView.userInteractionEnabled=YES;
        locationBtn.hidden=NO;
        [AddressField setTextColor:[UIColor blackColor]];
        [_AddressView setHidden:YES];
        
        
        [UIView animateWithDuration:0.50 animations:^{
            [InfoView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            InfoView.hidden=YES;
        }];
        
        [UIView animateWithDuration:0.50 animations:^{
            [LateInfoView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            LateInfoView.hidden=YES;
        }];
        FavoriteBTN.userInteractionEnabled=YES;
        
        
    } else if (btnAuthOptions.tag==2) { //CONFIRM
        ConfirmButton.enabled=NO;
        DownView.hidden=NO;
        [self ConfirmRide];
    }
}
#pragma  mark --- ConfirmRide


-(void)ConfirmRide
{
    
    
    if ([ButtontypeStr isEqualToString:@"1"])
    {
        pickUptime=DelayTimeStr;
        pickupdate=DelayDateStr;
    }
    else if ([ButtontypeStr isEqualToString:@"0"])
    {
        pickUptime=TimeString;
        pickupdate=DateString;
        
    }
    if ([CouponCoudLable.text isEqualToString:JJLocalizedString(@"Apply_Coupon", nil)]||[lateCouponlbl.text isEqualToString:JJLocalizedString(@"Apply_Coupon", nil)])
    {
        
        couponCode=@"";
        
    }
    else
    {
        couponCode=[Themes GetCoupon];
    }
    
    NSString*PicklatitudeStr=[NSString stringWithFormat:@"%f",latitude];
    NSString*PicklongitudeStr=[NSString stringWithFormat:@"%f",longitude];
    NSString*DroplatitudeStr=[NSString stringWithFormat:@"%f",droplatitude];
    NSString*DroplongitudeStr=[NSString stringWithFormat:@"%f",droplongitude];
    
    
    NSDictionary *parameters=@{@"user_id":[Themes writableValue:UserID],
                               @"pickup":[Themes writableValue:AddressField.text],
                               @"drop_loc":[Themes writableValue:_DropField.text],
                               @"pickup_lat":[Themes writableValue:PicklatitudeStr],
                               @"pickup_lon":[Themes writableValue:PicklongitudeStr],
                               @"drop_lat":[Themes writableValue:DroplatitudeStr],
                               @"drop_lon":[Themes writableValue:DroplongitudeStr],
                               @"category":[Themes writableValue:CarCategoryString],
                               @"type":[Themes writableValue:ButtontypeStr],
                               @"pickup_date":[Themes writableValue:pickupdate],
                               @"pickup_time":[Themes writableValue:pickUptime],//"06:17 PM";
                               @"code":[Themes writableValue:couponCode]};//[Themes GetCoupon]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web ConfirmRide:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         responseDictionary=[Themes writableValue:responseDictionary];
         
         if([responseDictionary count]>0)
         {
             NSLog(@"%@",responseDictionary);
             NSString * status=[responseDictionary valueForKey:@"status"];
             NSString * response=[responseDictionary valueForKey:@"response"];
             if ([status isEqualToString:@"0"])
             {
                 [Themes StopView:self.view];

                 UIAlertView* Wrongalert =[[UIAlertView alloc]initWithTitle:@"Sorry\xF0\x9F\x9A\xAB" message:response delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Wrongalert show];
                 ConfirmButton.enabled=YES;

                 
             }
             
             else
             {
                 ConfirmButton.enabled=YES;

                 NSString * type=[[responseDictionary valueForKey:@"response"] valueForKey:@"type"];
                 categaory.timinrloading=[[responseDictionary valueForKey:@"response"] valueForKey:@"response_time"];
                 categaory.Booking_ID=[[responseDictionary valueForKey:@"response"]valueForKey:@"ride_id"];
                 
                 bookingIdStr=[Themes checkNullValue:[[responseDictionary valueForKey:@"response"]valueForKey:@"ride_id"]];
                 
                 if ([type isEqualToString:@"1"])
                 {
                     [Themes StopView:self.view];
                     [Themes SaveCoupon:@""];
                     isChangingNetwork=YES;
                     
                     if (showinAlert==NO)
                     {
                         NSString * successfullybooked=JJLocalizedString(@"Your_book_successfully_registerd", nil);
                         NSString * messageSTR   =[NSString stringWithFormat:@"%@ %@",successfullybooked,pickUptime];
                         ConfrimAlertlater =[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:messageSTR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [ConfrimAlertlater show];
                         showinAlert=YES;
                     }
                     AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     [del LogIn];
                     
                     
                 }
                 else
                 {
                     timingLoading= [NSTimer scheduledTimerWithTimeInterval:[categaory.timinrloading doubleValue]
                                                                     target:self
                                                                   selector:@selector(loadingView)
                                                                   userInfo:nil
                                                                    repeats:NO];
                     [Themes StopView:self.view];
                     [Themes SaveCoupon:@""];
                     isChangingNetwork=YES;
                     
                     
                     TimeViewTiming=[[[NSBundle mainBundle] loadNibNamed:@"TimeView" owner:self options:nil] objectAtIndex:0];
                     
                     TimeViewTiming.frame=self.view.frame;
                     [TimeViewTiming setUserInteractionEnabled:YES];
                     
                     [self view:InfoView boolen:NO];
                     [self view:FavoriteBTN boolen:NO];
                     [self view:CancelButton boolen:NO];
                     [self view:ConfirmButton boolen:NO];
                     [self view:AddressField boolen:NO];
                     [self view:_btnMenu boolen:NO];
                     [self view:_HeaderConfirmation_View boolen:NO];
                     [self view:_DropField boolen:NO];
                     [self.view addSubview:TimeViewTiming];
                     [self.view bringSubviewToFront:TimeViewTiming.closereq];
                     [TimeViewTiming setRecordObj:categaory];
                     
                     isRetry=YES;
                     
                 }
                 
             }
             
             
         }
         
         
         
         
     }
             failure:^(NSError *error)
     {
         [Themes StopView:self.view];
         ConfirmButton.enabled=YES;

         
     }];
    
}
-(void)view:(UIView *)Views boolen:(BOOL)boolean
{
    [Views setUserInteractionEnabled:boolean];
}
#pragma  mark --- Timing View

-(void)loadingView
{
    if (isRetry==YES)
    {
        [self view:InfoView boolen:YES];
        [self view:FavoriteBTN boolen:YES];
        [self view:CancelButton boolen:YES];
        [self view:ConfirmButton boolen:YES];
        [self view:AddressField boolen:YES];
        [self view:_btnMenu boolen:YES];
         [self view:_DropField boolen:YES];
        
        [Themes StopView:self.view];
        NSString * nodriver=JJLocalizedString(@"No_Driver_Available_RETRY", nil);
        if(self.view.window)
        {
        
        RetryAlert=[[UIAlertView alloc]initWithTitle:@"Sorry\xF0\x9F\x9A\xAB" message:nodriver delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
        [RetryAlert show];
        }
    }
    else if (isRetry==NO)
    {
        [self view:InfoView boolen:YES];
        [self view:FavoriteBTN boolen:YES];
        [self view:CancelButton boolen:YES];
        [self view:ConfirmButton boolen:YES];
        [self view:AddressField boolen:YES];
        [self view:_btnMenu boolen:YES];
         [self view:_DropField boolen:YES];

        [timingLoading2 invalidate];
        [timingLoading invalidate];
        [Themes StopView:self.view];
        [self cancelRide];
    }
    
}
#pragma  mark --- Ride Confirm Notification

- (void) pushnotification:(NSNotification *)notification
{
    
    [timingLoading invalidate]; //key 5
    [timingLoading2 invalidate];
    [Themes StopView:self.view];
    
    
    [self view:InfoView boolen:YES];
    [self view:FavoriteBTN boolen:YES];
    [self view:CancelButton boolen:YES];
    [self view:ConfirmButton boolen:YES];
    [self view:AddressField boolen:YES];
    [self view:_btnMenu boolen:YES];
     [self view:_DropField boolen:YES];
    
    [TimeViewTiming removeFromSuperview];
    
    if ([notification.object isKindOfClass:[NSDictionary class]])
    {
        
        Record_Driver.Driver_Name=[notification.object valueForKey:@"key2"];
        Record_Driver.Car_Name=[notification.object valueForKey:@"key12"];
        Record_Driver.Car_Number=[notification.object valueForKey:@"key11"];
        Record_Driver.latitude_driver=[[notification.object valueForKey:@"key6"] doubleValue];
        Record_Driver.longitude_driver=[[notification.object valueForKey:@"key7"] doubleValue];
        Record_Driver.Driver_moblNumber=[notification.object valueForKey:@"key10"];
        Record_Driver.ETA=[notification.object valueForKey:@"key8"];
        Record_Driver.message=[notification.object valueForKey:@"message"];
        Record_Driver.latitude_User=[[notification.object valueForKey:@"key14"]doubleValue];
        Record_Driver.longitude_User=[[notification.object valueForKey:@"key15"]doubleValue];
        Record_Driver.Ride_ID=[notification.object valueForKey:@"key9"];
        Record_Driver.rating=[notification.object  valueForKey:@"key5"];
        Record_Driver.DriverImage=[notification.object valueForKey:@"key4"];
        Record_Driver.isCancel=YES;
      //  [currentLocation stopUpdatingLocation];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NewTrackVC*objNewTrackVC=[storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
        [objNewTrackVC setTrackObj:Record_Driver];
        [self.navigationController pushViewController:objNewTrackVC animated:YES];
        
        
    }
    else
    {
       
    }
    
    
    
}

#pragma  mark --- PickerAction Cancel and Done LateinfoView
- (IBAction)latepiackerAction:(id)sender {
    UIBarButtonItem *btnAuthOptions=(UIBarButtonItem*)sender;
    if (btnAuthOptions.tag==1)
    {
        _latepickerView.hidden=YES;
        LateInfoView.hidden=NO;
    }
    else if (btnAuthOptions.tag==2) {
        
        if ([nameArray count]>0) {
            _latepickerView.hidden=YES;
            LateInfoView.hidden=NO;
            lateCabLable.text=nameofcar;
            
            [self GetHomePages:selectedBtnIndex];
        }
    }
}

#pragma  mark --- PickerAction Cancel and Done Ride Later

-(IBAction)PickerAction:(id)sender
{
    UIBarButtonItem *btnAuthOptions=(UIBarButtonItem*)sender;
    if (btnAuthOptions.tag==1) //cancel
    {
        
        if (IsPickerView==YES)
        {
            [_loadingView_View setHidden:NO];
            [_defaultAnno setHidden:NO];
            [_ConfirmPin setHidden:YES];
            pickerView.hidden=YES;
            GoogleMap.userInteractionEnabled=YES;
            BGmapView.userInteractionEnabled=YES;
            
            locationBtn.hidden=NO;
            
            FavoriteBTN.userInteractionEnabled=YES;
            [_Header_view setHidden:NO];
            [_HeaderConfirmation_View setHidden:YES];
            _topLbl.text = @"  SELECT YOUR PICK UP LOCATION";

            [_AddressView setHidden:YES];
            
        }
        else if (IsPickerView==NO)
        {
            [_loadingView_View setHidden:YES];
            [_defaultAnno setHidden:YES];
            [_ConfirmPin setHidden:NO];
            pickerView.hidden=YES;
            GoogleMap.userInteractionEnabled=NO;
            BGmapView.userInteractionEnabled=NO;
            
            locationBtn.hidden=YES;
            LateInfoView.hidden=NO;
            
        }
        
    }
    
    else if (btnAuthOptions.tag==2) { //done
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"YYYY-MM-dd"];
        
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"hh:mm a"];
        
        DelayDateStr = [NSString stringWithFormat:@"%@",
                        [df stringFromDate:RidelatePicker.date]];
        
        DelayTimeStr = [NSString stringWithFormat:@"%@",
                        [timeFormat stringFromDate:RidelatePicker.date]];
        
        pickerView.hidden=YES;
        
        NSString * YourWallet=JJLocalizedString(@"Your_wallet_money", nil);
        
        RideLater_WalletAmount_lbl.text=[NSString stringWithFormat:@"%@ %@",YourWallet,[Themes GetFullWallet]];
        
        
        locationBtn.hidden=NO;
        
//        CtryViewCell.hidden=YES;
        [_CtryView setHidden:YES];

        DownView.hidden=NO;
        AddressField.enabled=NO;
        [AddressField setTextColor:[UIColor lightGrayColor]];
        GoogleMap.userInteractionEnabled=NO;
        BGmapView.userInteractionEnabled=NO;
        
        locationBtn.hidden=YES;
        
        LateInfoView.hidden=NO;
        
        [UIView animateWithDuration:0.50 animations:^{
            LateInfoView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
            NSDateFormatter *dateFormet = [[NSDateFormatter alloc] init];
            
            [dateFormet setDateFormat:@"YYYY-MM-dd"];
            
            NSDate *date = [dateFormet dateFromString:DelayDateStr];
            
            [dateFormet setDateFormat:@"MM-dd"];
            
            NSString *finalDate = [dateFormet stringFromDate:date];
            
            NSDateFormatter *timeFormate = [[NSDateFormatter alloc] init];
            
            [timeFormate setDateFormat:@"hh:mm a"];
            
            NSDate *Time = [timeFormate dateFromString:DelayTimeStr];
            
            [timeFormate setDateFormat:@"hh:mm a"];
            
            NSString *finalTime = [timeFormate stringFromDate:Time];
            
            NSString*compained=[NSString stringWithFormat:@"%@,%@",finalDate,finalTime];
            latePickUplbl.text=compained;
            lateCabLable.text=nameofcar;
    
        }];
        
        
    }
    
}
- (IBAction)LabelChange:(id)sender
{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY-MM-dd"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    
    DelayDateStr = [NSString stringWithFormat:@"%@",
                    [df stringFromDate:RidelatePicker.date]];
    
    DelayTimeStr = [NSString stringWithFormat:@"%@",
                    [timeFormat stringFromDate:RidelatePicker.date]];
    
}
#pragma  mark --- FavourView Moving

- (IBAction)signMeUpButtonPressed:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FavorVC * addfavour = [storyboard instantiateViewControllerWithIdentifier:@"FavourVCID"];
    
    AddObj.addressStr=AddressField.text;
    AddObj.ADDlatitude=latitude;
    AddObj.ADDlongitude=longitude;
    [addfavour setObjRecord:AddObj];
    
    [self.navigationController pushViewController:addfavour animated:YES];
}
#pragma  mark --- RateCard View

-(IBAction)rateCard:(id)sender
{
    
    RateCardViewVC * rateamount_view=[[[NSBundle mainBundle] loadNibNamed:@"RateCardViewVC" owner:self options:nil] objectAtIndex:0];
    rateamount_view.frame=self.view.frame;
    rateamount_view.Total_Rate_View.center=self.view.center;
    [self.view addSubview:rateamount_view];
    [self.view bringSubviewToFront:rateamount_view];
    [rateamount_view setObjrecord:categaory];
    
    
    
}

-(void)rateCardDetails:(BookingRecord*)objRecord
{
    RateCardCatLable.text=objRecord.categorySubName;
    RateCardVechielLable.text=objRecord.vehicletypes;
    MinFarelable.text=[NSString stringWithFormat:@"%@%@",Currency, objRecord.amountmin_fare];
    Minfare_text.text=objRecord.min_fare_text;
    AfterFareLable.text=[NSString stringWithFormat:@"%@%@",Currency,  objRecord.amountafter_fare];
    Afterfare_text.text=objRecord.after_fare_text;
    WaitingfareLable.text=[NSString stringWithFormat:@"%@%@",Currency,objRecord.amountother_fare];
    waitingfare_text.text=objRecord.other_fare_text;
    notelabel.text=objRecord.note;
    
}
-(IBAction)EtaRateCard:(id)sender
{
    [self rateCard:nil];
}
#pragma  mark --- Estimation View

- (IBAction)onEstimate:(id)sender
{
    if(![_DropField.text  isEqual: @""])
    {
        iswhichEstimate=@"RideNow";
        SearchControl=NO;
        DropAddressSrting=_DropField.text;
        [self getGoogleAdrressFromStr:_DropField.text];
    }
    else
    {
        [_AddressView setHidden:YES];
        
        SearchControl=NO;
        [_HeaderConfirmation_View setHidden:YES];
        iswhichEstimate=@"RideNow";
        searchView.hidden=NO;
        DownView.hidden=YES;
        searchView.alpha = 0.1;
        [UIView animateWithDuration:0.50 animations:^{
            searchView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            searchView.hidden=NO;
            search.text=@"";
            [search becomeFirstResponder];
            InfoView.hidden=YES;
            
        }];
        if([filteredContentList count]>0){
            filteredContentList=nil;
        }
        [tblContentList reloadData];
    }
}

-(void)Estimate:(UITapGestureRecognizer *)sender
{
    UIView *view = sender.view; //cast pointer to the derived class if needed
    
    
    if (view.tag==12)
    {
        
        if(![_DropField.text  isEqual: @""])
        {
            iswhichEstimate=@"RideNow";
            SearchControl=NO;
            DropAddressSrting=_DropField.text;
            [self getGoogleAdrressFromStr:_DropField.text];
        }
        else
        {
            [_AddressView setHidden:YES];
            
            SearchControl=NO;
            [_HeaderConfirmation_View setHidden:YES];
            iswhichEstimate=@"RideNow";
            searchView.hidden=NO;
            DownView.hidden=YES;
            searchView.alpha = 0.1;
            [UIView animateWithDuration:0.50 animations:^{
                searchView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                searchView.hidden=NO;
                search.text=@"";
                [search becomeFirstResponder];
                InfoView.hidden=YES;
                
            }];
            if([filteredContentList count]>0){
                filteredContentList=nil;
            }
            [tblContentList reloadData];
        }
    }
    else if (view.tag==22)
    {
        SearchControl=NO;
        [_HeaderConfirmation_View setHidden:YES];
        iswhichEstimate=@"RideLater";
        searchView.hidden=NO;
        DownView.hidden=YES;
        searchView.alpha = 0.1;
        [UIView animateWithDuration:0.50 animations:^{
            searchView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            searchView.hidden=NO;
            search.text=@"";
            [search becomeFirstResponder];
            LateInfoView.hidden=YES;
            
        }];
        if([filteredContentList count]>0){
            filteredContentList=nil;
        }
        [tblContentList reloadData];
    }
}

#pragma mark - Data Estimation
-(void)dataEstiamtion
{
    [_eta_pickup_hinty setText:JJLocalizedString(@"Pickup", nil)];
    if ([ButtontypeStr isEqualToString:@"1"])
    {
        pickUptime=DelayTimeStr;
        pickupdate=DelayDateStr;
    }
    else if ([ButtontypeStr isEqualToString:@"0"])
    {
        pickUptime=TimeString;
        pickupdate=DateString;
        
    }
    
    
    NSString*PicklatitudeStr=[NSString stringWithFormat:@"%f",latitude];
    NSString*PicklongitudeStr=[NSString stringWithFormat:@"%f",longitude];
    
    NSString*DroplatitudeStr=[NSString stringWithFormat:@"%f",droplatitude];
    NSString*DroplongitudeStr=[NSString stringWithFormat:@"%f",droplongitude];
    
    NSDictionary *parameters=@{@"user_id":UserID,
                               @"pickup":AddressField.text,
                               @"drop":DropAddressSrting,
                               @"pickup_lat":PicklatitudeStr,
                               @"pickup_lon":PicklongitudeStr,
                               @"drop_lat":DroplatitudeStr,
                               @"drop_lon":DroplongitudeStr,
                               @"category":CarCategoryString,
                               @"type":ButtontypeStr,
                               @"pickup_date":pickupdate,
                               @"pickup_time":pickUptime};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web GetEta:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         [Themes StopView:self.view];
         if ([responseDictionary count]>0)
         {
             responseDictionary=[Themes writableValue:responseDictionary];
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             NSString * alert=[responseDictionary valueForKey:@"response"]; // //@"message"
             [Themes StopView:self.view];
             if ([comfiramtion isEqualToString:@"1"])
             {
                 estiamtion.attString=[[[responseDictionary valueForKey:@"response"]valueForKey:@"eta"]valueForKey:@"att"];
                 estiamtion.dropStr=[[[responseDictionary valueForKey:@"response"]valueForKey:@"eta"]valueForKey:@"drop"];
                 estiamtion.PickupStr=[[[responseDictionary valueForKey:@"response"]valueForKey:@"eta"]valueForKey:@"pickup"];
                 estiamtion.min_amount=[[[responseDictionary valueForKey:@"response"]valueForKey:@"eta"]valueForKey:@"min_amount"];
                 estiamtion.max_amount=[[[responseDictionary valueForKey:@"response"]valueForKey:@"eta"]valueForKey:@"max_amount"];
                 estiamtion.note=[[[responseDictionary valueForKey:@"response"]valueForKey:@"eta"]valueForKey:@"note"];
                 
                 [self EstimationDetails:estiamtion];
                 [EstimationDetailView setHidden:NO];
                 
             }
             else
             {
                 NSString *titleStr = JJLocalizedString(@"Oops", nil);
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
             }
         }
         
         
         
     }
        failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
    
}
-(void)EstimationDetails:(EstimationRecord *)estimate
{
    searchView.hidden=YES;
    
    dropLable.text=estimate.dropStr;
    pickUplable.text=estimate.PickupStr;
    
    NSString *amount=[NSString stringWithFormat:@"%@ %@ - %@ %@",Currency, estimate.min_amount,Currency,estimate.max_amount];
    minilable.text=amount;
    //maxlable.text=;
    NSString * approx=JJLocalizedString(@"APPOX_TRAVEL_TIME", nil);
    
    NSString *TimeLable=[NSString stringWithFormat:@"%@ %@",approx,estimate.attString];
    attLable.text=TimeLable;
    noteLable.text=estimate.note;
}
-(IBAction)ETAClose:(id)sender
{
    EstimationDetailView.hidden=YES;
    [_AddressView setHidden:NO];
    
    if (isETAView==NO)
    {
        LateInfoView.hidden=YES;
        DownView.hidden=NO;
        InfoView.hidden=NO;
        [_HeaderConfirmation_View setHidden:NO];
    }
    else if (isETAView==YES)
    {
        InfoView.hidden=YES;
        DownView.hidden=NO;
        LateInfoView.hidden=NO;
        [_HeaderConfirmation_View setHidden:NO];
    }

}

#pragma  mark --- Alert Coupon
- (IBAction)onApplyCoupon:(id)sender
{
    [self CallCoupon];
}

-(void)CallCoupon
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CopounVC * ObjCopounVC = [storyboard instantiateViewControllerWithIdentifier:@"CopounVCID"];
    if ([ButtontypeStr isEqualToString:@"1"])
    {
        [ObjCopounVC setDate:DelayDateStr];
        
    }
    else if ([ButtontypeStr isEqualToString:@"0"])
    {
        
        [ObjCopounVC setDate:DateString];
        
    }
    [self.navigationController pushViewController:ObjCopounVC animated:YES];
    
    
}
#pragma  mark --- Alert Delegate Retry Cancel and Coupon

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([CouponCoudLable.text isEqualToString:JJLocalizedString(@"Apply_Coupon", nil)]||[lateCouponlbl.text isEqualToString:JJLocalizedString(@"Apply_Coupon", nil)])
    {
        couponCode=@"";
    }
    else
    {
        couponCode=CouponTextField.text;
    }
    if (alertView==ConfrimAlertlater)
    {
        ConfrimAlertlater = nil;
    }
    
    else if (alertView==couponAlert)
    {
        if ([ButtontypeStr isEqualToString:@"1"])
        {
            pickUptime=DelayTimeStr;
            pickupdate=DelayDateStr;
        }
        else if ([ButtontypeStr isEqualToString:@"0"])
        {
            pickUptime=TimeString;
            pickupdate=DateString;
            
        }
        
        if (buttonIndex == 1)
        {
            NSDictionary *parameters=@{@"user_id":UserID,
                                       @"code":CouponTextField.text,
                                       @"pickup_date":pickupdate};
            
            UrlHandler *web = [UrlHandler UrlsharedHandler];
            [Themes StartView:self.view];
            [web ApplyCoupon:parameters success:^(NSMutableDictionary *responseDictionary) {
                
                [Themes StopView:self.view];
                if ([responseDictionary count]>0)
                {
                    responseDictionary=[Themes writableValue:responseDictionary];
                    NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                    
                    [Themes StopView:self.view];
                    if ([comfiramtion isEqualToString:@"1"])
                    {
                        NSString * alert=[[responseDictionary valueForKey:@"response"]valueForKey:@"message"];
                        categaory.CouponCode=[[responseDictionary valueForKey:@"response"]valueForKey:@"code"];
                        [Themes SaveCoupon:categaory.CouponCode];
                        CouponCoudLable.text=categaory.CouponCode;
                        lateCouponlbl.text=categaory.CouponCode;
                        UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [Alert show];
                        
                    }
                    else
                    {
                        NSString * alert=[responseDictionary valueForKey:@"response"];
                        NSString *titleStr = JJLocalizedString(@"Oops", nil);
                        UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [Alert show];
                        [Themes SaveCoupon:@""];
                        CouponCoudLable.text=JJLocalizedString(@"Apply_Coupon", nil) ;
                        lateCouponlbl.text=JJLocalizedString(@"Apply_Coupon", nil) ;
                    }
                    
                }
            }
                     failure:^(NSError *error) {
                         [Themes StopView:self.view];
                         
                         
                     }];
        }
        
    }
    
    else if (alertView==RetryAlert)
    {
        if (buttonIndex == 0)
        {
            
            NSString*PicklatitudeStr=[NSString stringWithFormat:@"%f",latitude];
            NSString*PicklongitudeStr=[NSString stringWithFormat:@"%f",longitude];
            NSString*DroplatitudeStr=[NSString stringWithFormat:@"%f",droplatitude];
            NSString*DroplongitudeStr=[NSString stringWithFormat:@"%f",droplongitude];
            NSDictionary *parameters=@{@"user_id":[Themes writableValue:UserID],
                                       @"pickup":[Themes writableValue:AddressField.text],
                                       @"drop_loc":[Themes writableValue:_DropField.text],
                                       @"drop_lat":[Themes writableValue:DroplatitudeStr],
                                       @"drop_lon":[Themes writableValue:DroplongitudeStr],
                                       @"pickup_lat":[Themes writableValue:PicklatitudeStr],
                                       @"pickup_lon":[Themes writableValue:PicklongitudeStr],
                                       @"category":[Themes writableValue:CarCategoryString],
                                       @"type":[Themes writableValue:ButtontypeStr],
                                       @"pickup_date":[Themes writableValue:DateString],
                                       @"pickup_time":[Themes writableValue:TimeString],
                                       @"Code":[Themes writableValue:couponCode],
                                       @"ride_id":[Themes checkNullValue:bookingIdStr],
                                       @"try":@"2"};//[Themes GetCoupon]};
            
            UrlHandler *web = [UrlHandler UrlsharedHandler];
            [Themes StartView:self.view];
            [web ConfirmRide:parameters success:^(NSMutableDictionary *responseDictionary)
             
             {
                 [Themes StopView:self.view];
                 if ([responseDictionary count]>0)
                 {
                     responseDictionary=[Themes writableValue:responseDictionary];
                     if ([[responseDictionary valueForKey:@"status"] isEqualToString:@"1"]) {
                         
                         
                         
                         if ([[responseDictionary valueForKey:@"acceptance"] isEqualToString:@"Yes"])
                         {
                             
                             Record_Driver.Driver_Name=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"driver_name"];
                             Record_Driver.Car_Name=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"vehicle_model"];
                             Record_Driver.Car_Number=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"vehicle_number"];
                             Record_Driver.latitude_driver=[[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"driver_lat"] doubleValue];
                             Record_Driver.longitude_driver=[[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"driver_lon"] doubleValue];
                             Record_Driver.Driver_moblNumber=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"phone_number"];
                             Record_Driver.ETA=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"min_pickup_duration"];
                             Record_Driver.rating=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"driver_review"];
                             Record_Driver.latitude_User=[PicklatitudeStr doubleValue];
                             Record_Driver.longitude_User=[PicklongitudeStr doubleValue];
                             Record_Driver.Ride_ID=[[responseDictionary valueForKey:@"response"]valueForKey:@"ride_id"];
                             Record_Driver.message=[[responseDictionary valueForKey:@"response"]valueForKey:@"message"];
                             Record_Driver.isCancel=YES;
                             //Record_Driver.DriverImage=[[responseDictionary valueForKey:@"message"] valueForKey:@"key5"];
                            // [currentLocation stopUpdatingLocation];
                             
                             isChangingNetwork=YES;
                             // TrackRideVC*objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"TrackRideVCID"];
                             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                             NewTrackVC*objLoginVC=[storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
                             [objLoginVC setTrackObj:Record_Driver];
                             [self.navigationController pushViewController:objLoginVC animated:YES];
                         }
                         else
                         {
                             
                             categaory.timinrloading=[[responseDictionary valueForKey:@"response"] valueForKey:@"response_time"];
                             timingLoading2= [NSTimer scheduledTimerWithTimeInterval:[categaory.timinrloading doubleValue]
                                                                              target:self
                                                                            selector:@selector(loadingView)
                                                                            userInfo:nil
                                                                             repeats:NO];
                             isChangingNetwork=YES;
                             
                             categaory.Booking_ID=[[responseDictionary valueForKey:@"response"]valueForKey:@"ride_id"];
                             bookingIdStr=[Themes checkNullValue:[[responseDictionary valueForKey:@"response"]valueForKey:@"ride_id"]];
                             
                             [Themes StopView:self.view];
                             //[self.view setUserInteractionEnabled:NO];
                             
                             
                             [self view:InfoView boolen:NO];
                             [self view:FavoriteBTN boolen:NO];
                             [self view:CancelButton boolen:NO];
                             [self view:ConfirmButton boolen:NO];
                             [self view:AddressField boolen:NO];
                             [self view:_btnMenu boolen:NO];
                             [self view:_HeaderConfirmation_View boolen:NO];
                             [self view:_DropField boolen:NO];
                             
                             TimeViewTiming=[[[NSBundle mainBundle] loadNibNamed:@"TimeView" owner:self options:nil] objectAtIndex:0];
                             [TimeViewTiming setRecordObj:categaory];
                             TimeViewTiming.frame=self.view.frame;
                             TimeViewTiming.Timing.center=self.view.center;
                             TimeViewTiming.hintView.center=CGPointMake(self.view.center.x,self.view.center.y-100);
                             [self.view addSubview:TimeViewTiming];
                             isRetry=NO;
                         }
                     }
                     else{
                         
                         NSString *Msg=[Themes checkNullValue:[responseDictionary valueForKey:@"response"]];
                         UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:Msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [Alert show];
                     }
                     
                 }
                 
                 
                 
             }
                     failure:^(NSError *error)
             {
                 [Themes StopView:self.view];
             }];
        }
        else if (buttonIndex==1)
        {
            [self cancelRide];
        }
    }
}
#pragma  mark --- Cancel Ride

-(void)cancelRide
{
    NSDictionary *parameters=@{@"user_id":UserID,
                               @"ride_id":bookingIdStr};//[Themes GetCoupon]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web Bookingcancel:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         NSLog(@"%@",responseDictionary);
         [Themes StopView:self.view];
         NSString *status=[responseDictionary valueForKey:@"status"];
         {
             if ([status isEqualToString:@"1"]) {
                 if ([responseDictionary count]>0)
                 {
                     responseDictionary=[Themes writableValue:responseDictionary];
                     
                     [Themes StopView:self.view];
                     NSString * cancelled=JJLocalizedString(@"Booking_Request_Cancelled", nil);
                     UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:cancelled delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [Alert show];
                     
                 }
             }
             else
             {
                 NSString *Msg=[responseDictionary valueForKey:@"response"];
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:Msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
             }
         }
         
         
         
         
         
     }
               failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
}
-(void)passDropLatLong:(CLLocation *)dLoc withDropTxt:(NSString *)dropPlace{
    droplatitude=dLoc.coordinate.latitude;
    droplongitude=dLoc.coordinate.longitude;
    _DropField.text=dropPlace;
    
}

@end
