//
//  DropVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 2/13/16.
//  Copyright © 2016 CasperonTechnologies. All rights reserved.
//

#import "DropVC.h"
#import "AFNetworking.h"
#import <AddressBook/AddressBook.h>
#import "BookARideVC.h"
#import "Themes.h"
#import "Constant.h"
#import "LanguageHandler.h"

@interface DropVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    NSMutableDictionary *SearchResponDict;
    NSMutableArray *SearchResultArray;
    
}
@property  CLLocationCoordinate2D center;
@property (strong ,nonatomic)CLLocationManager * currentLocation;
@property (strong, nonatomic) GMSMapView * GoogleMap;
@property (strong, nonatomic) GMSCameraPosition * Camera;
@property (strong, nonatomic)GMSMarker *DropMarker;
@end

@implementation DropVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [_table_content_view setHidden:YES];
    [_address_search setDelegate:self];
    _DropMarker = [[GMSMarker alloc] init];
    [_done setHidden:YES];

    _currentLocation = [[CLLocationManager alloc] init];
    [_currentLocation requestWhenInUseAuthorization];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        [_currentLocation requestAlwaysAuthorization];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        [_currentLocation requestAlwaysAuthorization];
        
    }
    
    _filterdata=[[NSMutableArray alloc]init];

    
    [_currentLocation startUpdatingLocation];
    [_currentLocation startMonitoringSignificantLocationChanges];

    [_currentLocation setDelegate:self];

    _Camera = [GMSCameraPosition cameraWithLatitude:_currentLocation.location.coordinate.latitude
                                         longitude: _currentLocation.location.coordinate.longitude
                                              zoom:17];
    _GoogleMap = [GMSMapView mapWithFrame:CGRectMake(0, 0, _mapBG.frame.size.width, _mapBG.frame.size.height) camera:_Camera];

    _GoogleMap.delegate = self;
    [_mapBG addSubview:_GoogleMap];
    _GoogleMap.myLocationEnabled = YES;

    // Do any additional setup after loading the view.
}

-(void)applicationLanguageChangeNotification:(NSNotification*)notification{
    
    [self.Header_Lbl setText:JJLocalizedString(@"Drop_Address", nil)];
    [self.done setTitle:JJLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [self.Long_press_lbl setText:JJLocalizedString(@"long_press_on_the", nil)];
    [self.address_search setPlaceholder:JJLocalizedString(@"Search_Drop_Location", nil)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_table_content_view setHidden:YES];
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([searchBar.text isEqualToString:@""])
    {
        _filterdata=nil;
        [_done setHidden:YES];

        
    }
    else
    {
        NSString *text1=[searchBar.text stringByAppendingString:text];
        
        if ([text1 containsString:@"\n"])
        {
            [_address_search resignFirstResponder];
        }
        else
        {
            NSString *searchbartxt=[text1 stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&language=en&key=%@",searchbartxt,GoogleServerKey];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *responseObject)
             {
                 //NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                 [_table_content_view setHidden:NO];
                 [_done setHidden:NO];
                 NSError *error = [operation error];
                 
                 NSDictionary *json =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                 if (json==nil)
                 {
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:JJLocalizedString(@"kindly_Search_vaild",nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 if (json>0) {
                     SearchResultArray= (NSMutableArray *) json[@"predictions"];
                     _filterdata  = (NSMutableArray *) [SearchResultArray valueForKey:@"description"];
                     
                     [self updateTableWithFilteredData:_filterdata];
                     
                 }
             }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"Error: %@", error);
                 }];
        }
       
        
    }
    
    return YES;
}
- (void)updateTableWithFilteredData:(NSMutableArray *)filteredData
{
    _filterdata = filteredData;
    [_addres_tabel setDelegate:self];
    [_addres_tabel setDataSource:self];
    [_addres_tabel reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if([CLLocationManager locationServicesEnabled]){
        
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"App_Permission_Denied", nil)
                                                               message:JJLocalizedString(@"To_re-enable_please",nil)
                                                              delegate:nil
                                                     cancelButtonTitle:JJLocalizedString(@"ok",nil)
                                                     otherButtonTitles:nil];
            [alert show];
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_filterdata count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.text = [_filterdata objectAtIndex:indexPath.row];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_address_search resignFirstResponder];
    [_table_content_view setHidden:YES];
    
    _address_search.text=[_filterdata objectAtIndex:indexPath.row];
    [self getGoogleAdrressFromStr:[_filterdata objectAtIndex:indexPath.row]];
    
    
}

