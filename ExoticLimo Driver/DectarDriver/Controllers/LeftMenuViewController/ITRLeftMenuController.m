//
//  LeftMenuController.m
//  ITRAirSideMenu
//
//  Created by kirthi on 12/08/15.
//  Copyright (c) 2015 kirthi. All rights reserved.
//

#import "ITRLeftMenuController.h"
#import "StarterViewController.h"
#import "TripListViewController.h"
#import "AppDelegate.h"
#import "ITRAirSideMenu.h"

@interface ITRLeftMenuController (){
    TripListViewController * objTripListVc;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ITRLeftMenuController
@synthesize custIndicatorView,tapBtn;

- (IBAction)didSwipeRight:(id)sender {
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu hideMenuViewController];
}

+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ITRLeftMenuController class])];
}

#pragma view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(IS_IPHONE_4_OR_LESS){
        _tableView.frame=CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y+100, _tableView.frame.size.width, _tableView.frame.size.height);
    }
    tapBtn.layer.cornerRadius=tapBtn.frame.size.width/2;
    tapBtn.layer.borderWidth=2.0;
    tapBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    tapBtn.layer.masksToBounds=YES;
    
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    //update content view controller with setContentViewController
    switch (indexPath.row) {
        case 0:
            [itrSideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[StarterViewController controller]] animated:YES];
            [itrSideMenu hideMenuViewController];
            break;
        case 1:
            [itrSideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[TripListViewController controller]] animated:YES];
            [itrSideMenu hideMenuViewController];
            break;
        case 2:
            [itrSideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[BankingInfoViewController controller]] animated:YES];
            [itrSideMenu hideMenuViewController];
            break;
        case 3:
            [itrSideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[PaymentSummaryListViewController controller]] animated:YES];
            [itrSideMenu hideMenuViewController];
            break;
            case 4:
            [itrSideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[ChangePasswordCabViewController controller]] animated:YES];
            [itrSideMenu hideMenuViewController];
            break;
        case 5:
             [self Logout];
            break;
        default:
            break;
    }
}

-(void)Logout{
    self.view.userInteractionEnabled=NO;
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web LogoutDriver:[self setParametersForLogout]
                success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         //if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
              AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
             [Theme ClearUserDetails];
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
         self.view.userInteractionEnabled=YES;
         [self stopActivityIndicator];
         AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
         [Theme ClearUserDetails];
         LoginViewController * objLoginVc=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialVCSID"];
         UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginVc];
         testAppDelegate.window.rootViewController = navigationController;
         [self.view makeToast:kErrorMessage];
         
     }];
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
#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIImageView *imgView;
     UILabel *txtLbl;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
      
    }
    cell.textLabel.text=@"";
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 25, 25)];
    [cell.contentView addSubview:imgView];
   
    txtLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 12, 250, 30)];
    [cell.contentView addSubview:txtLbl];
    
     txtLbl.font = [UIFont boldSystemFontOfSize:16];
    NSArray *titles = @[@"Home", @"Trip Summary",@"Bank Account",@"Payment Statements",@"Change Password",@"Logout"];
     NSArray *titlesImg = @[@"IcHome", @"IcTrip",@"IcBank",@"IcPayment",@"IcChangePass",@"IcLogout"];
   
    imgView.image=[UIImage imageNamed:titlesImg[indexPath.row]];
    txtLbl.text = titles[indexPath.row];
   txtLbl.textColor = [UIColor whiteColor];
    return cell;
}


@end
