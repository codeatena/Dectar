//
//  TripRecords.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/31/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripRecords : NSObject
@property(strong,nonatomic)NSString * tripId;
@property(strong,nonatomic)NSString * tripTime;
@property(strong,nonatomic)NSString * tripDate;
@property(strong,nonatomic)NSString * tripLocation;
@property(strong,nonatomic)NSString * tripStatus;
@property(strong,nonatomic)NSString * tripeOrigDate;
@end
