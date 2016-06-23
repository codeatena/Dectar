//
//  PaymentSummaryListViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/14/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentListTableViewCell.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "PaymentSummaryDetailViewController.h"
#import "RootBaseViewController.h"
#import "PaymentRecords.h"

@interface PaymentSummaryListViewController : RootBaseViewController<UITableViewDataSource,UITableViewDelegate>
+ (instancetype) controller;
@property (weak, nonatomic) IBOutlet UITableView *paymentTableView;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property(strong,nonatomic)NSMutableArray * payMentArray;
@property (weak, nonatomic) IBOutlet UIImageView *noRecsImg;
- (IBAction)didClickMenuBtn:(id)sender;
@end
