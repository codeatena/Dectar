//
//  PaymentDetailTableViewCell.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/14/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "PaymentDetailTableViewCell.h"

@implementation PaymentDetailTableViewCell
@synthesize paymentHeaderLbl,paymentDateLbl,amountHeaderLbl,amountLbl,RecDateLbl;

- (void)awakeFromNib {
    [paymentHeaderLbl setText:JJLocalizedString(@"Ride_Id",nil)];
    [amountHeaderLbl setText:JJLocalizedString(@"Amount", nil)];
    [_dateHeaderLbl setText:JJLocalizedString(@"Received_Date", nil)];
    
    // Initialization code
}
-(void)setDatasToDetailList:(PaymentDetailRecords *)objRecs{
    [self setFont];
    paymentDateLbl.text=objRecs.rideId;
    amountLbl.text=[NSString stringWithFormat:@"%@ %@",objRecs.currencySymbol,objRecs.amount];
    RecDateLbl.text=objRecs.date;
}
-(void)setFont{
//    paymentHeaderLbl=[Theme setNormalFontForLabel:paymentHeaderLbl];
//    paymentDateLbl=[Theme setSmallBoldFontForLabel:paymentDateLbl];
//    amountHeaderLbl=[Theme setNormalFontForLabel:amountHeaderLbl];
//    amountLbl=[Theme setSmallBoldFontForLabel:amountLbl];
//    RecDateLbl=[Theme setNormalSmallFontForLabel:RecDateLbl];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
