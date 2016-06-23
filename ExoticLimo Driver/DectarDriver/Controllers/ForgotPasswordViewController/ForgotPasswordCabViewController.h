//
//  ForgotPasswordCabViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 12/21/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseViewController.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "Theme.h"
#import "WBErrorNoticeView.h"

@interface ForgotPasswordCabViewController : RootBaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTxtField;
@property (weak, nonatomic) IBOutlet UIScrollView *forgotScrollView;
@property (weak, nonatomic) IBOutlet HeaderLabelHandler *headerlbl;
@property (weak, nonatomic) IBOutlet UILabel *forgetheader;
@property (weak, nonatomic) IBOutlet UILabel *Hint_emaillbl;
@property (weak, nonatomic) IBOutlet ButtonColorHandler *RequestBtn;

@end
