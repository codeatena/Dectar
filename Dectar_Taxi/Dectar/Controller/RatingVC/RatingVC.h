//
//  RatingVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 9/3/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewRecord.h"
#import "FareRecord.h"
#import "RootBaseVC.h"


@interface RatingVC : RootBaseVC
@property (strong, nonatomic) IBOutlet UIButton *submit_btn;
@property (strong, nonatomic) IBOutlet UITableView *rating_table;
@property (strong ,nonatomic) ReviewRecord * recordObj;
@property (strong ,nonatomic) NSString *  RideID_Rating;
@property (strong ,nonatomic) FareRecord * objRec;
@property (strong, nonatomic) IBOutlet UIView *Rated_View;
@property (strong, nonatomic) IBOutlet UILabel *Header_labl;
@property (strong, nonatomic) IBOutlet UIImageView *Tick_View;
@property (strong, nonatomic) IBOutlet UIButton *Skip_Btn;
@property (strong, nonatomic) IBOutlet UILabel *Thanks_Lbl;
@property (strong, nonatomic) IBOutlet UILabel *Already;

@end
