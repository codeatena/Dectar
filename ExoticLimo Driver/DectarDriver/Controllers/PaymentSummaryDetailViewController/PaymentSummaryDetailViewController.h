//
//  PaymentSummaryDetailViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/14/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"
#import "PaymentDetailTableViewCell.h"
#import "PaymentDetailRecords.h"
#import "RootBaseViewController.h"
#import "PaymentRecords.h"
#import "UrlHandler.h"

@interface PaymentSummaryDetailViewController : RootBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *paymentDetailTableView;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UILabel *paymentHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *paymentDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *RecDateHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *receiverDateLbl;
@property(strong,nonatomic)PaymentRecords * objPayRecs;

@property(strong,nonatomic)NSMutableArray * paymentDetailArray;
- (IBAction)didClickBackBtn:(id)sender;
@end
