//
//  RootBaseViewController.h
//  VoiceEM
//
//  Created by Casperon Technologies on 6/25/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "RTSpinKitView.h"
#import "UIView+Toast.h"
#import "Constant.h"
#import <AVFoundation/AVFoundation.h>
#import "SMBInternetConnectionIndicator.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "REFrostedViewController.h"
#import "UIImageView+WebCache.h"
#import "HeaderLabelHandler.h"
#import "HeaderViewColorHandler.h"
#import "ButtonColorHandler.h"
#import "LabelThemeColor.h"
#import "CNPPopupController.h"

@interface RootBaseViewController : UIViewController<MFMailComposeViewControllerDelegate,CNPPopupControllerDelegate>{
    Reachability *  reachability;
    AVAudioPlayer * audioPlayer;
}
@property (strong,nonatomic) SMBInternetConnectionIndicator *internetConnectionIndicator;
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
-(void)showActivityIndicator:(BOOL)isShow;
-(void)stopActivityIndicator;
-(void)applicationLanguageChangeNotification:(NSNotification*)notification;
@property (nonatomic, strong) CNPPopupController *popupController;
@end
