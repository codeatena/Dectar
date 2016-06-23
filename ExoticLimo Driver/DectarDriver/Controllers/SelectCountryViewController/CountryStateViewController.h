//
//  CountryStateViewController.h
//  eCommerce
//
//  Created by Casperon Technologies on 4/17/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UrlHandler.h"
#import "RootBaseViewController.h"

#import "Theme.h"
#import "UIView+Toast.h"
#import "DriverLoRecords.h"
@protocol countryStateDelegate<NSObject>
-(void)GetCountryAndStateInfo:(DriverLoRecords *)objRecs;
@end
@interface CountryStateViewController : RootBaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate>
@property(strong,nonatomic)id<countryStateDelegate> delegate;


@property (weak, nonatomic) IBOutlet UILabel *headerTitleLbl;
@property (weak, nonatomic) IBOutlet UITableView *locationTblView;

@property(strong,nonatomic)NSMutableArray * countryStateArray;
@property(assign,nonatomic)BOOL iscountry;

- (IBAction)didClickBackBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *countrySearchBar;
@property(strong,nonatomic)NSMutableArray * searchArray;
@property(strong,nonatomic)NSMutableArray * dummySearchArray;

@end
