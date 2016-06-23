//
//  DEMOMenuViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "StarterViewController.h"

#import "UIViewController+REFrostedViewController.h"
#import "DEMONavigationController.h"
#import "Theme.h"
#import "MenuTableViewCell.h"
#import "TripListViewController.h"
#import "ChangePasswordCabViewController.h"
#import "PaymentSummaryListViewController.h"
#import "BankingInfoViewController.h"
#import "ChangeLanguageViewController.h"

@interface DEMOMenuViewController (){
    UIButton * btn;
}

@end

@implementation DEMOMenuViewController
@synthesize titleArray;
@synthesize custIndicatorView,ImgArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    titleArray=[[NSMutableArray alloc]initWithObjects:@"Home",@"Trip_Summary",@"Bank_Account",@"Payment_Statements",@"Change_Password",@"Feedback",nil];
    
     ImgArray=[[NSMutableArray alloc]initWithObjects:@"IcHome",@"IcTrip",@"IcBank",@"IcPayment",@"IcChangePass",@"icFeedback", nil];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1.0f];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 174.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, 100, 100)];
       // imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        NSString * imgstr=[myDictionary objectForKey:@"driver_image"];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgstr] placeholderImage:[UIImage imageNamed:@"PlaceHolderImg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
       
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(130, 68, 0, 24)];
        
        label.text = [Theme checkNullValue:[myDictionary objectForKey:@"driver_name"]];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = SetThemeColor;
        [label sizeToFit];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(130, 97, 0, 24)];
        
        label1.text = [Theme checkNullValue:[myDictionary objectForKey:@"vehicle_model"]];
        label1.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor darkGrayColor];
        [label1 sizeToFit];
        //label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 174, self.tableView.frame.size.width, .5)];
        line.backgroundColor = self.tableView.separatorColor;
        [view addSubview:imageView];
        [view addSubview:label];
        [view addSubview:label1];
        [view addSubview:line];
        view;
    });
   
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Friends Online";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DEMONavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"StarterNavVCSID"];
    
    if ( indexPath.row == 0) {
        StarterViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StarterVCSID"];
        navigationController.viewControllers = @[homeViewController];
    } else if(indexPath.row==1) {
        TripListViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TripListVCSID"];
        navigationController.viewControllers = @[secondViewController];
    }
    else if(indexPath.row==2) {
        BankingInfoViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BankingInfoVCSID"];
        navigationController.viewControllers = @[secondViewController];
    }
    else if(indexPath.row==3) {
        PaymentSummaryListViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentListVCSID"];
        navigationController.viewControllers = @[secondViewController];
    }
    else if(indexPath.row==4) {
        ChangePasswordCabViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordVCSID"];
        navigationController.viewControllers = @[secondViewController];
    }
    else if(indexPath.row==5) {
        [self performSelector:@selector(openEmailfeedback) withObject:self afterDelay:0.3];
    }else if (indexPath.row==6) {
        ChangeLanguageViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeLanguageVCSID"];
        navigationController.viewControllers = @[secondViewController];
    }
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}
-(void)openEmailfeedback{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"feedBackEmail"
     object:self userInfo:nil];
}

-(void)Logout{
    
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web LogoutDriver:[self setParametersForLogout]
              success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         //if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
         AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
         [Theme ClearUserDetails];
         [testAppDelegate logoutXmpp];
         LoginViewController * objLoginVc=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialVCSID"];
         UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginVc];
         testAppDelegate.window.rootViewController = navigationController;
         self.view.userInteractionEnabled=YES;
         //         }else{
         //
         //             [self.view makeToast:kErrorMessage];
         //         }
     }
              failure:^(NSError *error)
     {
         
         [self stopActivityIndicator];
         AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
         [testAppDelegate logoutXmpp];
         [Theme ClearUserDetails];
         LoginViewController * objLoginVc=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialVCSID"];
         UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginVc];
         testAppDelegate.window.rootViewController = navigationController;
         self.view.userInteractionEnabled=YES;
         [self.view makeToast:kErrorMessage];
         
     }];
}
-(void)showActivityIndicator:(BOOL)isShow{
    if(isShow==YES){
        if(custIndicatorView==nil){
            custIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStylePulse color:SetThemeColor];
            
        }
        custIndicatorView.center =self.view.center;
        [custIndicatorView startAnimating];
        [self.view addSubview:custIndicatorView];
        [self.view bringSubviewToFront:custIndicatorView];
    }
}
-(void)stopActivityIndicator{
    [custIndicatorView stopAnimating];
    custIndicatorView=nil;
}
-(NSDictionary *)setParametersForLogout{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"device":@"IOS"
                                  };
    return dictForuser;
}

#pragma mark -
#pragma mark UITableView Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==[titleArray count]){
        return 120;
    }
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [titleArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *lastCellIdentifier = @"LastCellIdentifier";
     static NSString *NormalCellIdentifier = @"MenuListIdentifier";
    
    if(indexPath.row==([titleArray count])){ //This is last cell so create normal cell
        UITableViewCell *lastcell = [tableView dequeueReusableCellWithIdentifier:lastCellIdentifier];
        if(!lastcell){
            lastcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lastCellIdentifier];
            CGRect frame = CGRectMake((self.tableView.frame.size.width/2)-(200/2),40,200,50);
            UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [aButton addTarget:self action:@selector(btnAddRowTapped:) forControlEvents:UIControlEventTouchUpInside];
            aButton.frame = frame;
            btn=aButton;
            aButton.layer.cornerRadius=5;
            aButton.layer.masksToBounds=YES;
            [aButton setTitle:JJLocalizedString(@"LOGOUT", nil) forState:UIControlStateNormal];
            aButton=[Theme setBoldFontForButton:aButton];
            aButton.backgroundColor=SetThemeColor;
            aButton.titleLabel.textColor=[UIColor whiteColor];
            [lastcell addSubview:aButton];
            lastcell.separatorInset = UIEdgeInsetsMake(0.f, lastcell.bounds.size.width, 0.f, 0.f);
        }else{
            if(btn){
                [btn setTitle:JJLocalizedString(@"LOGOUT", nil) forState:UIControlStateNormal];
            }
        }
        return lastcell;
    }else{
        MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
        if (cell == nil) {
            cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:NormalCellIdentifier];
        }
        
        cell.titleLbl.text=JJLocalizedString([titleArray objectAtIndex:indexPath.row], nil);
        cell.IconImgView.image=[UIImage imageNamed:[ImgArray objectAtIndex:indexPath.row]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(IBAction)btnAddRowTapped:(id)sender{
     [self Logout];
}
@end
