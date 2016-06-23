//
//  InitialViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 8/21/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"
#import "DectarCustomColor.h"
#import "RootBaseViewController.h"
#import "SignUpWebViewController.h"
#import "RegisterViewController.h"



@interface InitialViewController : RootBaseViewController{
   
}
+ (instancetype) controller;

@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
- (IBAction)didClickRegisterBtn:(id)sender;
- (IBAction)didClickSignInBtn:(id)sender;


@end
