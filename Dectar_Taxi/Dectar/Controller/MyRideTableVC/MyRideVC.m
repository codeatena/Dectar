//
//  MyRideVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/13/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "MyRideVC.h"
#import "MyRideCell.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "MyRideRecord.h"
#import "DetailMyRideVc.h"
#import "Constant.h"
#import "REFrostedViewController.h"
#import "LanguageHandler.h"

@interface MyRideVC ()
{
    NSString *totalRides;
    NSString * rideID;
    NSString * userID;
    NSString * ride_Status;
    MyRideRecord *objcRecored;
    NSMutableArray *sortArray;
    
    
}

@property (strong) IBOutlet UITableView * MyRideTable;
@property (strong) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *Rides_Segement;
@property (strong, nonatomic)  NSString *Rides_type;
@property (strong, nonatomic)  NSMutableArray *RideAllArray;
@property (strong, nonatomic)  NSMutableArray *UpcomingArray;
@property (strong, nonatomic)  NSMutableArray *CompleteArray;
@property (assign, nonatomic) BOOL isSort;


@end

@implementation MyRideVC
@synthesize Rides_type,Rides_Segement,RideAllArray,NorideVIEW,UpcomingArray,CompleteArray,isSort,Sort_Btn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

   

    [Themes statusbarColor:self.view];

    //[_menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self segmentAction:Rides_Segement];
    
    _MyRideTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Set the gesture
    RideAllArray=[NSMutableArray array];
    UpcomingArray=[NSMutableArray array];
    CompleteArray=[NSMutableArray array];
    //Sort_Btn.hidden=YES;
    userID=[Themes getUserID];
    objcRecored=[[MyRideRecord alloc]init];
    [self GetRideList];
   // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}
