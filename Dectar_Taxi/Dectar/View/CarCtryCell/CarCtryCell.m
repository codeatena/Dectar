//
//  CarCtryCell.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/18/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "CarCtryCell.h"
#import "UIImageView+Network.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"

@implementation CarCtryCell
@synthesize objBookingRecord,selectiveIndexpath,carButton,TimeLable,nameLable,cabImageView;

-(IBAction)SelectButton:(id)sender
{
    [self.delegate buttonWasPressed:selectiveIndexpath];
}

-(void)setDatasToCategoryCell:(BookingRecord *)objBookingRec{
 
    //cabImageView.layer.cornerRadius=carButton.frame.size.width/2;
    //cabImageView.layer.masksToBounds=YES;
    TimeLable.text=objBookingRec.categoryETA;
    nameLable.text=objBookingRec.categoryName;
    nameLable.text = [nameLable.text stringByReplacingOccurrencesOfString:@"Exotic " withString:@""];
    
    if(objBookingRec.isSelected==YES){
        
        _backView.backgroundColor = BGCOLOR;
    }
    else
    {
        _backView.backgroundColor = [UIColor colorWithHexString:@"#6d6e71"];
    }
    
    if(objBookingRec.isSelected==YES){
        
        [cabImageView sd_setImageWithURL:[NSURL URLWithString:objBookingRec.Active_Image] placeholderImage:[UIImage imageNamed:@"CabPlaceholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
    }else{
        
        [cabImageView sd_setImageWithURL:[NSURL URLWithString:objBookingRec.Normal_image] placeholderImage:[UIImage imageNamed:@"CabPlaceholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
    }
    
}

@end