-(void)getGoogleAdrressFromStr:(NSString *)addrStr{
    
    [Themes StartView:self.view];
    
     UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getGoogleLatLongToAddress:[self setParametersToaddr:addrStr]
                           success:^(NSMutableDictionary *responseDictionary)
     {
         @try {
             [Themes StopView:self.view];
             
             NSArray* jsonResults = [responseDictionary valueForKey:@"results"][0][@"geometry"][@"location"];
             if([jsonResults count]>0){
                 double latitude1 = 0, longitude1 = 0;
                 
                 latitude1 = [[jsonResults valueForKey:@"lat"] doubleValue];
                 longitude1 = [[jsonResults valueForKey:@"lng"] doubleValue];
                 
                 _latitude=latitude1;
                 _longitude=longitude1;
                 [_GoogleMap animateToLocation:CLLocationCoordinate2DMake(_latitude, _longitude)];
                 [_GoogleMap animateToZoom:17.0];
                 
                 _DropMarker.position=CLLocationCoordinate2DMake(_latitude, _longitude);
                 _DropMarker.map = _GoogleMap;
                 _DropMarker.title = @"This is your Drop Location";
                 _DropMarker.snippet = _address_search.text;
                 UIImage *mapicon=[UIImage imageNamed:@"drop_pin"];
                 _DropMarker.icon = mapicon;
                 _DropMarker.appearAnimation=kGMSMarkerAnimationPop;
                 _done.hidden=NO;
                 
             }else{
                 [self Toast:@"can't find address"];
             }
         }
         @catch (NSException *exception) {
             
         }
        
         
     }
                           failure:^(NSError *error)
     {
          [self Toast:@"can't find address"];
         [Themes StopView:self.view];

         
     }];
    
}

-(NSDictionary *)setParametersToaddr:(NSString *)addr{
    
    NSDictionary *dictForuser = @{
                                  @"address":addr,
                                  @"sensor":@"false",
                                  @"key":GoogleServerKey
                                  };
    return dictForuser;
}
-(void) mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    [_address_search resignFirstResponder];
    
    CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:coordinate.latitude
                                                        longitude:coordinate.longitude];
    
    [self getGoogleAdrressFromLatLong:newLocation];
    
    
}

-(void)getGoogleAdrressFromLatLong : (CLLocation *)loc{
    
      [Themes StartView:self.view];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getGoogleLatLongToAddress:[self setParameters:loc.coordinate.latitude withLon:loc.coordinate.longitude]
                           success:^(NSMutableDictionary *responseDictionary)
     {
         @try {
             [Themes StopView:self.view];
             NSArray* jsonResults = [[responseDictionary valueForKey:@"results"]valueForKey:@"formatted_address"];
             if([jsonResults count]>0){
                 
                 _latitude=loc.coordinate.latitude;
                 _longitude=loc.coordinate.longitude;
                 if(jsonResults.count>=2){
                     _address_search.text=[Themes writableValue: [jsonResults objectAtIndex:1]];
                 }else{
                     _address_search.text=[Themes writableValue: [jsonResults objectAtIndex:0]];
                     
                     
                 }
                 [_GoogleMap animateToLocation:CLLocationCoordinate2DMake(_latitude, _longitude)];
                 [_GoogleMap animateToZoom:17.0];
                 
                 _DropMarker.position=CLLocationCoordinate2DMake(_latitude, _longitude);
                 _DropMarker.map = _GoogleMap;
                 _DropMarker.title = @"This is your Drop Location";
                 _DropMarker.snippet = _address_search.text;
                 UIImage *mapicon=[UIImage imageNamed:@"drop_pin"];
                 _DropMarker.icon = mapicon;
                 _DropMarker.appearAnimation=kGMSMarkerAnimationPop;
                 _done.hidden=NO;
                 
                 [_done setHidden:NO];
                 
             }else{
                 [self Toast:@"can't find address"];
             }
         
         }
         @catch (NSException *exception) {
             
         }
        
     }
                           failure:^(NSError *error)
     {
         [self Toast:@"can't find address"];
         [Themes StopView:self.view];

         
     }];
    
}

-(NSDictionary *)setParameters:(float )lat withLon:(float)lon{
    
    NSDictionary *dictForuser = @{
                                  @"latlng":[NSString stringWithFormat:@"%f,%f",lat,lon],
                                  @"sensor":@"false",
                                  @"key":GoogleServerKey
                                  
                                  };
    return dictForuser;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)Done_action:(id)sender {
    
    CLLocation *  objCl =[[CLLocation alloc] initWithLatitude:_latitude longitude:_longitude];
    
    [self.delegate passDropLatLong:objCl withDropTxt:_address_search.text];
      [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}

@end
