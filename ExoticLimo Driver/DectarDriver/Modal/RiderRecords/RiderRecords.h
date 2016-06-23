//
//  RiderRecords.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/26/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiderRecords : NSObject
@property(strong,nonatomic)NSString * RideId;
@property(strong,nonatomic)NSString * userEmail;
@property(strong,nonatomic)NSString * userImage;
@property(strong,nonatomic)NSString * userName;
@property(strong,nonatomic)NSString * userLocation;
@property(strong,nonatomic)NSString * userLattitude;
@property(strong,nonatomic)NSString * userLongitude;
@property(strong,nonatomic)NSString * userReview;
@property(strong,nonatomic)NSString * userTime;
@property(strong,nonatomic)NSString * userPhoneNumber;
@property(strong,nonatomic)NSString * UserId;



@property(strong,nonatomic)NSString * hasDropLocation;
@property(strong,nonatomic)NSString * dropAddress;
@property(strong,nonatomic)NSString * dropLat;
@property(strong,nonatomic)NSString * dropLong;
@end
