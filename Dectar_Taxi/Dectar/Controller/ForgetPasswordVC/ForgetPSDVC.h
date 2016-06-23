//
//  ForgetPSDVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 10/12/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseVC.h"


@interface ForgetPSDVC : RootBaseVC
@property (strong, nonatomic) IBOutlet UITextField *Email_fld;
@property (strong, nonatomic) IBOutlet UILabel *timer_lbl;
@property (strong, nonatomic) IBOutlet UIButton *resend_Btn;
@property (strong, nonatomic) IBOutlet UIButton *email_btn;
@property (strong, nonatomic) IBOutlet UILabel *heading;

@end
