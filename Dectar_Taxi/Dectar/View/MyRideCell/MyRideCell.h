//
//  MyRideCell.h
//  Dectar
//
//  Created by Suresh J on 22/07/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRideCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *status;
@property (strong, nonatomic) IBOutlet UILabel *placelable;
@property (strong, nonatomic) IBOutlet UILabel *Timelable;
@property (strong, nonatomic) IBOutlet UILabel *Datelable;

@end
