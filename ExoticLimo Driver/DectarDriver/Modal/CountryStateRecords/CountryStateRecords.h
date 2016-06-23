//
//  CountryStateRecords.h
//  eCommerce
//
//  Created by Casperon Technologies on 4/18/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryStateRecords : NSObject
@property(strong,nonatomic)NSString * countryId;
@property(strong,nonatomic)NSString * countryName;
@property(assign,nonatomic)BOOL  hasCountry;
@property(strong,nonatomic)NSString * stateId;
@property(strong,nonatomic)NSString * stateName;
@property(assign,nonatomic)BOOL  hasState;

@end
