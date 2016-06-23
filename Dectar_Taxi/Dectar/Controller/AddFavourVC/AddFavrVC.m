//
//  AddFavrVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/24/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "AddFavrVC.h"
#import "UrlHandler.h"
#import "Themes.h"
#import "Constant.h"
#import "LanguageHandler.h"

@interface AddFavrVC ()
@property (strong, nonatomic) IBOutlet UIButton *locaBtn;
@property (strong, nonatomic) IBOutlet UITextField *address_fld;



@end

@implementation AddFavrVC
@synthesize Title,Address,MapBG,Camera,GoogleMap,currentLocation,longitude,latitude,addressObj,locaBtn,locationKey,favourObj,isFromEdit,UserID;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UserID=[Themes getUserID];

    /*currentLocation = [[CLLocationManager alloc] init];
    currentLocation.distanceFilter = kCLDistanceFilterNone;
    currentLocation.desiredAccuracy = kCLLocationAccuracyBest; // 100m
    [currentLocation startUpdatingLocation];
    
    Camera = [GMSCameraPosition cameraWithLatitude: currentLocation.location.coordinate.latitude
     longitude: currentLocation.location.coordinate.longitude
     zoom:17];
     
     GoogleMap = [GMSMapView mapWithFrame:BGmapView.frame camera:Camera];
    
        latitude =currentLocation.location.coordinate.latitude;
    longitude =currentLocation.location.coordinate.longitude;*/
   
    if (isFromEdit==YES)
    {
        [self setFavourObj:favourObj];
        Camera = [GMSCameraPosition cameraWithLatitude:latitude
                                             longitude:longitude
                                                  zoom:15];
        [GoogleMap animateToCameraPosition:Camera];

    }
    else if (isFromEdit==NO)
    {
    [self setAddressObj:addressObj];
        Camera = [GMSCameraPosition cameraWithLatitude:latitude
                                             longitude:longitude
                                                  zoom:15];
        [GoogleMap animateToCameraPosition:Camera];

    }
    
   /* CGRect mapFrame=GoogleMap.frame;
    mapFrame.origin.y=0;
    GoogleMap.frame=mapFrame;*/

    GoogleMap = [GMSMapView mapWithFrame:CGRectMake(0, 0, MapBG.frame.size.width , MapBG.frame.size.height) camera:Camera];
    GoogleMap.myLocationEnabled = YES;

    [Themes statusbarColor:self.view];
    GoogleMap.delegate = self;
    [MapBG addSubview:GoogleMap];
    
    [MapBG addSubview:_pinpoint];
    [MapBG addSubview:_current_Loc];

    // Do any additional setup after loading the view.
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_heading setText:JJLocalizedString(@"Add_Favorite", nil)] ;
    [Title setPlaceholder:JJLocalizedString(@"Name_of_your_favorites", nil)];
    [_Save setTitle:JJLocalizedString(@"save", nil) forState:UIControlStateNormal];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setAddressObj:(AddressRecord *)_addressObj
{
    addressObj=_addressObj;
    latitude=_addressObj.ADDlatitude;
    longitude=_addressObj.ADDlongitude;
    Address.text=_addressObj.addressStr;
    
}
-(void)setFavourObj:(FavourRecord *)_favourObj
{
    favourObj=_favourObj;
    Address.text=_favourObj.Address;
    latitude=_favourObj.latitudeStr;
    longitude=_favourObj.longitude;
    locationKey=_favourObj.locationkey;
    Title.text=_favourObj.titleString;
    _address_fld.text=_favourObj.Address;
}
- (IBAction)SaveAddress:(id)sender {
    if (isFromEdit==YES)
    {
       
        if ([Title.text isEqualToString:@""])
        {
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Check !", nil)  message:JJLocalizedString(@"Kindly_Enter_Name_of_your_favorites", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
        }
 		else if ([Address.text isEqualToString:@""])
        {
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Check !", nil) message:JJLocalizedString(@"Kindly_Enter_Address", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
        }
        else
        {
            [self EditFavour];

        }
    
    }
    else if (isFromEdit==NO)
    {
        
        if ([Title.text isEqualToString:@""])
        {
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Check !", nil)  message:JJLocalizedString(@"Kindly_Enter_Name_of_your_favorites", nil)   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
          [Alert show];
        }
		 else if ([Address.text isEqualToString:@""])
        {
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Check !", nil)  message:JJLocalizedString(@"Kindly_Enter_Address", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
        }
        else
        {
            [self AddFavor];

        }
    }
}

