//
//  CancelRideVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 12/30/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import "CancelRideVC.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "Constant.h"
#import "LanguageHandler.h"

@interface CancelRideVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CancelRideVC
@synthesize TrackObj,Reason_Array,Cancel_tabel,submit_btn,Ride_ID,Reason_ID,Reason_Str;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Reason_Array=[NSMutableArray array];
    [self getCancelReason];
    [Cancel_tabel setDelegate:self];
    [Cancel_tabel setDataSource:self];
    submit_btn.userInteractionEnabled=NO;
    Cancel_tabel.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Do any additional setup after loading the view.
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_heading setText:JJLocalizedString(@"Tell_us_Why", nil)];
    [submit_btn setTitle:JJLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
    [_cancel_btn setTitle:JJLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Cancel_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)submit_action:(id)sender {
    [self SubmitRating];
}

-(void)getCancelReason
{
    NSDictionary * parameters=@{@"user_id":[Themes getUserID]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web CancelReason:parameters success:^(NSMutableDictionary *responseDictionary)
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
                 
                 
                 for (NSDictionary * objCatDict in responseDictionary[@"response"][@"reason"]) {
                     TrackObj=[[DriverRecord alloc]init];
                     TrackObj.reason=[objCatDict valueForKey:@"reason"];
                     TrackObj.ID_Reason =[objCatDict valueForKey:@"id"]  ;
                     [Reason_Array addObject:TrackObj];
                     
                 }
                 [Cancel_tabel reloadData];
                 
                 
             }
             else
             {
                 
             }
         }
         
     }
              failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Reason_Array count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
    }
    
    NSIndexPath* selection = [tableView indexPathForSelectedRow];
    if (selection && selection.row == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    DriverRecord *objRec=(DriverRecord*)[Reason_Array objectAtIndex:indexPath.row];
    UIFont *myFont = [UIFont fontWithName: @"Avenir-Medium" size: 18.0 ];
    cell.textLabel.font  = myFont;
    cell.textLabel.text=objRec.reason;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_6) {
        return 70;
    }
    return 59;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    TrackObj = [Reason_Array objectAtIndex:indexPath.row];
    
    Reason_Str=TrackObj.reason;
    Reason_ID=TrackObj.ID_Reason;
    
    submit_btn.backgroundColor=[UIColor orangeColor];
    submit_btn.userInteractionEnabled=YES;
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}
- (void)SubmitRating
{
    NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                @"ride_id":Ride_ID,
                                @"reason":Reason_ID};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web CancelRide:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
             NSLog(@"%@",responseDictionary);
             responseDictionary=[Themes writableValue:responseDictionary];
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             NSString * message=[[responseDictionary valueForKey:@"response"] valueForKey:@"message"];
             NSString * WrongStr=[responseDictionary valueForKey:@"response"];
             
             [Themes StopView:self.view];
             if ([comfiramtion isEqualToString:@"1"])
             {
                 
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
                 
                 AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 [del LogIn];
                 
             }
             else if ([comfiramtion isEqualToString:@"0"])
             {
                 NSString * already=JJLocalizedString(@"your_ride_already_cancelled", nil);
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:[NSString stringWithFormat:@"%@ %@",already,WrongStr] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
                 
                 AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 [del LogIn];
                 
                 
             }
         }
         
         
     }
            failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
    
    
}
@end
