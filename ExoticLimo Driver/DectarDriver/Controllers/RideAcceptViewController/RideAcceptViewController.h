//
//  RideAcceptViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/24/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RideAcceptRecord.h"
#import "Theme.h"
#import "Constant.h"
#import "RootBaseViewController.h"
#import "UrlHandler.h"
#import "DectarCustomColor.h"
#import <CoreLocation/CoreLocation.h>
#import "RideUserViewController.h"
#import "RiderRecords.h"
#import <AVFoundation/AVFoundation.h>
#import "RootBaseViewController.h"
#import "RequestAcceptTableViewCell.h"
#import "KKProgressTimer.h"
#import "UIView+MGBadgeView.h"

@protocol RideAcceptDelegate<NSObject>
-(void)ridecancelled;
@end

@interface RideAcceptViewController : UIViewController<CLLocationManagerDelegate,requestOptionDelegate,UITableViewDataSource,UITableViewDelegate,KKProgressTimerDelegate>
{
    AVAudioPlayer * audioPlayer;
    AVAudioPlayer * audioPlayer1;
}
@property(strong,nonatomic)id<RideAcceptDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *acceptHeaderLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *rideAcceptScrollView;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *requestTableView;
@property (weak, nonatomic) IBOutlet UIButton *badgeBtn;



@property(assign,nonatomic) float countValue;
@property(assign,nonatomic) float setMaximumValue;
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
@property(strong,nonatomic)RideAcceptRecord * objRideAccRec;
@property(strong,nonatomic)NSMutableArray * requestArray;
@property(assign,nonatomic)BOOL isBooked;


@property (strong, nonatomic) UISlider *percentageSlider;
@end
