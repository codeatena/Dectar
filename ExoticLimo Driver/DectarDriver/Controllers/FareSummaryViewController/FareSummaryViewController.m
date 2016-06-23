//
//  FareSummaryViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/1/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "FareSummaryViewController.h"
#import "AJRBackgroundDimmer.h"
#import "DectarCustomColor.h"
@interface FareSummaryViewController (){
    AJRBackgroundDimmer *backgroundGradientView;
}

@end

@implementation FareSummaryViewController
@synthesize summaryView,headerLbl,objFareRecs,fareLbl,timeTakenHeaderLbl,waitTimeHeaderLbl,distanceLbl,timeLbl,waitLbl,paymentBtn,requestCashBtn,okBtn,cancelBtn,isCloseEnabled;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self selfSetFont];
    [self setDatasToSummaryView];
    if (self.allowSwipeToDismiss) {
        //Add a swipe gesture recognizer to dismiss the view
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [self.view addGestureRecognizer:recognizer];
    }
    if (isCloseEnabled==YES) {
        cancelBtn.hidden=NO;
    }else{
        cancelBtn.hidden=YES;
    }
    [self performSelector:@selector(enableRideBtn) withObject:nil afterDelay:5];
}
-(void)enableRideBtn{
    requestCashBtn.userInteractionEnabled=YES;
    paymentBtn.userInteractionEnabled=YES;
}
-(void)viewWillAppear:(BOOL)animated{
    requestCashBtn.userInteractionEnabled=YES;
    //paymentBtn.userInteractionEnabled=YES;
    if(isCloseEnabled==YES){
        cancelBtn.hidden=NO;
    }
}
-(void)selfSetFont{
    [headerLbl setText:JJLocalizedString(@"Fare_Summary", nil)];
    headerLbl=[Theme setHeaderFontForLabel:headerLbl];
    summaryView.layer.cornerRadius=10;
    summaryView.layer.masksToBounds=YES;
    fareLbl=[Theme setLargeBoldFontForLabel:fareLbl];
    timeTakenHeaderLbl=[Theme setNormalFontForLabel:timeTakenHeaderLbl];
    waitTimeHeaderLbl=[Theme setNormalFontForLabel:waitTimeHeaderLbl];
    distanceLbl=[Theme setNormalFontForLabel:distanceLbl];
    timeLbl=[Theme setNormalFontForLabel:timeLbl];
    waitLbl=[Theme setNormalFontForLabel:waitLbl];
    paymentBtn=[Theme setBoldFontForButton:paymentBtn];
    okBtn=[Theme setBoldFontForButton:okBtn];
      [paymentBtn setTitle:JJLocalizedString(@"Request_Payment", nil) forState:UIControlStateNormal];
   [paymentBtn setTitleColor:SetThemeColor forState:UIControlStateNormal];
    paymentBtn.layer.cornerRadius=2;
    paymentBtn.layer.borderWidth=2;
    paymentBtn.layer.borderColor=SetThemeColor.CGColor;
    paymentBtn.layer.masksToBounds=YES;
    
    
    [requestCashBtn setTitle:JJLocalizedString(@"Receive_Cash", nil) forState:UIControlStateNormal];
    requestCashBtn=[Theme setBoldFontForButton:requestCashBtn];
    [requestCashBtn setTitleColor:SetThemeColor forState:UIControlStateNormal];
    requestCashBtn.layer.cornerRadius=2;
    requestCashBtn.layer.borderWidth=2;
    requestCashBtn.layer.borderColor=SetThemeColor.CGColor;
    requestCashBtn.layer.masksToBounds=YES;
    
    [okBtn setTitle:JJLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    [okBtn setTitleColor:SetThemeColor forState:UIControlStateNormal];
    okBtn.layer.cornerRadius=2;
    okBtn.layer.borderWidth=2;
    okBtn.layer.borderColor=SetThemeColor.CGColor;
    okBtn.layer.masksToBounds=YES;
    
    [headerLbl setText:JJLocalizedString(@"Fare_Summary", nil)];
    [_ridedistanceHeaderLbl setText:JJLocalizedString(@"Ride_Distance", nil)];
    [waitTimeHeaderLbl setText:JJLocalizedString(@"Wait_Time:", nil)];
    [timeTakenHeaderLbl setText:JJLocalizedString(@"Time_Taken", nil)];
    
    
}

-(void)setDatasToSummaryView{
    NSString * curStr=objFareRecs.currency;
    fareLbl.text=[NSString stringWithFormat:@"%@ %@",curStr,objFareRecs.rideFare];
    distanceLbl.text=objFareRecs.rideDistance;
    timeLbl.text=objFareRecs.rideDuration;
    waitLbl.text=objFareRecs.waitingDuration;
    if([objFareRecs.needPayment isEqualToString:@"YES"]){
        if([objFareRecs.needCash isEqualToString:@"Enable"]){
            okBtn.hidden=YES;
            paymentBtn.hidden=NO;
            requestCashBtn.hidden=NO;
        }else{
            okBtn.hidden=YES;
            paymentBtn.hidden=NO;
            requestCashBtn.hidden=YES;
            paymentBtn.frame=CGRectMake(paymentBtn.frame.origin.x, paymentBtn.frame.origin.y, requestCashBtn.frame.origin.x+requestCashBtn.frame.size.width, paymentBtn.frame.size.height);
        }
        
    }else{
        okBtn.hidden=NO;
        paymentBtn.hidden=YES;
        requestCashBtn.hidden=YES;
    }
    
}

- (void)presentInParentViewController:(UIViewController *)parentViewController {
    //Presents the view in the parent view controller
    
    if (self.shouldDimBackground == YES) {
        //Dims the background, unless overridden
        backgroundGradientView = [[AJRBackgroundDimmer alloc] initWithFrame:parentViewController.view.bounds];
        [parentViewController.view addSubview:backgroundGradientView];
    }
    
    //Adds the nutrition view to the parent view, as a child
    [parentViewController.view addSubview:self.view];
    [parentViewController addChildViewController:self];
    
    
    //Adds the bounce animation on appear unless overridden
    if (!self.shouldAnimateOnAppear)
        return;
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.duration = 0.4;
    bounceAnimation.delegate = self;
    
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.7f],
                              [NSNumber numberWithFloat:1.2f],
                              [NSNumber numberWithFloat:0.9f],
                              [NSNumber numberWithFloat:1.0f],
                              nil];
    
    bounceAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0f],
                                [NSNumber numberWithFloat:0.334f],
                                [NSNumber numberWithFloat:0.666f],
                                [NSNumber numberWithFloat:1.0f],
                                nil];
    
    bounceAnimation.timingFunctions = [NSArray arrayWithObjects:
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       nil];
    
    [self.view.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    fadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    fadeAnimation.duration = 0.1;
    [backgroundGradientView.layer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self didMoveToParentViewController:self.parentViewController];
}

