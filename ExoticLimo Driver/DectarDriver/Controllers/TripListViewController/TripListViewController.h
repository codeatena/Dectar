//
//  TripListViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/28/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTSpinKitView.h"
#import "UrlHandler.h"
#import "Constant.h"
#import "Theme.h"
#import "ITRAirSideMenu.h"
#import "TripRecords.h"
#import "TripListTableViewCell.h"
#import "TripDetailViewController.h"
#import "RootBaseViewController.h"
#import "DropDownListView.h"

@interface TripListViewController : RootBaseViewController<UITableViewDelegate,UITableViewDataSource,kDropDownListViewDelegate>{
     DropDownListView * Dropobj;
}
+ (instancetype) controller;
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
@property(strong,nonatomic)NSMutableArray * tripArray;
@property(strong,nonatomic)NSMutableArray * onRideArray;
@property(strong,nonatomic)NSMutableArray * CompletedArray;
@property(strong,nonatomic)NSMutableArray * sortArray;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filterSegmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tripListTableView;
@property (assign, nonatomic) BOOL isSort;
@property (weak, nonatomic) IBOutlet UIImageView *noRecsImg;
- (IBAction)didClickMenuBtn:(id)sender;
- (IBAction)didselectSegmentFilter:(id)sender;
- (IBAction)didClickFilterBtn:(id)sender;

@end
