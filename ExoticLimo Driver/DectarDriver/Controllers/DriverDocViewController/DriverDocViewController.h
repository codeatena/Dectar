//
//  DriverDocViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/8/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"
#import "UrlHandler.h"

@interface DriverDocViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *activeSegmentControl;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *driverDocHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *vehDocHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *policeVerLbl;
@property (weak, nonatomic) IBOutlet UILabel *drivLicLbl;
@property (weak, nonatomic) IBOutlet UILabel *drivExpLbl;
@property (weak, nonatomic) IBOutlet UILabel *certOfRegLbl;
@property (weak, nonatomic) IBOutlet UILabel *insuranceLbl;
@property (weak, nonatomic) IBOutlet UILabel *statuslbl;
@property(strong,nonatomic)UIImagePickerController *imagePicker;
@property(strong,nonatomic)UIButton * selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *insuranceBtn;


- (IBAction)didClickmageSelect:(id)sender;



- (IBAction)didClickForwardBtn:(id)sender;
- (IBAction)didClickRewindBtn:(id)sender;
@end
