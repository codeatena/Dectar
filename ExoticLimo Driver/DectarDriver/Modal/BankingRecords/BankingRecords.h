//
//  BankingRecords.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/11/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankingRecords : NSObject
@property(strong,nonatomic)NSString * accUserName;
@property(strong,nonatomic)NSString * accUserAddress;
@property(strong,nonatomic)NSString * accNumber;
@property(strong,nonatomic)NSString * accBankName;
@property(strong,nonatomic)NSString * accBranchName;
@property(strong,nonatomic)NSString * accBranchAddress;
@property(strong,nonatomic)NSString * accIfscCode;
@property(strong,nonatomic)NSString * accRoutingNumber;
@end
