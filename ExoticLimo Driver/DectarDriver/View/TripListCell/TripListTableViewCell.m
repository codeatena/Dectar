//
//  TripListTableViewCell.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/31/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "TripListTableViewCell.h"

@implementation TripListTableViewCell
@synthesize locationLbl,
timeLbl,imgView;

- (void)awakeFromNib {
    // Initialization code
}
-(void)setDatasToTripList:(TripRecords *)tripRecs{
    [self setFont];
    locationLbl.text=tripRecs.tripLocation;
    timeLbl.text=[NSString stringWithFormat:@"%@, %@",tripRecs.tripDate,tripRecs.tripTime];
    if([tripRecs.tripStatus isEqualToString:@"onride"]){
        imgView.image=[UIImage imageNamed:@"TimeClock"];
    }else{
         imgView.image=[UIImage imageNamed:@"FinishImg"];
    }
}
-(void)setFont{
    locationLbl=[Theme setNormalFontForLabel:locationLbl];
    timeLbl=[Theme setNormalSmallFontForLabel:timeLbl];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
