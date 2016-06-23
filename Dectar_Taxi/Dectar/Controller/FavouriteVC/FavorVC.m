//
//  FavorVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/21/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "FavorVC.h"
#import "UrlHandler.h"
#import "Themes.h"
#import "FavourRecord.h"
#import "AddFavrVC.h"
#import "FavorCell.h"
#import "AddressRecord.h"
#import "BookARideVC.h"
#import "Constant.h"
#import "LanguageHandler.h"


@interface FavorVC ()
{
    NSString * UserID;
    NSMutableArray * LocationArray;
    FavourRecord * objcRecored;
    
}
@property (strong, nonatomic) IBOutlet UIView *AddFavrView;
@end

@implementation FavorVC
@synthesize FavrList,EmptyFavor,CurrentFavour,objRecord,EditFavour,AddFavrView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserID=[Themes getUserID];
    
    //CurrentFavour.text=objRecord.addressStr;
    [self setObjRecord:objRecord];
    [Themes statusbarColor:self.view];
    
    FavrList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Do any additional setup after loading the view.
}

-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [EditFavour setTitle:JJLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    [_Add_favourite setText:JJLocalizedString(@"ADD_FAVORITES", nil)];
    [_Not_favour setText:JJLocalizedString(@"No_Favorites_added_yet", nil)];
    [_hint_lbl setText:JJLocalizedString(@"Select_frequent_pickup_location_and", nil)];
    [_heading_favour setText:JJLocalizedString(@"Favorites", nil)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setObjRecord:(AddressRecord *)_objRecord
{
    objRecord=_objRecord;
    CurrentFavour.text=objRecord.addressStr;
    
}
- (IBAction)Edit:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    [button setBackgroundColor:[UIColor clearColor]];
    if ([button.titleLabel.text isEqualToString:JJLocalizedString(@"Edit", nil) ])
    {
        [FavrList setEditing:YES animated:YES];
        [button setTitle:JJLocalizedString(@"Done", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:37.0/255.0 green:170.0/255.0 blue:314.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self viewSlideInFromTopToBottom:AddFavrView];
        [AddFavrView setHidden:YES];


    }
    else if ([button.titleLabel.text isEqualToString:JJLocalizedString(@"Done", nil)])
    {
        [FavrList setEditing:NO animated:YES];
        [EditFavour setTitle:JJLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
        [self viewSlideInFromBottomToTop:AddFavrView];
        [AddFavrView setHidden:NO];
    }

}
-(void)viewSlideInFromBottomToTop:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromTop ;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}
-(void)viewSlideInFromTopToBottom:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromBottom ;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    LocationArray=[NSMutableArray array];

    [self retrieveFavlist];
    

}
-(void)retrieveFavlist
{
    NSDictionary * parameters=@{@"user_id":UserID};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web GetFavrList:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
         
         NSLog(@"%@",responseDictionary);
         [Themes StopView:self.view];
         responseDictionary=[Themes writableValue:responseDictionary];

         NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
         
         if ([comfiramtion isEqualToString:@"1"])
         {
             FavrList.hidden=NO;
             EmptyFavor.hidden=NO;
             EditFavour.hidden=NO;

             
             for (NSDictionary * objCatDict in responseDictionary[@"response"][@"locations"]) {
                 objcRecored=[[FavourRecord alloc]init];
                 objcRecored.Address=[objCatDict valueForKey:@"address"];
                 objcRecored.latitudeStr =[[objCatDict valueForKey:@"latitude"] doubleValue] ;
                 objcRecored.longitude=[[objCatDict valueForKey:@"longitude"]doubleValue] ;
                 objcRecored.titleString=[objCatDict valueForKey:@"title"];
                 objcRecored.locationkey=[objCatDict valueForKey:@"location_key"];
              
                 [LocationArray addObject:objcRecored];
                 
                 [FavrList reloadData];
             }
             
         }
         else
         {
             EmptyFavor.hidden=NO;
             FavrList.hidden=YES;
             EditFavour.hidden=YES;
         }
         }
         
     }
             failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)BackTo:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [LocationArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    FavorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FavorCell" owner:nil options:nil] objectAtIndex:0];
        
       
    }
    
    FavourRecord *objRec=(FavourRecord*)[LocationArray objectAtIndex:indexPath.row];
    cell.TitleLable.text=objRec.titleString;
    cell.AddressLable.text=objRec.Address;
    
      return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
            return 100;
   
}

- (NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self viewSlideInFromTopToBottom:AddFavrView];
    [AddFavrView setHidden:YES];

    return @"Edit";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
            if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            
            FavourRecord *objRec=(FavourRecord*)[LocationArray objectAtIndex:indexPath.row];
            
            NSDictionary * parameters=@{@"user_id":UserID,
                                        @"location_key":objRec.locationkey};
            
            UrlHandler *web = [UrlHandler UrlsharedHandler];
            [Themes StartView:self.view];
            [web DeleteList:parameters success:^(NSMutableDictionary *responseDictionary)
             
             {
                 [Themes StopView:self.view];
                 
                 if ([responseDictionary count]>0)
                 {
                 NSLog(@"%@",responseDictionary);
                 responseDictionary=[Themes writableValue:responseDictionary];

                 NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                 NSString * message=[responseDictionary valueForKey:@"message"];
                 [Themes StopView:self.view];

                 if ([comfiramtion isEqualToString:@"1"])
                 {
                     
                     [LocationArray removeObjectAtIndex:indexPath.row];
                      
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:YES];
                    [FavrList reloadData];
                     
                     NSString * messageString=[NSString stringWithFormat:@"%@",message];
                     UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [Alert show];
                     NSLog(@"%lu",(unsigned long)[LocationArray count]);
                     
                     if ([LocationArray count]==0)
                     {
                         EmptyFavor.hidden=NO;
                         FavrList.hidden=YES;
                         EditFavour.hidden=YES;
                         AddFavrView.hidden=NO;
                        
                     }
                     
                }
            }
        }
            failure:^(NSError *error)
            
            {
                [Themes StopView:self.view];
             }];

            
            /*[userlist removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:YES];
            [userlst reloadData];*/
        }
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavourRecord *objRec=(FavourRecord*)[LocationArray objectAtIndex:indexPath.row];
   
    [[NSNotificationCenter defaultCenter] postNotificationName: @"PushView" object:objRec];

    [self.navigationController popViewControllerAnimated:YES];

}
-(void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavourRecord *objRec=(FavourRecord*)[LocationArray objectAtIndex:indexPath.row];

    [self edit:objRec];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // [self viewSlideInFromBottomToTop:AddFavrView];
    [AddFavrView setHidden:NO];

        return YES;
}
- (IBAction)AddFavour:(id)sender
{
    AddFavrVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"AddFavrVCID"];
    [addfavour setAddressObj:objRecord];
     [addfavour setIsFromEdit:NO];
    [self.navigationController pushViewController:addfavour animated:YES];


}
-(void)edit:(FavourRecord*)objRecords
{
    AddFavrVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"AddFavrVCID"];
    [addfavour setFavourObj:objRecords];
    [addfavour setIsFromEdit:YES];
    [self.navigationController pushViewController:addfavour animated:YES];
}
@end
