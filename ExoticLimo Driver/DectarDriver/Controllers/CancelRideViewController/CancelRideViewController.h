//
//  CancelRideViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/26/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"
#import "Constant.h"
#import "RootBaseViewController.h"
#import "ReasonRecords.h"
#import "CancelReasonTableViewCell.h"
#import "StarterViewController.h"
#import "HomeViewController.h"
#import "RootBaseViewController.h"
@interface CancelRideViewController :RootBaseViewController<UITableViewDelegate,UITableViewDataSource,CancelRequestDelegate,UIAlertViewDelegate>
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UILabel *cancelReasonLbl;
@property (weak, nonatomic) IBOutlet UITableView *cancelTblView;
@property (weak, nonatomic) IBOutlet UIButton *dontCancelBtn;
@property(strong,nonatomic)NSMutableArray * reasonArray;
@property(strong,nonatomic)NSString * reasonId;
@property(strong,nonatomic)NSString * rideId;

- (IBAction)didClickDontCancelBtn:(id)sender;
@end
