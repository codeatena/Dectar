//
//  DEMOMenuViewController.h
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "RTSpinKitView.h"
#import "UIImageView+WebCache.h"


@interface DEMOMenuViewController : UITableViewController
@property (strong,nonatomic)NSMutableArray * titleArray;
@property (strong,nonatomic)NSMutableArray * ImgArray;
@property(strong,nonatomic)RTSpinKitView * custIndicatorView;
@end
