//
//  RequestAcceptTableViewCell.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/24/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

#import "RequestAcceptTableViewCell.h"

@implementation RequestAcceptTableViewCell
@synthesize disCardBtn,acceptBtn,spinnerView,locationLbl,locHeaderLbl,spinTimer,acceptRec,indexpath,timeLbl,countDownTimerLbl;

- (void)awakeFromNib {
    [acceptBtn setTitle:JJLocalizedString(@"Accept", nil) forState:UIControlStateNormal];
    [disCardBtn setTitle:JJLocalizedString(@"Deny", nil) forState:UIControlStateNormal];

    // Initialization code
}
-(void)setDatasToAcceptCell:(RideAcceptRecord *)objRideAcceptRec{
    disCardBtn.tag=indexpath.row;
    acceptRec=[[RideAcceptRecord alloc]init];
    acceptRec=objRideAcceptRec;
    [self setFont];
    locationLbl.text=objRideAcceptRec.LocationName;
    [locationLbl sizeToFit];
    locHeaderLbl.text=objRideAcceptRec.headerTxt;
    if(objRideAcceptRec.rideCountStart==NO){
        __block CGFloat i1 = 0;
        if(objRideAcceptRec.rideCountStart==NO){
            [self.delegate updateRecordCellWhenSpinnerStarts:acceptRec.rideTag withIndex:indexpath];
            countDownTimerLbl = [[MZTimerLabel alloc] initWithLabel:timeLbl andTimerType:MZTimerLabelTypeTimer];
            [countDownTimerLbl setCountDownTime:[acceptRec.expiryTime integerValue]];
            countDownTimerLbl.delegate=self;
            countDownTimerLbl.tag=indexpath.row;
            countDownTimerLbl.timeFormat = @"ss";
            [countDownTimerLbl start];
            [spinTimer startWithBlock:^CGFloat {
                
                int x = (int)(((double)i1++/(double)[acceptRec.expiryTime integerValue]) * 100);
                float y = x / 100.0f;
                if(y==1.0){
                    [spinTimer stop];
                    [self.delegate  RemoveCellWhenRequestExpired:acceptRec.rideTag withIndex:indexpath];
                }
                
                return y;
            }];
        }else{
            
        }
    }
    
}

-(void)setFont{
    acceptBtn.layer.cornerRadius=4;
    acceptBtn.layer.masksToBounds=YES;
    
    disCardBtn.layer.cornerRadius=4;
    disCardBtn.layer.masksToBounds=YES;
    
    timeLbl.layer.cornerRadius=timeLbl.frame.size.width/2;
    timeLbl.layer.borderWidth=0.5;
    timeLbl.layer.borderColor=SetThemeColor.CGColor;
    timeLbl.layer.masksToBounds=YES; //backView
    
    _backView.layer.cornerRadius=10;
    _backView.layer.masksToBounds=YES;
}

- (IBAction)didClickDisCardBtn:(id)sender {
    [self.delegate rejectParticularRide:acceptRec.rideTag withIndex:indexpath];
}

- (IBAction)didClickAcceptBtn:(id)sender {
    [self.delegate AcceptRide:acceptRec.rideTag withIndex:indexpath];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
