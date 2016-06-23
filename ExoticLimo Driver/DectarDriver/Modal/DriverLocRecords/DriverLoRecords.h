//
//  DriverLoRecords.h
//  DectarDriver
//
//  Created by Casperon Tech on 19/02/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverLoRecords : NSObject

@property(strong,nonatomic)NSString * locId;
@property(strong,nonatomic)NSString * LocName;
@property(strong,nonatomic)NSString * catId;
@property(strong,nonatomic)NSString * catName;
@property(strong,nonatomic)NSString * countryId;
@property(strong,nonatomic)NSString * countryName;
@property(strong,nonatomic)NSString * dialCode;


@property(strong,nonatomic)NSString * vehType;
@property(strong,nonatomic)NSString * vehTypeId;

@property(strong,nonatomic)NSString * vehModel;
@property(strong,nonatomic)NSString * vehModelId;

@property(strong,nonatomic)NSString * vehMaker;
@property(strong,nonatomic)NSString * vehMakerID;

@property(strong,nonatomic)NSString * vehYear;
@property(strong,nonatomic)NSString * vehYearId;
@end
