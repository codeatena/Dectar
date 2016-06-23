//
//  CountryStateViewController.m
//  eCommerce
//
//  Created by Casperon Technologies on 4/17/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "CountryStateViewController.h"

@interface CountryStateViewController ()

@end

@implementation CountryStateViewController
@synthesize delegate,iscountry,countryStateArray,locationTblView,headerTitleLbl,countrySearchBar,searchArray,dummySearchArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [headerTitleLbl setText:JJLocalizedString(@"Select_Country", nil)];
    [countrySearchBar setPlaceholder:JJLocalizedString(@"Enter_Search", nil)];
    
      locationTblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setReturnKeyBoard];
    [self getCountryList];
    // Do any additional setup after loading the view.
}
-(void)setReturnKeyBoard{
    for (UIView *subview in countrySearchBar.subviews)
    {
        for (UIView *subSubview in subview.subviews)
        {
            if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
            {
                UITextField *textField = (UITextField *)subSubview;
                [textField setKeyboardAppearance: UIKeyboardAppearanceDefault];
                textField.returnKeyType = UIReturnKeyDone;
                textField.enablesReturnKeyAutomatically=NO;
                break;
            }
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)getCountryList{
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getCountryList:nil
                success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             
             NSArray * locArr=responseDictionary[@"response"][@"countries"];
             searchArray = [[NSMutableArray alloc]init];
              dummySearchArray = [[NSMutableArray alloc]init];
             if([locArr count]>0){
                 countryStateArray=[[NSMutableArray alloc]init];
                 for(NSDictionary * locDict in locArr){
                     DriverLoRecords * objDrivRecs=[[DriverLoRecords alloc]init];
                     objDrivRecs.countryId=[Theme checkNullValue:[locDict objectForKey:@"id"]];
                     objDrivRecs.countryName=[Theme checkNullValue:[locDict objectForKey:@"name"]];
                     objDrivRecs.dialCode=[Theme checkNullValue:[locDict objectForKey:@"dial_code"]];
                     [searchArray addObject:[NSString stringWithFormat:@"%@",objDrivRecs.countryName]];
                     [dummySearchArray addObject:[NSString stringWithFormat:@"%@",objDrivRecs.countryName]];
                      [countryStateArray addObject:objDrivRecs];
                     
                 }
                  [locationTblView reloadData];
             }else{
                 [self.view makeToast:@"No_Locations_Found"];
             }
         }else{
             
             [self.view makeToast:[Theme checkNullValue:[responseDictionary objectForKey:@"response"]]];
         }
     }
                failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [self.view makeToast:kErrorMessage];
         
     }];
}


-(void)JsonFetchedDatas:(NSDictionary *)dataArray{
    
   
    [locationTblView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dummySearchArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[dummySearchArray objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:13];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * countryStateString=[dummySearchArray objectAtIndex:indexPath.row];
    for (int i=0; i<[countryStateArray count]; i++) {
        DriverLoRecords * objRec=[countryStateArray objectAtIndex:i];
        NSString * str=objRec.countryName;
        
        if([str isEqualToString:countryStateString]){
         
                [self.delegate GetCountryAndStateInfo:objRec];
                break;
            
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([searchText isEqualToString:@""]){
        dummySearchArray=searchArray;
        [searchBar resignFirstResponder];
    }else{
        NSPredicate *searchSearch = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", searchText];
        NSArray *searchResults = [searchArray filteredArrayUsingPredicate:searchSearch];
        dummySearchArray=[searchResults mutableCopy];
    }
    [locationTblView reloadData];
    
}

- (IBAction)didClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
