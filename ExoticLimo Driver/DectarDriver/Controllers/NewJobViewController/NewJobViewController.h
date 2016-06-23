//
//  NewJobViewController.h
//  DectarDriver
//
//  Created by Aravind Natarajan on 03/03/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelThemeColor.h"
#import "ButtonColorHandler.h"
#import "TPFloatRatingView.h"
#import "RiderRecords.h"
#import "RootBaseViewController.h"

@protocol NewJobsDelegate <NSObject>

@optional
- (void) didClickNewJobsOk;



@end

@interface NewJobViewController : RootBaseViewController
@property (nonatomic, assign) id<NewJobsDelegate> delegate;
@property(strong,nonatomic)RiderRecords * objRiderRecs;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet LabelThemeColor *headerLbl;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@property (weak, nonatomic) IBOutlet TPFloatRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet ButtonColorHandler *okBtn;


- (IBAction)didClickPhoneBtn:(id)sender;
- (IBAction)didClickOkBtn:(id)sender;

@end