/*-(void)viewWillAppear:(BOOL)animated{
   
    
    
}*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [Rides_Segement setTitle:JJLocalizedString(@"all", nil) forSegmentAtIndex:0];
    [Rides_Segement setTitle:JJLocalizedString(@"upcoming", nil) forSegmentAtIndex:1];
    [Rides_Segement setTitle:JJLocalizedString(@"complete", nil) forSegmentAtIndex:2];

    [_noride setText:JJLocalizedString(@"No_Rides_Booked", nil)];
    [_hint_noride setText:JJLocalizedString(@"There_are_no_rides for you", nil)];
    [_bookaride_btn setTitle:JJLocalizedString(@"BOOK_A_RIDE", nil) forState:UIControlStateNormal];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}
- (IBAction)segmentAction:(id)sender
{
    isSort=NO;

    switch (self.Rides_Segement.selectedSegmentIndex)
    {
        case 0:
            Rides_type=@"all";
            break;
        case 1:
            Rides_type=@"upcoming";
            break;
        case 2:
            Rides_type=@"completed";
            break;
        default:
            break;
    }
    [_MyRideTable reloadData];
}
-(void)GetRideList
{
    NSDictionary *parameters=@{@"user_id":[Themes getUserID],
                               @"type":Rides_type};
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web Myride:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
             responseDictionary=[Themes writableValue:responseDictionary];
             
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             [Themes StopView:self.view];
             
             if ([comfiramtion isEqualToString:@"1"])
             {
                 [_MyRideTable setHidden:NO];
                 NorideVIEW.hidden=YES;
                 
                 for (NSDictionary * objCatDict in responseDictionary[@"response"][@"rides"]) {
                     objcRecored=[[MyRideRecord alloc]init];
                     objcRecored.pickup=[objCatDict valueForKey:@"pickup"];
                     objcRecored.ride_date =[objCatDict valueForKey:@"ride_date"]  ;
                     objcRecored.ride_id=[objCatDict valueForKey:@"ride_id"] ;
                     objcRecored.ride_time=[objCatDict valueForKey:@"ride_time"] ;
                     objcRecored.group=[objCatDict valueForKey:@"group"] ;
                     objcRecored.myride_status=[objCatDict valueForKey:@"ride_status"];
                     objcRecored.dateTime=[objCatDict valueForKey:@"datetime"];
                     
                     if([objcRecored.group isEqualToString:@"upcoming"]){
                         [UpcomingArray addObject:objcRecored];
                         
                     }else if ([objcRecored.group isEqualToString:@"completed"]){
                         [CompleteArray addObject:objcRecored];
                     }
                     [RideAllArray addObject:objcRecored];
                     
                 }
                 [_MyRideTable reloadData];
                 
                 totalRides=[[responseDictionary valueForKey:@"response"] valueForKey:@"total_rides"];
                 
             }
             else
             {
                 
             }
         }
     }
        failure:^(NSError *error) {
            [Themes StopView:self.view];
        }];
}

- (IBAction)BookRide:(id)sender {
    
    AppDelegate*appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appdelegate setInitialViewController];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowcount=0;
    
    if(Rides_Segement.selectedSegmentIndex==0){
        
        if(isSort==YES){
            rowcount=[sortArray count];
            
            if (rowcount ==0)
            {
               [_MyRideTable setHidden:YES];
                NorideVIEW.hidden=NO;
                ///Sort_Btn.hidden=YES;
            }
            else
            {
                [_MyRideTable setHidden:NO];
                NorideVIEW.hidden=YES;
                Sort_Btn.hidden=NO;

            }
            
        }
        else
        {
            rowcount=[RideAllArray count];
            if (rowcount ==0)
            {
                [_MyRideTable setHidden:YES];
                NorideVIEW.hidden=NO;
               // Sort_Btn.hidden=YES;

            }
            else
            {
                [_MyRideTable setHidden:NO];
                NorideVIEW.hidden=YES;
                Sort_Btn.hidden=NO;

            }

        }
        
    }
    else if (Rides_Segement.selectedSegmentIndex==1)
    {
        if(isSort==YES){
            rowcount=[sortArray count];
            
            if (rowcount ==0)
            {
                [_MyRideTable setHidden:YES];
                NorideVIEW.hidden=NO;
                //Sort_Btn.hidden=YES;

            }
            else
            {
                [_MyRideTable setHidden:NO];
                NorideVIEW.hidden=YES;
                Sort_Btn.hidden=NO;
           }
        }
        else
        {
            rowcount=[UpcomingArray count];
            if (rowcount ==0)
            {
                [_MyRideTable setHidden:YES];
                NorideVIEW.hidden=NO;
                //Sort_Btn.hidden=YES;

            }
            else
            {
                [_MyRideTable setHidden:NO];
                NorideVIEW.hidden=YES;
                Sort_Btn.hidden=NO;
            }
            
        }

        
    }else if (Rides_Segement.selectedSegmentIndex==2){
        if(isSort==YES){
            rowcount=[sortArray count];
            
            if (rowcount ==0)
            {
                [_MyRideTable setHidden:YES];
                NorideVIEW.hidden=NO;
                //Sort_Btn.hidden=YES;

            }
            else
            {
                [_MyRideTable setHidden:NO];
                NorideVIEW.hidden=YES;
                Sort_Btn.hidden=NO;

            }
            
        }
        else
        {
            rowcount=[CompleteArray count];
            if (rowcount ==0)
            {
                [_MyRideTable setHidden:YES];
                NorideVIEW.hidden=NO;
               //Sort_Btn.hidden=YES;

            }
            else
            {
                [_MyRideTable setHidden:NO];
                NorideVIEW.hidden=YES;
               Sort_Btn.hidden=NO;

            }
            
        }

    }
    return rowcount;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (IS_IPHONE_6) {
        return 75;
    }
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"blah"; //should match what you've set in Interface Builder
    MyRideCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyRideCell" owner:nil options:nil] objectAtIndex:0];
      
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    MyRideRecord *objRec;
    
    if(Rides_Segement.selectedSegmentIndex==0){
       
        
        if(isSort==YES){
            objRec=(MyRideRecord*)[sortArray objectAtIndex:indexPath.row];
        }else{
            objRec=(MyRideRecord*)[RideAllArray objectAtIndex:indexPath.row];
            
        }
        ride_Status=objRec.myride_status;
        /*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:objRec.dateTime];
        
        [self relativeDateStringForDate:dateFromString];*/
        
        cell.placelable.text=ride_Status;

        if ([ride_Status isEqualToString:JJLocalizedString(@"Booked", nil) ] || [ride_Status isEqualToString:JJLocalizedString(@"Onride", nil)])
        {
            cell.status.backgroundColor=[UIColor orangeColor];
            
        }
        else if ([ride_Status isEqualToString:JJLocalizedString(@"Finished", nil)])
            
        {
            cell.status.backgroundColor=[UIColor blueColor];
            
        }
        else if ([ride_Status isEqualToString:JJLocalizedString(@"Completed", nil)])
            
        {
            cell.status.backgroundColor=[UIColor purpleColor];
            
        }
        else if ([ride_Status isEqualToString:JJLocalizedString(@"Cancelled", nil)])
            
        {
            cell.status.backgroundColor=[UIColor redColor];
            
        }
        else if ([ride_Status isEqualToString:JJLocalizedString(@"Confirmed", nil)])
            
        {
            cell.status.backgroundColor=[UIColor brownColor];
            
        }
        else if ([ride_Status isEqualToString:JJLocalizedString(@"Arrived", nil)])
        {
            cell.status.backgroundColor=[UIColor magentaColor];
        }
        cell.placelable.hidden=NO;

        
    }
    else if (Rides_Segement.selectedSegmentIndex==1)
    {
        
        if(isSort==YES){
            objRec=(MyRideRecord*)[sortArray objectAtIndex:indexPath.row];
        }else{
            objRec=(MyRideRecord*)[UpcomingArray objectAtIndex:indexPath.row];
            
        }
        
        cell.placelable.hidden=YES;
    }
    else if (Rides_Segement.selectedSegmentIndex==2){
        
        if(isSort==YES){
            objRec=(MyRideRecord*)[sortArray objectAtIndex:indexPath.row];
        }else{
            objRec=(MyRideRecord*)[CompleteArray objectAtIndex:indexPath.row];
            
        }
        cell.placelable.hidden=YES;

    }
    NSString * from=JJLocalizedString(@"from", nil);
    cell.Timelable.text=[NSString stringWithFormat:@"%@ %@ %@",objRec.ride_time,from,objRec.pickup];
    cell.Datelable.text=objRec.ride_date;
    
   
    
  
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRideRecord *objRec;
    
    
    if(Rides_Segement.selectedSegmentIndex==0)
    {
        if(isSort==YES){
            objRec=(MyRideRecord*)[sortArray objectAtIndex:indexPath.row];
            rideID= objRec.ride_id;

        }else{
            objRec=(MyRideRecord*)[RideAllArray objectAtIndex:indexPath.row];
            rideID= objRec.ride_id;
        }
        
    }
    
    else if (Rides_Segement.selectedSegmentIndex==1)
    {
        if(isSort==YES){
            objRec=(MyRideRecord*)[sortArray objectAtIndex:indexPath.row];
            rideID= objRec.ride_id;
            
        }else{
            objRec=(MyRideRecord*)[UpcomingArray objectAtIndex:indexPath.row];
            rideID= objRec.ride_id;
        }
    }
    else if (Rides_Segement.selectedSegmentIndex==2){
      
        if(isSort==YES){
            objRec=(MyRideRecord*)[sortArray objectAtIndex:indexPath.row];
            rideID= objRec.ride_id;
            
        }else{
            objRec=(MyRideRecord*)[CompleteArray objectAtIndex:indexPath.row];
            rideID= objRec.ride_id;
        }
    }
    
    [self retrieveMyRideslist];
    
}
/*-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIView *cellContentView  = [cell contentView];
    CGFloat rotationAngleDegrees = -30;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(500, -20.0);
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, -50.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, -50.0);
    cellContentView.layer.transform = transform;
    cellContentView.layer.opacity = 0.8;
    
    [UIView animateWithDuration:.65 delay:0.0 usingSpringWithDamping:0.85 initialSpringVelocity:.8 options:0 animations:^{
        cellContentView.layer.transform = CATransform3DIdentity;
        cellContentView.layer.opacity = 1;
    } completion:^(BOOL finished) {}];
    
}*/

