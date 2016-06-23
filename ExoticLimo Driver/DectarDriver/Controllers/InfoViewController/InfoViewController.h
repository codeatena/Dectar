//
//  InfoViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/26/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"
#import "Constant.h"
#import "UrlHandler.h"
#import "CancelRideViewController.h"
#import "TPFloatRatingView.h"
#import "RootBaseViewController.h"

@interface InfoViewController : RootBaseViewController<TPFloatRatingViewDelegate>
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *infoScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *phoneNoBtn;
@property (weak, nonatomic) IBOutlet TPFloatRatingView *ratingsView;
@property (weak, nonatomic) IBOutlet UIButton *cancelTripBtn;
@property(strong,nonatomic)NSString * rideId;
- (IBAction)didClickBackBtn:(id)sender;

- (IBAction)didClickPhoneBtn:(id)sender;

- (IBAction)didClickCancelTripBtn:(id)sender;
@end
