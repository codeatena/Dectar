//
//  RatingsTableViewCell.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/3/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "RatingsTableViewCell.h"

@implementation RatingsTableViewCell
@synthesize reasonLbl,ratingView,indexpath;

- (void)awakeFromNib {
    // Initialization code
}
-(void)setRaingRecs:(RatingsRecords *)recs{
    reasonLbl=[Theme setBoldFontForLabel:reasonLbl];
    reasonLbl.text=recs.rateReason;
    [self loadRating:recs.rateValue];
}
-(void)loadRating:(NSString *)ratingCount{
    float rateCount=[ratingCount floatValue];
    self.ratingView.delegate = self;
    self.ratingView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
    self.ratingView.fullSelectedImage = [UIImage imageNamed:@"StarFill"];
    self.ratingView.contentMode = UIViewContentModeScaleAspectFill;
    self.ratingView.maxRating = 5;
    self.ratingView.minRating = 0;
    self.ratingView.rating = rateCount;
    self.ratingView.editable = YES;
    self.ratingView.halfRatings = YES;
    self.ratingView.floatRatings = YES;
}
- (void)floatRatingView:(TPFloatRatingView *)ratingView ratingDidChange:(CGFloat)rating{
    [self.delegate ratingSelected:indexpath withValue:rating];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
