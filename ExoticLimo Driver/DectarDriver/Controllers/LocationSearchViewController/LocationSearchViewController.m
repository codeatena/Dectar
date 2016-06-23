//
//  LocationSearchViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/23/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

#import "LocationSearchViewController.h"

@interface LocationSearchViewController ()

@end

@implementation LocationSearchViewController
@synthesize filteredContentList,locSearchBar,locTableView,doneBtn,locationStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    doneBtn.hidden=YES;
      [locSearchBar setReturnKeyType:UIReturnKeyDone];
    [_headerlbl setText:JJLocalizedString(@"Location_Search", nil)];
    [doneBtn setTitle:JJLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}
- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    [locSearchBar resignFirstResponder];
    //locTableView.hidden=YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [locSearchBar resignFirstResponder];
   // locTableView.hidden=YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [filteredContentList count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.text = [filteredContentList objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    return cell;
    
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *text1=[searchBar.text stringByAppendingString:text];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web SearchGoogleLocation:[self setParametersForLocation:text1]
                  success:^(NSMutableDictionary *responseDictionary)
     {
         NSLog(@"%@",responseDictionary);
         NSMutableArray *results = (NSMutableArray *) responseDictionary[@"predictions"];
         //filteredContentList=[[NSMutableArray alloc]init];
         filteredContentList  = (NSMutableArray *) [results valueForKey:@"description"];
         [locTableView reloadData];
     }
                  failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [self.view makeToast:kErrorMessage];
         
     }];
    return YES;
}

-(NSDictionary *)setParametersForLocation:(NSString *)str{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"input":str,
                                  @"key":kGoogleServerKey,
                                  };
    return dictForuser;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [locSearchBar resignFirstResponder];
    locSearchBar.text=[filteredContentList objectAtIndex:indexPath.row];
    locationStr=locSearchBar.text;
    doneBtn.hidden=NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)didClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickDoneBtn:(id)sender {
    [self.delegate sendLocation:locationStr];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
