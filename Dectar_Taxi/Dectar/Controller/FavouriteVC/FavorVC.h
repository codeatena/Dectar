//
//  FavorVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/21/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressRecord.h"
#import "RootBaseVC.h"


@interface FavorVC : RootBaseVC

@property (strong, nonatomic) IBOutlet UIButton * EditFavour;
@property (strong, nonatomic) IBOutlet UIButton *CloseFavour;
@property (strong, nonatomic) IBOutlet UITableView *FavrList;
@property (strong, nonatomic) IBOutlet UIButton *AddFavor;
@property (strong, nonatomic) IBOutlet UILabel *CurrentFavour;
@property (strong, nonatomic) IBOutlet UIView *EmptyFavor;
@property (strong, nonatomic) AddressRecord *objRecord;
@property (strong, nonatomic) IBOutlet UILabel *heading_favour;
@property (strong, nonatomic) IBOutlet UILabel *Add_favourite;

@property (strong, nonatomic) IBOutlet UILabel *Not_favour;
@property (strong, nonatomic) IBOutlet UILabel *hint_lbl;
@end
