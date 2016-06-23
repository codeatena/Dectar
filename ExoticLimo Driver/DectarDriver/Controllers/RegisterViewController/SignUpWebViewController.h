//
//  SignUpWebViewController.h
//  DectarDriver
//
//  Created by Aravind Natarajan on 08/01/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseViewController.h"
#import "AppDelegate.h"


@interface SignUpWebViewController : RootBaseViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet HeaderLabelHandler *headerLbl;

@end