-(void)retrieveMyRideslist
{
    NSDictionary * parameters=@{@"user_id":userID,
                                @"ride_id":rideID};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web GetMyRide:parameters success:^(NSMutableDictionary *responseDictionary)
     {
        
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
         NSLog(@"%@",responseDictionary);
         responseDictionary=[Themes writableValue:responseDictionary];

         NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
         [Themes StopView:self.view];
         if ([comfiramtion isEqualToString:@"1"])
         {
             
             objcRecored.cab_type=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"cab_type"];
             objcRecored.ride_id_detls =[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"ride_id"] ;
             objcRecored.ride_status=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"ride_status"];
             objcRecored.DisPlay_status=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"disp_status"];

             
             objcRecored.Currency=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"currency"];
             objcRecored.CancelStatus=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"do_cancel_action"];
             
             objcRecored.Track_Status=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"do_track_action"];
             objcRecored.Favourite_Status=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"is_fav_location"];
             
             objcRecored.location=[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"pickup"] valueForKey:@"location"];
             objcRecored.lon=[NSString stringWithFormat:@"%@",[[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"pickup"]  valueForKey:@"latlong"] valueForKey:@"lon"]];
             objcRecored.lat=[NSString stringWithFormat:@"%@",[[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"pickup"]  valueForKey:@"latlong"] valueForKey:@"lat"]];
             objcRecored.drop_date=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"drop_date"];

             objcRecored.Drop_lat=[NSString stringWithFormat:@"%@",[[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"drop"]  valueForKey:@"latlong"] valueForKey:@"lat"]];
             objcRecored.Drop_lon=[NSString stringWithFormat:@"%@",[[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"drop"]  valueForKey:@"latlong"] valueForKey:@"lon"]];
             
             
             
             objcRecored.pickup_date=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"pickup_date"];
             objcRecored.payStatus=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"pay_status"];
            
             objcRecored.total_bill=[NSString stringWithFormat:@"%@",[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"fare"] valueForKey:@"total_bill"]] ;
             objcRecored.Tip_Amount=[NSString stringWithFormat:@"%@",[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"fare"] valueForKey:@"tips_amount"]] ;
             objcRecored.Coupon_Discount=[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"fare"] valueForKey:@"coupon_discount"] ;
             objcRecored.grand_Bill=[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"fare"] valueForKey:@"grand_bill"];
             objcRecored.total_paid=[NSString stringWithFormat:@"%@",[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"fare"] valueForKey:@"total_paid"]];
             objcRecored.Wallet_usage=[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"fare"] valueForKey:@"wallet_usage"];
             objcRecored.distance_unit=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"distance_unit"] ;

             
             NSDictionary *aray =[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"summary"];
             
             if ([aray count]<=0)
             {
                
             }

