//
//  CancelReasonTableViewCell.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/26/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "CancelReasonTableViewCell.h"

@implementation CancelReasonTableViewCell
@synthesize reasonBtn,indexpath;
- (void)awakeFromNib {
    // Initialization code
}
-(void)setDatasToCell:(ReasonRecords *)recs{
    [self setFont];
    [reasonBtn setTitle:recs.Reasons forState:UIControlStateNormal];
    if(recs.isselected==YES){
        [reasonBtn setTitleColor:SetThemeColor forState:UIControlStateNormal];
    }else{
         [reasonBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
}
-(void)setFont{
    reasonBtn=[Theme setBoldFontForButton:reasonBtn];
    reasonBtn.layer.cornerRadius=2;
    reasonBtn.layer.masksToBounds=YES;
}
- (IBAction)didClickReasonBtn:(id)sender {
    [self.delegate cancelRequest:indexpath];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
