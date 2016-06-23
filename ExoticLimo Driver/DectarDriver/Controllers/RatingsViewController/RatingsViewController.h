//
//  RatingsViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/3/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"
#import "UrlHandler.h"
#import "Constant.h"
#import "RatingsTableViewCell.h"
#import "RatingsRecords.h"
#import "HomeViewController.h"
#import "RootBaseViewController.h"

@interface RatingsViewController : RootBaseViewController<UITextViewDelegate>
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *ratingHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *txtLbl;
@property (weak, nonatomic) IBOutlet UITableView *ratingsTblView;
@property (weak, nonatomic) IBOutlet UIButton *rateRiderBtn;
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
@property(strong,nonatomic)NSMutableArray * ratingsArray;
@property(strong,nonatomic)NSString * rideid;
@property (weak, nonatomic) IBOutlet UITextView *commentTxtView;
@property (weak, nonatomic) IBOutlet UIView *rateSuccessView;
@property (weak, nonatomic) IBOutlet UIView *rateOptionView;

- (IBAction)didClickBackBtn:(id)sender;
- (IBAction)didClickRateRideBtn:(id)sender;
- (IBAction)didClickSkipBtn:(id)sender;

@end
