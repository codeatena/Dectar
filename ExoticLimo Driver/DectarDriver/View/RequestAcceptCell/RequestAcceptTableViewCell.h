//
//  RequestAcceptTableViewCell.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/24/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RideAcceptRecord.h"
#import "Theme.h"
#import "DectarCustomColor.h"
#import "KKProgressTimer.h"
#import  "MZTimerLabel.h"

@protocol requestOptionDelegate<NSObject>
@optional
-(void)updateRecordCellWhenSpinnerStarts:(NSInteger)riderTag withIndex:(NSIndexPath *)index;
-(void)RemoveCellWhenRequestExpired:(NSInteger)riderTag withIndex:(NSIndexPath *)index;
-(void)rejectParticularRide:(NSInteger)riderTag withIndex:(NSIndexPath *)index;
-(void)AcceptRide:(NSInteger)riderTag withIndex:(NSIndexPath *)index;

@end


@interface RequestAcceptTableViewCell : UITableViewCell<KKProgressTimerDelegate,MZTimerLabelDelegate>{
   
}
@property(strong,nonatomic)NSIndexPath * indexpath;

@property(strong,nonatomic)id<requestOptionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet KKProgressTimer *spinTimer;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIButton *disCardBtn;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIView *spinnerView;
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
@property (weak, nonatomic) IBOutlet UILabel *locHeaderLbl;
@property(strong,nonatomic)RideAcceptRecord * acceptRec;
@property(strong,nonatomic) MZTimerLabel * countDownTimerLbl;


- (IBAction)didClickDisCardBtn:(id)sender;
- (IBAction)didClickAcceptBtn:(id)sender;
-(void)setDatasToAcceptCell:(RideAcceptRecord *)objRideAcceptRec;


@end
