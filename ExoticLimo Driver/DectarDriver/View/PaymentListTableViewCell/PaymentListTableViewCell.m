//
//  PaymentListTableViewCell.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/14/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "PaymentListTableViewCell.h"

@implementation PaymentListTableViewCell
@synthesize paymentHeaderLbl,paymentDateLbl,amountHeaderLbl,amountLbl,RecDateHeaderLbl,receiverDateLbl;

- (void)awakeFromNib {
    [paymentHeaderLbl setText:JJLocalizedString(@"Payment", nil)];
    [amountHeaderLbl setText:JJLocalizedString(@"Amount", nil)];
    [RecDateHeaderLbl setText:JJLocalizedString(@"Received_Date", nil)];
    
    // Initialization code
    
}
-(void)setDatasToList:(PaymentRecords *)objRecs{
    [self setFont];
    paymentDateLbl.text=[NSString stringWithFormat:@"%@ to %@",objRecs.fromDate,objRecs.toDate];
    amountLbl.text=[NSString stringWithFormat:@"%@ %@",objRecs.PriceSymbol,objRecs.Amount];
    receiverDateLbl.text=objRecs.ReceivedDate;
}
-(void)setFont{
//    paymentHeaderLbl=[Theme setNormalFontForLabel:paymentHeaderLbl];
//    paymentDateLbl=[Theme setSmallBoldFontForLabel:paymentDateLbl];
//    amountHeaderLbl=[Theme setNormalFontForLabel:amountHeaderLbl];
//    amountLbl=[Theme setSmallBoldFontForLabel:amountLbl];
//    RecDateHeaderLbl=[Theme setNormalFontForLabel:RecDateHeaderLbl];
//    receiverDateLbl=[Theme setNormalSmallFontForLabel:receiverDateLbl];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
