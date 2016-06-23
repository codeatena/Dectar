//
//  VehicleInfoViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/8/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverDocViewController.h"
#import "Theme.h"
#import "RegistrationRecords.h"
#import "RootBaseViewController.h"
#import "TAlertView.h"

@interface VehicleInfoViewController : RootBaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *vehInfoHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UILabel *vehicleTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *vehicleMakerLbl;
@property (weak, nonatomic) IBOutlet UILabel *vehicleModelLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *vehNumTxtField;
@property (weak, nonatomic) IBOutlet UILabel *airConditionLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *airConditionSegment;
@property (weak, nonatomic) IBOutlet UILabel *yearLbl;
@property(strong,nonatomic)RegistrationRecords * objRegRecs;

@property(strong,nonatomic)NSMutableArray * vehListMainArr;
@property(strong,nonatomic)NSMutableArray * vehListArr;

@property(strong,nonatomic)NSMutableArray * vehMakerMainArr;
@property(strong,nonatomic)NSMutableArray * vehMakerArr;

@property(strong,nonatomic)NSMutableArray * vehModelMainArr;
@property(strong,nonatomic)NSMutableArray * vehModelArr;

@property(strong,nonatomic)NSMutableArray * vehYearMainArr;
@property(strong,nonatomic)NSMutableArray * vehYearArr;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;



- (IBAction)didChangeAirConditionSegment:(id)sender;

- (IBAction)didClickVehType:(id)sender;
- (IBAction)didClickVehMaker:(id)sender;
- (IBAction)didClickVehModel:(id)sender;

- (IBAction)didClickRewindBtn:(id)sender;
- (IBAction)didClickForwardBtn:(id)sender;
- (IBAction)didClickVehicleYear:(id)sender;

@end
