//
//  TripListTableViewCell.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/31/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripRecords.h"
#import "Theme.h"

@interface TripListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
-(void)setDatasToTripList:(TripRecords *)tripRecs;
@end
