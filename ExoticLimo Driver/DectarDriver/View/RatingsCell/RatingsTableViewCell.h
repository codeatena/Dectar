//
//  RatingsTableViewCell.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/3/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"
#import "Constant.h"
#import "TPFloatRatingView.h"
#import "RatingsRecords.h"

@protocol RatingDelegate<NSObject>
-(void)ratingSelected:(NSIndexPath *)index withValue:(float )rateValue;
@end

@interface RatingsTableViewCell : UITableViewCell<TPFloatRatingViewDelegate>
@property(strong,nonatomic)id<RatingDelegate> delegate;
@property(strong,nonatomic)NSIndexPath * indexpath;
@property (weak, nonatomic) IBOutlet UILabel *reasonLbl;
@property (weak, nonatomic) IBOutlet TPFloatRatingView *ratingView;

-(void)setRaingRecs:(RatingsRecords *)recs;
@end
