//
//  DropLocationViewController.h
//  DectarDriver
//
//  Created by Aravind Natarajan on 13/02/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "RootBaseViewController.h"
#import "UrlHandler.h"
#import "RTSpinKitView.h"
@protocol DropLocDelegate<NSObject>
@optional
-(void)sendDropLocation:(CLLocationCoordinate2D )locSelected;
@end
@interface DropLocationViewController : RootBaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>
@property(strong,nonatomic)id<DropLocDelegate> delegate;
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
@property (weak, nonatomic) IBOutlet UISearchBar *locSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *locTableView;

@property(strong,nonatomic)GMSCameraPosition * Camera;
@property(strong,nonatomic)GMSMapView * GoogleMap;
@property(strong,nonatomic)GMSMarker *marker;
@property(strong,nonatomic)GMSMarker *Destmarker;

@property(assign,nonatomic)float lattitude;
@property(assign,nonatomic)float longitude;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet HeaderLabelHandler *headerlbl;
@property (weak, nonatomic) IBOutlet UILabel *hint_lbl;

@property (weak, nonatomic) IBOutlet UIView *mapView;
@property(strong,nonatomic)NSMutableArray * filteredContentList;
@property(strong,nonatomic)NSString * locationStr;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property(strong,nonatomic)NSString * selLocStr;
- (IBAction)didClickBackBtn:(id)sender;
- (IBAction)didClickDoneBtn:(id)sender;
@end
