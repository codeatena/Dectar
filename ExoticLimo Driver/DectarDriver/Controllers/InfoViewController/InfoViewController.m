//
//  InfoViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/26/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize infoScrollView,userImageView,userNameLbl,phoneNoBtn,ratingsView,cancelTripBtn,headerLbl,rideId,custIndicatorView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFont];
    cancelTripBtn.userInteractionEnabled=NO;
    [self loadIUserData];
    // Do any additional setup after loading the view.
}
-(void)setFont{
    userImageView.layer.cornerRadius=userImageView.frame.size.width/2;
    userImageView.layer.masksToBounds=YES;
    headerLbl=[Theme setHeaderFontForLabel:headerLbl];
    userNameLbl=[Theme setHeaderFontForLabel:userNameLbl];
    phoneNoBtn=[Theme setLargeFontForButton:phoneNoBtn];
    cancelTripBtn=[Theme setBoldFontForButton:cancelTripBtn];
    [cancelTripBtn setBackgroundColor:SetThemeColor];
    [cancelTripBtn setTitle:JJLocalizedString(@"Cancel_Trip", nil) forState:UIControlStateNormal];
    [headerLbl setText:JJLocalizedString(@"Info", nil)];
    
//    cancelTripBtn.layer.cornerRadius=2;
//    cancelTripBtn.layer.masksToBounds=YES;
}
-(void)loadIUserData{
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getUserInformation:[self setParametersForUserInformation]
                   success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             cancelTripBtn.userInteractionEnabled=YES;
             NSDictionary * UserDict=responseDictionary[@"response"][@"information"];
            
                 NSString * imgstr=[UserDict objectForKey:@"user_image"];
             
             [userImageView sd_setImageWithURL:[NSURL URLWithString:imgstr] placeholderImage:[UIImage imageNamed:@"PlaceHolderImg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                 
             }];
             
                 headerLbl.text=[Theme checkNullValue:[UserDict objectForKey:@"user_name"]];
                 userNameLbl.text=[Theme checkNullValue:[UserDict objectForKey:@"user_name"]];
                 [phoneNoBtn setTitle:[Theme checkNullValue:[UserDict objectForKey:@"user_phone"]] forState:UIControlStateNormal];
                 NSString * userReview=[Theme checkNullValue:[UserDict objectForKey:@"user_review"]];
             [self loadRating:userReview];
             
         }else{
             
             [self.view makeToast:kErrorMessage];
         }
     }
                   failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [self.view makeToast:kErrorMessage];
         
     }];
}
-(NSDictionary *)setParametersForUserInformation{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"ride_id":rideId
                                  };
    return dictForuser;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showActivityIndicator:(BOOL)isShow{
    if(isShow==YES){
        if(custIndicatorView==nil){
            custIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStylePulse color:SetThemeColor];
            
        }
        custIndicatorView.center =self.view.center;
        [custIndicatorView startAnimating];
        [self.view addSubview:custIndicatorView];
        [self.view bringSubviewToFront:custIndicatorView];
    }
}
-(void)stopActivityIndicator{
    [custIndicatorView stopAnimating];
    custIndicatorView=nil;
}

- (IBAction)didClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickPhoneBtn:(id)sender {
    NSString * phoneNum=[NSString stringWithFormat:@"tel:%@",phoneNoBtn.titleLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
}

- (IBAction)didClickCancelTripBtn:(id)sender {
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    CancelRideViewController * objCancelVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CancelVCSID"];
    [objCancelVC setRideId:rideId];
    [self.navigationController pushViewController:objCancelVC animated:YES];
}
-(void)loadRating:(NSString *)ratingCount{
    float rateCount=[ratingCount floatValue];
    self.ratingsView.delegate = self;
    self.ratingsView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
    self.ratingsView.fullSelectedImage = [UIImage imageNamed:@"StarFill"];
    self.ratingsView.contentMode = UIViewContentModeScaleAspectFill;
    self.ratingsView.maxRating = 5;
    self.ratingsView.minRating = 1;
    self.ratingsView.rating = rateCount;
    self.ratingsView.editable = NO;
    self.ratingsView.halfRatings = YES;
    self.ratingsView.floatRatings = YES;
}
@end
