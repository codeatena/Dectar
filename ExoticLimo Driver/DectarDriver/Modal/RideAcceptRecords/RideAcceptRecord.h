//
//  RideAcceptRecord.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/25/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RideAcceptRecord : NSObject

@property(strong,nonatomic)NSString * headerTxt;
@property(strong,nonatomic)NSString * RideId;
@property(strong,nonatomic)NSString * LocationName;
@property(strong,nonatomic)NSString * expiryTime;
@property(assign,nonatomic)NSInteger currentTimer;
@property(assign,nonatomic)NSInteger rideTag;
@property(assign,nonatomic)BOOL rideExpired;
@property(assign,nonatomic)BOOL rideCountStart;
@end
