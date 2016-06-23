//
//  DropVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 2/13/16.
//  Copyright © 2016 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "RootBaseVC.h"
#import "UrlHandler.h"
@protocol returnLatLongDelegate<NSObject>
-(void)passDropLatLong:(CLLocation *)dLoc withDropTxt:(NSString *)dropPlace;
@end

@interface DropVC : RootBaseVC
@property(strong,nonatomic)id<returnLatLongDelegate> delegate;
@property (strong, nonatomic) IBOutlet UISearchBar *address_search;
@property (strong, nonatomic) IBOutlet UITableView *addres_tabel;
@property (strong, nonatomic) IBOutlet UIView *table_content_view;
@property (strong, nonatomic) IBOutlet UIView *mapBG;
@property (strong, nonatomic) IBOutlet UIButton *Back_Btn;
@property (strong, nonatomic) IBOutlet UIButton *done;
@property (strong, nonatomic) IBOutlet UILabel *Header_Lbl;

@property (strong, nonatomic) IBOutlet UILabel *Long_press_lbl;
 
@property (strong, nonatomic) NSMutableArray * filterdata;
@property  (assign,nonatomic)CGFloat latitude;
@property  (assign,nonatomic)CGFloat longitude;
@end
