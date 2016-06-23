//
//  ChangeLanguageViewController.h
//  DectarDriver
//
//  Created by Aravind Natarajan on 18/03/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderLabelHandler.h"
#import "RootBaseViewController.h"

@interface ChangeLanguageViewController : RootBaseViewController<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet HeaderLabelHandler *headerLbl;
@property (weak, nonatomic) IBOutlet UIButton *languageBtn;
- (IBAction)didClickMenuBtn:(id)sender;

- (IBAction)didClickLanguageBtn:(id)sender;
@end
