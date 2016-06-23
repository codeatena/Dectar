//
//  PaymentListTableViewCell.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/14/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"
#import "PaymentRecords.h"

@interface PaymentListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *paymentHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *paymentDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *RecDateHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *receiverDateLbl;
-(void)setDatasToList:(PaymentRecords *)objRecs;
@end
