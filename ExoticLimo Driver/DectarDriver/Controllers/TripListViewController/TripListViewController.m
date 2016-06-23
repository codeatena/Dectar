//
//  TripListViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 8/28/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "TripListViewController.h"

@interface TripListViewController ()

@end

@implementation TripListViewController
@synthesize custIndicatorView,tripArray,tripListTableView,onRideArray,headerLbl,
CompletedArray,filterSegmentControl,containerView,sortArray,isSort;
+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"TripListVCSID"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:kDriverCashPaymentNotifWhenQuit
                                               object:nil];
    [self setFont];
    tripListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    CGRect frame= filterSegmentControl.frame;
    [filterSegmentControl setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 45)];
    filterSegmentControl.tintColor = SetThemeColor;
    [self getTripList];
    // Do any additional setup after loading the view.
}
- (void)receiveNotification:(NSNotification *) notification
{
    if(self.view.window){
        NSDictionary * dict=notification.userInfo;
        if([[NSString stringWithFormat:@"%@",[Theme checkNullValue:[dict objectForKey:@"action"]]] isEqualToString:@"receive_cash"]){
            NSString * rideId=[Theme checkNullValue:[dict objectForKey:@"key1"]];
            NSString * CurrId=[Theme findCurrencySymbolByCode:[Theme checkNullValue:[dict objectForKey:@"key4"]]];
            NSString * fareStr=[Theme checkNullValue:[dict objectForKey:@"key3"]];
            NSString * fareAmt=[NSString stringWithFormat:@"%@ %@",CurrId,fareStr];
            
            [self stopActivityIndicator];
            ReceiveCashViewController * objReceiveCashVC=[self.storyboard  instantiateViewControllerWithIdentifier:@"ReceiveCashVCSID"];
            [objReceiveCashVC setRideId:rideId];
            [objReceiveCashVC setFareAmt:fareAmt];
            [self.navigationController pushViewController:objReceiveCashVC animated:YES];
        }
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setFont{
    headerLbl=[Theme setHeaderFontForLabel:headerLbl];
    [headerLbl setText:JJLocalizedString(@"Trip_List", nil)];
    [filterSegmentControl setTitle:JJLocalizedString(@"All", nil) forSegmentAtIndex:0];
    [filterSegmentControl setTitle:JJLocalizedString(@"Onride", nil) forSegmentAtIndex:1];
    [filterSegmentControl setTitle:JJLocalizedString(@"Completed", nil) forSegmentAtIndex:2];
   
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];   //it hides
}

-(void)getTripList{
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getDriverTripList:[self setParametersDriverTripList]
                   success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             tripArray=[[NSMutableArray alloc]init];
             CompletedArray=[[NSMutableArray alloc]init];
             onRideArray=[[NSMutableArray alloc]init];
             for (NSDictionary * reasonDict in responseDictionary[@"response"][@"rides"]) {
                 TripRecords * objTripRecs=[[TripRecords alloc]init];
                 objTripRecs.tripId=[Theme checkNullValue:reasonDict[@"ride_id"]];
                 objTripRecs.tripTime=[Theme checkNullValue:reasonDict[@"ride_time"]];
                 objTripRecs.tripDate=[Theme checkNullValue:reasonDict[@"ride_date"]];
                 objTripRecs.tripLocation=[Theme checkNullValue:reasonDict[@"pickup"]];
                 objTripRecs.tripStatus=[Theme checkNullValue:reasonDict[@"group"]];
                 objTripRecs.tripeOrigDate=[Theme checkNullValue:reasonDict[@"datetime"]];
                 if([objTripRecs.tripStatus isEqualToString:@"Started"]||[objTripRecs.tripStatus isEqualToString:@"Pickuped"]){
                     [onRideArray addObject:objTripRecs];
                 }else if ([objTripRecs.tripStatus isEqualToString:@"completed"]){
                     [CompletedArray addObject:objTripRecs];
                 }
                 [tripArray addObject:objTripRecs];
             }
             if([tripArray count]==0){
                 [self.view makeToast:@"No_Records_Found"];
             }
             [tripListTableView reloadData];
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
-(NSDictionary *)setParametersDriverTripList{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"trip_type":@"all",
                                  };
    return dictForuser;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount=0;
    if(filterSegmentControl.selectedSegmentIndex==0){
        if(isSort==YES){
            rowCount=[sortArray count];
        }else{
            rowCount=[tripArray count];
        }
        
    }else if (filterSegmentControl.selectedSegmentIndex==1){
        if(isSort==YES){
            rowCount=[sortArray count];
        }else{
            rowCount=[onRideArray count];
        }
        
    }else if (filterSegmentControl.selectedSegmentIndex==2){
        if(isSort==YES){
            rowCount=[sortArray count];
        }else{
            rowCount=[CompletedArray count];
        }
    }
    if(rowCount==0){
        _noRecsImg.hidden=NO;
    }else{
        _noRecsImg.hidden=YES;
    }
    return rowCount;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TripListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripListIdentifier"];
    if (cell == nil) {
        cell = [[TripListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:@"TripListIdentifier"];
    }
    TripRecords * objTripRecs=[[TripRecords alloc]init];
    if(filterSegmentControl.selectedSegmentIndex==0){
        if(isSort==YES){
            objTripRecs=[sortArray objectAtIndex:indexPath.row];
        }else{
            objTripRecs=[tripArray objectAtIndex:indexPath.row];
            
        }
    }else if (filterSegmentControl.selectedSegmentIndex==1){
        if(isSort==YES){
            objTripRecs=[sortArray objectAtIndex:indexPath.row];
        }else{
            objTripRecs=[onRideArray objectAtIndex:indexPath.row];
        }
        
    }else if (filterSegmentControl.selectedSegmentIndex==2){
        if(isSort==YES){
            objTripRecs=[sortArray objectAtIndex:indexPath.row];
        }else{
            objTripRecs=[CompletedArray objectAtIndex:indexPath.row];
        }
    }
    [cell setDatasToTripList:objTripRecs];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TripRecords * objTripRecs=[[TripRecords alloc]init];
    if(filterSegmentControl.selectedSegmentIndex==0){
        if(isSort==YES){
            objTripRecs=[sortArray objectAtIndex:indexPath.row];
        }else{
            objTripRecs=[tripArray objectAtIndex:indexPath.row];
        }
        
    }else if (filterSegmentControl.selectedSegmentIndex==1){
        if(isSort==YES){
            objTripRecs=[sortArray objectAtIndex:indexPath.row];
        }else{
            objTripRecs=[onRideArray objectAtIndex:indexPath.row];
        }
        
    }else if (filterSegmentControl.selectedSegmentIndex==2){
        if(isSort==YES){
            objTripRecs=[sortArray objectAtIndex:indexPath.row];
        }else{
            objTripRecs=[CompletedArray objectAtIndex:indexPath.row];
        }
    }
    TripDetailViewController * objTripDetailVc=[self.storyboard instantiateViewControllerWithIdentifier:@"TripDetailVCSID"];
    [objTripDetailVc setTripId:objTripRecs.tripId];
    [self.navigationController pushViewController:objTripDetailVc animated:YES];
}

- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)didselectSegmentFilter:(id)sender {
    isSort=NO;
    [tripListTableView reloadData];
    UISegmentedControl * segControl=sender;
    if(segControl.selectedSegmentIndex==0){
        if([tripArray count]==0){
            [self.view makeToast:@"No_Records_Found"];
        }
    }else if (segControl.selectedSegmentIndex==1){
        if([onRideArray count]==0){
            [self.view makeToast:@"No_Records_Found"];
        }
    }else if (segControl.selectedSegmentIndex==2){
        if([CompletedArray count]==0){
            [self.view makeToast:@"No_Records_Found"];
        }
    }
}

- (IBAction)didClickFilterBtn:(id)sender {
    containerView.userInteractionEnabled=NO;
    NSArray * arryList=[[NSArray alloc]init];  arryList=@[JJLocalizedString(@"All", nil) ,JJLocalizedString(@"Last_one_week", nil),JJLocalizedString(@"Last_two_weeks", nil),JJLocalizedString(@"Last_one_month", nil),JJLocalizedString(@"Last_one_year", nil)];
    [Dropobj fadeOut];
    [self showPopUpWithTitle:JJLocalizedString(@"Sort", nil) withOption:arryList xy:CGPointMake(self.view.frame.size.width-205, 57) size:CGSizeMake(195, 310) isMultiple:NO];
}

///////FilterView
-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    
    
    Dropobj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    Dropobj.delegate = self;
    [Dropobj showInView:self.view animated:YES];
    
    /*----------------Set DropDown backGroundColor-----------------*/
    [Dropobj SetBackGroundDropDown_R:255.0 G:255.0 B:255.0 alpha:0.90];
    
}
- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    containerView.userInteractionEnabled=YES;
    isSort=YES;
    [self filterTripAccordingToDate:anIndex];
}
-(void)filterTripAccordingToDate:(NSInteger)index{
    switch (index) {
        case 0:
            isSort=NO;
            break;
        case 1:
            [self filterTableViewWithIndex:1];
            break;
        case 2:
            [self filterTableViewWithIndex:2];
            break;
        case 3:
            [self filterTableViewWithIndex:3];
            break;
        case 4:
            [self filterTableViewWithIndex:4];
            break;
        default:
            break;
    }
    [tripListTableView reloadData];
}
-(void)filterTableViewWithIndex:(NSInteger)index{
    sortArray=[[NSMutableArray alloc]init];
    NSMutableArray * dummayArray=[[NSMutableArray alloc]init];
    if(filterSegmentControl.selectedSegmentIndex==0){
        dummayArray=tripArray;
    }else if (filterSegmentControl.selectedSegmentIndex==1){
        dummayArray=onRideArray;
    }else if (filterSegmentControl.selectedSegmentIndex==2){
        dummayArray=CompletedArray ;
    }
    for (int i=0; i<[dummayArray count]; i++) {
        TripRecords * objTripRecs=[dummayArray objectAtIndex:i];
        NSTimeInterval distanceBetweenDates = [[self getDateWithIndex:index] timeIntervalSinceDate:[Theme setDate:objTripRecs.tripeOrigDate]];
        double secondsInMinute = 60;
        NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
        
        if (secondsBetweenDates <= 0){
            [sortArray addObject:objTripRecs];
        }
    }
}
-(NSDate *)getDateWithIndex:(NSInteger)index{
    NSDate *now = [NSDate date];
    NSDate *sevenDaysAgo;
    if(index==1){
        sevenDaysAgo = [now dateByAddingTimeInterval:-7*24*60*60];
    }
    else if (index==2){
        sevenDaysAgo = [now dateByAddingTimeInterval:-14*24*60*60];
    }else if (index==3){
        sevenDaysAgo = [now dateByAddingTimeInterval:-31*24*60*60];
    }else if (index==3){
        sevenDaysAgo = [now dateByAddingTimeInterval:-365*24*60*60];
    }
    return sevenDaysAgo;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        containerView.userInteractionEnabled=YES;
        [Dropobj fadeOut];
    }
    [tripListTableView reloadData];
}
@end
