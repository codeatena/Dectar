//
//  CancelRideViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/26/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "CancelRideViewController.h"

@interface CancelRideViewController ()

@end

@implementation CancelRideViewController
@synthesize headerLbl,cancelReasonLbl,cancelTblView,dontCancelBtn,custIndicatorView,reasonArray,reasonId,rideId;

- (void)viewDidLoad {
    [super viewDidLoad];
    cancelTblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setFont];
    [dontCancelBtn setHidden:YES];
    [self loadCancelView];
    // Do any additional setup after loading the view.
}

-(void)setFont{
    headerLbl=[Theme setHeaderFontForLabel:headerLbl];
    [headerLbl setText:JJLocalizedString(@"Cancel_Trip", nil)];
    [cancelReasonLbl setText:JJLocalizedString(@"Why_are_you_cancelling", nil)];
    [dontCancelBtn setTitle:JJLocalizedString(@"Dont_Cancel_Trip", nil) forState:UIControlStateNormal];
    cancelReasonLbl=[Theme setHeaderFontForLabel:cancelReasonLbl];
    dontCancelBtn=[Theme setBoldFontForButton:dontCancelBtn];
    [dontCancelBtn setBackgroundColor:SetThemeColor];
    dontCancelBtn.layer.cornerRadius=2;
    dontCancelBtn.layer.masksToBounds=YES;
}
-(void)loadCancelView{
     [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web DriverReject:[self setParametersForRejectRide]
              success:^(NSMutableDictionary *responseDictionary)
     {
         reasonArray=[[NSMutableArray alloc]init];
        
          [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             for (NSDictionary * reasonDict in responseDictionary[@"response"][@"reason"]) {
                 ReasonRecords * objReasonRecs=[[ReasonRecords alloc]init];
                 objReasonRecs.reasonId=[Theme checkNullValue:reasonDict[@"id"]];
                 objReasonRecs.Reasons=[Theme checkNullValue:reasonDict[@"reason"]];
                 objReasonRecs.isselected=NO;
                 [reasonArray addObject:objReasonRecs];
             }
             [dontCancelBtn setHidden:NO];
             [cancelTblView reloadData];
             
         }else{
             // [self.view makeToast:@"Some error occured"];
         }
     }
              failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [self.view makeToast:kErrorMessage];
         
     }];
}
-(NSDictionary *)setParametersForRejectRide{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  };
    return dictForuser;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showActivityIndicator:(BOOL)isShow{
    if(isShow==YES){
        if(custIndicatorView==nil){
            custIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStylePulse color:SetThemeColor];
            
        }
        custIndicatorView.center =self.view.center;
        [custIndicatorView startAnimating];
        [self.view addSubview:custIndicatorView];
        [self.view bringSubviewToFront:custIndicatorView];
    }
}
-(void)stopActivityIndicator{
    [custIndicatorView stopAnimating];
    custIndicatorView=nil;
}



- (IBAction)didClickDontCancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [reasonArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CancelReasonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cancelReasonIdentifier"];
    if (cell == nil) {
        cell = [[CancelReasonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:@"cancelReasonIdentifier"];
    }
    cell.delegate=self;
    ReasonRecords * objReasonRec=[reasonArray objectAtIndex:indexPath.row];
    [cell setDatasToCell:objReasonRec];
    [cell setIndexpath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)cancelRequest:(NSIndexPath *)index{
    for(int i=0; i<[reasonArray count];i++){
         ReasonRecords * objReasonRec=[reasonArray objectAtIndex:i];
        if(index.row==i){
            objReasonRec.isselected=YES;
            reasonId=objReasonRec.reasonId;
        }else{
            objReasonRec.isselected=NO;
        }
        [reasonArray setObject:objReasonRec atIndexedSubscript:i];
    }
    [cancelTblView reloadData];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"Are_you_Sure", nil)
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:JJLocalizedString(@"No", nil)
                                          otherButtonTitles:JJLocalizedString(@"Yes", nil),nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
       
    }
    else if (buttonIndex == 1) {
        [self selectReasonAndCancelRide];
    }
}
-(void)selectReasonAndCancelRide{
    if(reasonId.length==0){
        [self.view makeToast:@"Please_select_reason"];
    }else{
        [self showActivityIndicator:YES];
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [web DriverCancelWithReason:[self setParametersForRejectRideWithReason]
                            success:^(NSMutableDictionary *responseDictionary)
         {
             reasonArray=[[NSMutableArray alloc]init];
             
             [self stopActivityIndicator];
             if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
                 BOOL isHaveHome=NO;
                 for (UIViewController *controller in self.navigationController.viewControllers) {
                     
                     if ([controller isKindOfClass:[HomeViewController class]]) {
                         isHaveHome=YES;
                         [self.navigationController popToViewController:controller
                                                               animated:YES];
                         break;
                     }
                 }
                 if(isHaveHome==NO){
                     AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
                     [testAppDelegate setInitialViewController];
                 }
             }else{
                 [self.view makeToast:kErrorMessage];
             }
         }
                            failure:^(NSError *error)
         {
             [self stopActivityIndicator];
             [self.view makeToast:kErrorMessage];
             
         }];
    }
   
}
-(NSDictionary *)setParametersForRejectRideWithReason{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"ride_id":rideId,
                                  @"reason":reasonId
                                  };
    return dictForuser;
}
@end
