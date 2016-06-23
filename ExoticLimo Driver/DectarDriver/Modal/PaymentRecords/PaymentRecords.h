//
//  PaymentRecords.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/14/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentRecords : NSObject

@property(strong,nonatomic)NSString * paymentID;
@property(strong,nonatomic)NSString * toDate;
@property(strong,nonatomic)NSString * fromDate;
@property(strong,nonatomic)NSString * PriceSymbol;
@property(strong,nonatomic)NSString * Amount;
@property(strong,nonatomic)NSString * ReceivedDate;
@end