//             else
             {
             objcRecored.ride_distance=[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"summary"]valueForKey:@"ride_distance"] ;
              objcRecored.ride_duration=[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"summary"]valueForKey:@"ride_duration"] ;
             objcRecored.waiting_duration=[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"summary"]valueForKey:@"waiting_duration"];
             
             }
             DetailMyRideVc * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsMyrideVCID"];
             [addfavour setAddressObj:objcRecored];
             [self.navigationController pushViewController:addfavour animated:YES];
             
             

         }
        }
    
         
     }
             failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
    
}

- (IBAction)didClickFilterBtn:(id)sender {
    NSArray * arryList=[[NSArray alloc]init];
    arryList=@[JJLocalizedString(@"All", nil) ,JJLocalizedString(@"Last one week", nil),JJLocalizedString(@"Last two weeks", nil),JJLocalizedString(@"Last one month", nil),JJLocalizedString(@"Last one year", nil)];
    [Dropobj fadeOut];
    [self showPopUpWithTitle:JJLocalizedString(@"Sort", nil)  withOption:arryList xy:CGPointMake(self.view.frame.size.width-205, 57) size:CGSizeMake(195, 310) isMultiple:NO];
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
    [_MyRideTable reloadData];
}
-(void)filterTableViewWithIndex:(NSInteger)index{
    sortArray=[[NSMutableArray alloc]init];
    NSMutableArray * dummayArray=[[NSMutableArray alloc]init];
    if(Rides_Segement.selectedSegmentIndex==0){
        dummayArray=RideAllArray;
    }else if (Rides_Segement.selectedSegmentIndex==1){
        dummayArray=UpcomingArray;
    }else if (Rides_Segement.selectedSegmentIndex==2){
        dummayArray=CompleteArray ;
    }
    for (int i=0; i<[dummayArray count]; i++) {
        MyRideRecord * objTripRecs=[dummayArray objectAtIndex:i];
        NSTimeInterval distanceBetweenDates = [[self getDateWithIndex:index] timeIntervalSinceDate:[self setDate:objTripRecs.dateTime]];
        double secondsInMinute = 60;
        NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
        
        if (secondsBetweenDates <= 0){
            [sortArray addObject:objTripRecs];
        }
    }
}
-(NSDate*)setDate:(NSString*)dateStr{
    if ([dateStr isKindOfClass:[NSDate class]]) {
        return (NSDate*)dateStr;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    return date;
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
        [Dropobj fadeOut];
    }
    [_MyRideTable reloadData];
}
- (NSString *)relativeDateStringForDate:(NSDate *)date
{
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear;
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    
    if (components.year > 0) {
        return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    } else if (components.weekOfYear > 0) {
        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    } else if (components.day > 0) {
        if (components.day > 1) {
            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
        } else {
            return @"Yesterday";
        }
    } else {
        return @"Today";
    }
}

@end
