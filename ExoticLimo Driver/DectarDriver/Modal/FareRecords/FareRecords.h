//
//  FareRecords.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/1/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FareRecords : NSObject
@property(strong,nonatomic)NSString * currency;
@property(strong,nonatomic)NSString * rideDistance;
@property(strong,nonatomic)NSString * rideFare;
@property(strong,nonatomic)NSString * rideDuration;
@property(strong,nonatomic)NSString * waitingDuration;
@property(strong,nonatomic)NSString *  needPayment;
@property(strong,nonatomic)NSString *  needCash;
@end
