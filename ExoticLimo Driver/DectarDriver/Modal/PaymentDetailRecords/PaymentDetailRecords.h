//
//  PaymentDetailRecords.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/14/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentDetailRecords : NSObject

@property(strong,nonatomic)NSString * rideId;
@property(strong,nonatomic)NSString * amount;
@property(strong,nonatomic)NSString * currencySymbol;
@property(strong,nonatomic)NSString * date;


@end
