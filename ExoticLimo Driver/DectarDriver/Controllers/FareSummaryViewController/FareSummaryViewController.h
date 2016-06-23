//
//  FareSummaryViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/1/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Theme.h"
#import "Constant.h"
#import "FareRecords.h"
#import "ReceiveCashViewController.h"
#import "RootBaseViewController.h"
@protocol moveToNectVCFromFareSummary<NSObject>
-(void)moveToNextVc:(NSInteger )index;
@end

@interface FareSummaryViewController : RootBaseViewController
@property(strong,nonatomic)id<moveToNectVCFromFareSummary> delegate;
- (void)presentInParentViewController:(UIViewController *)parentViewController;
@property BOOL shouldDimBackground;             //Default: YES
@property BOOL shouldAnimateOnAppear;           //Default: YES
@property BOOL shouldAnimateOnDisappear;        //Default: YES

//By default, the user can perform a swipe gesture (in the downward direction)
//to dismiss the popup
@property BOOL allowSwipeToDismiss;             //Default: YES
@property (weak, nonatomic) IBOutlet UIView *summaryView;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property(strong,nonatomic)FareRecords * objFareRecs;
@property (weak, nonatomic) IBOutlet UILabel *ridedistanceHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *fareLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeTakenHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *waitTimeHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIButton *requestCashBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UILabel *waitLbl;
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;
@property(assign,nonatomic) BOOL isCloseEnabled;
- (IBAction)didClickPaymentBtn:(id)sender;
- (IBAction)didClickRequestCashBtn:(id)sender;
- (IBAction)didClickOkBtn:(id)sender;
- (IBAction)didClickCloseBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end
