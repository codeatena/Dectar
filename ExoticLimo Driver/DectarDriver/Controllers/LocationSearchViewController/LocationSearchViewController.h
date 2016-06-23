//
//  LocationSearchViewController.h
//  DectarDriver
//
//  Created by Casperon Technologies on 9/23/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "RootBaseViewController.h"
#import "UrlHandler.h"
@protocol locationGoogleDelegate<NSObject>
@optional
-(void)sendLocation:(NSString *)locStr;
@end
@interface LocationSearchViewController : RootBaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property(strong,nonatomic)id<locationGoogleDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISearchBar *locSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *locTableView;
@property (weak, nonatomic) IBOutlet HeaderLabelHandler *headerlbl;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property(strong,nonatomic)NSMutableArray * filteredContentList;
@property(strong,nonatomic)NSString * locationStr;
- (IBAction)didClickBackBtn:(id)sender;
- (IBAction)didClickDoneBtn:(id)sender;

@end
