//
//  WebViewVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 9/15/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseVC.h"


@interface WebViewVC : RootBaseVC
@property (strong, nonatomic) IBOutlet UIButton *Closebtn;
@property (assign, nonatomic) BOOL FromComing;
@property (assign, nonatomic) BOOL FromWhere;
@property (strong, nonatomic) NSString * parameters;
@property (strong, nonatomic) NSString * Ride_ID;
@property (strong, nonatomic) IBOutlet UIWebView *TransWenView;
@property (assign, nonatomic) BOOL StripeProcess;
@property (strong, nonatomic) IBOutlet UILabel *heading;

@end
