//
//  RegisterViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/21/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"
#import "RootBaseViewController.h"
#import "LoginDetailsViewController.h"
#import "RegistrationRecords.h"
#import "DriverLoRecords.h"

@interface RegisterViewController : RootBaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UIView *basicView;
@property (weak, nonatomic) IBOutlet UIButton *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *driveLocHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
@property (weak, nonatomic) IBOutlet UILabel *DriverCatgHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic)UIImagePickerController *imagePicker;
@property(strong,nonatomic)RegistrationRecords * objRegRecs;
@property(strong,nonatomic)NSMutableArray * driveMainLocArray;
@property(strong,nonatomic)NSMutableArray * driveCatMainArray;
@property(strong,nonatomic) NSMutableArray * LocNamearr;
@property(strong,nonatomic) NSMutableArray * catNameArr;

- (IBAction)didClickLocationBtn:(id)sender;
- (IBAction)didClickCategoryBtn:(id)sender;
- (IBAction)didClickUserImageBtn:(id)sender;

- (IBAction)didClickBackBtn:(id)sender;
- (IBAction)didClickForwardBtn:(id)sender;

@end