- (IBAction)BackTo:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];

    }

}
-(void)AddFavor
{
    NSString*PicklatitudeStr=[NSString stringWithFormat:@"%f",latitude];
    NSString*PicklongitudeStr=[NSString stringWithFormat:@"%f",longitude];
    
    NSDictionary * parameters=@{@"title":Title.text,
                                @"latitude":PicklatitudeStr,
                                @"longitude":PicklongitudeStr,
                                @"address":Address.text,
                                @"user_id":UserID};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web SaveFavourite:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         NSLog(@"%@",responseDictionary);
         [Themes StopView:self.view];

         if ([responseDictionary count]>0)
         {
             responseDictionary=[Themes writableValue:responseDictionary];
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             [Themes StopView:self.view];
             
             if ([comfiramtion isEqualToString:@"1"])
             {
                 NSString * messageString=[responseDictionary valueForKey:@"message"];
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:messageString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
                 
             }
             else
             {
                 NSString * messageString=[responseDictionary valueForKey:@"message"];
                 NSString *titleStr = JJLocalizedString(@"Oops", nil);
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
                 
             }

         }
         
         
     }
     
               failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
}
-(void)EditFavour
{
    NSString*PicklatitudeStr=[NSString stringWithFormat:@"%f",latitude];
    NSString*PicklongitudeStr=[NSString stringWithFormat:@"%f",longitude];
    
    NSDictionary * parameters=@{@"title":Title.text,
                                @"latitude":PicklatitudeStr,
                                @"longitude":PicklongitudeStr,
                                @"address":Address.text,
                                @"user_id":UserID,
                                @"location_key":locationKey
                                    };
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    
    [web EditListFavour :parameters success:^(NSMutableDictionary *responseDictionary)
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
                 NSString * messageString=[responseDictionary valueForKey:@"message"];
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:messageString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
                 
             }
             else
             {
                 NSString * messageString=[NSString stringWithFormat:@"%@",@"message"];
                 NSString *titleStr = JJLocalizedString(@"Oops", nil);
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
                 
             }
             

         }
         
     }
     
               failure:^(NSError *error)
     {
        
         [Themes StopView:self.view];
     }];

}
- (IBAction)CurrentLocation:(id)sender {
    CLLocation *location = GoogleMap.myLocation;
    if (location) { //https://maps.googleapis.com/maps/api/distancematrix/json?
        [GoogleMap animateToLocation:location.coordinate];
    }
    
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    
    [Address resignFirstResponder];
    [Title resignFirstResponder];
    
    CGPoint point = GoogleMap.center;
    CLLocationCoordinate2D coor = [mapView.projection coordinateForPoint:point];
    
    /* CLGeocoder *geocoder = [[CLGeocoder alloc] init];
     
     CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:coor.latitude
     longitude:coor.longitude];
     latitude=coor.latitude;
     longitude=coor.longitude;*/
    
    latitude=coor.latitude;
    longitude=coor.longitude;
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(coor.latitude, coor.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        
        GMSAddress * address=[response firstResult];
        NSString * temp1=[address.lines objectAtIndex:0];
        NSString *temp2=[address.lines objectAtIndex:1];
        //  NSString * final=[NSString stringWithFormat:@"%@, %@", temp1 ,temp2];
        
        NSString *undesired = @"(null),";
        NSString *desired   = @"";
        
        NSString *addressString=[NSString stringWithFormat:@"%@,%@",temp1,temp2];
       
            Address.text = [addressString stringByReplacingOccurrencesOfString:undesired
                                                                         withString:desired];
 	NSArray *elements = [Address.text componentsSeparatedByString:@","];
        NSMutableArray *outputElements = [[NSMutableArray alloc] init];
        for (NSString *element in elements)
            if ([element length] > 0)
                [outputElements addObject:element];
        
        Address.text= [outputElements componentsJoinedByString:@","];
        _address_fld.text= [addressString stringByReplacingOccurrencesOfString:undesired
                                                                    withString:desired];

        
        latitude=coor.latitude;
        longitude=coor.longitude;
        
        //NSLog(@"Geocode failed with error: %f %f", latitude,longitude);

        
    }];
    
    /* [geocoder reverseGeocodeLocation:newLocation
     completionHandler:^(NSArray *placemarks, NSError *error) {
     
     if (error) {
     NSLog(@"Geocode failed with error: %@", error);
     return;
     }
     
     if (placemarks && placemarks.count > 0)
     {
     CLPlacemark *placemark = placemarks[0];
     
     NSDictionary *addressDictionary =
     placemark.addressDictionary;
     
     NSString *address = [addressDictionary
     objectForKey:(NSString *)kABPersonAddressStreetKey];
     NSString *city = [addressDictionary
     objectForKey:(NSString *)kABPersonAddressCityKey];
     NSString *state = [addressDictionary
     objectForKey:(NSString *)kABPersonAddressStateKey];
     //                           NSString *zip = [addressDictionary
     //                                            objectForKey:(NSString *)kABPersonAddressZIPKey];
     
     NSString *SunLocal =[addressDictionary objectForKey:@"SubAdministrativeArea"];
     
     NSString *undesired = @"(null),";
     NSString *desired   = @"";
     
     addressString=[NSString stringWithFormat:@"%@,%@,%@,%@",address,city,SunLocal,state];
     if(isLocationSelected==NO){
     AddressField.text = [addressString stringByReplacingOccurrencesOfString:undesired
     withString:desired];
     }
     isLocationSelected=NO;
     }
     
     }];*/
}

@end
