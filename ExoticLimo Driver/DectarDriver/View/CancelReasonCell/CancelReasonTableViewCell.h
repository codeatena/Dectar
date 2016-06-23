//
//  CancelReasonTableViewCell.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/26/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReasonRecords.h"
#import "DectarCustomColor.h"
#import "Theme.h"

@protocol CancelRequestDelegate<NSObject>
-(void)cancelRequest:(NSIndexPath *)index;
@end

@interface CancelReasonTableViewCell : UITableViewCell
@property(strong,nonatomic)id<CancelRequestDelegate> delegate;
@property(strong,nonatomic)NSIndexPath * indexpath;
@property (weak, nonatomic) IBOutlet UIButton *reasonBtn;
- (IBAction)didClickReasonBtn:(id)sender;

-(void)setDatasToCell:(ReasonRecords *)recs;
@end