- (IBAction)close:(id)sender {
    //The close button
    [self dismissFromParentViewController];
}

- (void)dismissFromParentViewController {
    //Removes the nutrition view from the superview
    
    [self willMoveToParentViewController:nil];
    
    //Removes the view with or without animation
    if (!self.shouldAnimateOnDisappear) {
        [self.view removeFromSuperview];
        [backgroundGradientView removeFromSuperview];
        [self removeFromParentViewController];
        return;
    }
    else{
        [UIView animateWithDuration:0.4 animations:^ {
            CGRect rect = self.view.bounds;
            rect.origin.y += rect.size.height;
            self.view.frame = rect;
            backgroundGradientView.alpha = 0.0f;
        }
                         completion:^(BOOL finished) {
                             [self.view removeFromSuperview];
                             [backgroundGradientView removeFromSuperview];
                             [self removeFromParentViewController];
                         }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didClickPaymentBtn:(id)sender {
   // [self close:self];
    UIButton * btn=sender;
    if([[btn titleColorForState:UIControlStateNormal] isEqual:[UIColor lightGrayColor]]){
        [self.view makeToast:@"Request_for_payment_is"];
    }else{
        cancelBtn.hidden=YES;
        requestCashBtn.userInteractionEnabled=NO;
        [paymentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        paymentBtn.userInteractionEnabled=NO;
        [self.delegate moveToNextVc:0];
    }
   
}

- (IBAction)didClickRequestCashBtn:(id)sender {
    //[self close:self];
    cancelBtn.hidden=YES;
    [self.delegate moveToNextVc:1];
}

- (IBAction)didClickOkBtn:(id)sender {
    okBtn.userInteractionEnabled=NO;
    [self performSelector:@selector(enableBtn) withObject:nil afterDelay:5];
     [self.delegate moveToNextVc:2];
}

- (IBAction)didClickCloseBtn:(id)sender {
    [self stopActivityIndicator];
    [self.delegate moveToNextVc:3];
    [self dismissFromParentViewController];
}
-(void)enableBtn{
    okBtn.userInteractionEnabled=YES;
}
@end
