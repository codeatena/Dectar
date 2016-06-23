//
//  RegistrationRecords.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/11/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistrationRecords : NSObject
@property(strong,nonatomic)NSString * driverLocationId;
@property(strong,nonatomic)NSString * driverLocation;
@property(strong,nonatomic)NSString * driverCategoryId;
@property(strong,nonatomic)NSString * driverCategory;
@property(strong,nonatomic)NSString * driverImage;

//Login details
@property(strong,nonatomic)NSString * driverName;
@property(strong,nonatomic)NSString * driverEmail;
@property(strong,nonatomic)NSString * driverPassword;
@property(strong,nonatomic)NSString * driverConfirmPassword;

//Address details
@property(strong,nonatomic)NSString * driverAddress;
@property(strong,nonatomic)NSString * driverCountry;
@property(strong,nonatomic)NSString * driverCountryId;
@property(strong,nonatomic)NSString * driverState;
@property(strong,nonatomic)NSString * driverCity;
@property(strong,nonatomic)NSString * driverPostalCode;
@property(strong,nonatomic)NSString * driverCountryCode;
@property(strong,nonatomic)NSString * driverMobileNumber;
@property(strong,nonatomic)NSString * driverMobileNumberOTP;

//Vehicle details
@property(strong,nonatomic)NSString * driverVehType;
@property(strong,nonatomic)NSString * driverVehTypeId;
@property(strong,nonatomic)NSString * driverVehMaker;
@property(strong,nonatomic)NSString * driverVehMakerId;
@property(strong,nonatomic)NSString * driverVehModel;
@property(strong,nonatomic)NSString * driverVehModelId;
@property(strong,nonatomic)NSString * driverVehNumber;
@property(strong,nonatomic)NSString * driverVehYear;
@property(strong,nonatomic)NSString * driverAircCondition;

//Document details
@property(strong,nonatomic)UIImage * driverPoliceVC;
@property(strong,nonatomic)UIImage * driverDrivingLic;
@property(strong,nonatomic)UIImage * driverDrivingExp;
@property(strong,nonatomic)UIImage * driverCertOfReg;
@property(strong,nonatomic)UIImage * driverInsuranceCopy;

@end
