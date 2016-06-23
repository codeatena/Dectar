//
//  DEMOMenuViewController1.m
//  Dectar
//
//  Created by AnCheng on 6/16/16.
//  Copyright © 2016 CasperonTechnologies. All rights reserved.
//

#import "DEMOMenuViewController1.h"
#import "BookARideVC.h"
#import "MyRideVC.h"
#import "Constant.h"
#import "LoginMainVC.h"
#import "Themes.h"
#import "FavorVC.h"
#import "AddressRecord.h"
#import "MyprofileVC.h"
#import "AppDelegate.h"
#import "InviteEarnVC.h"
#import "MoneyVC.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "RateCardVC.h"
#import "AboutVc.h"
#import "FareVC.h"
#import "FareRecord.h"
#import "RatingVC.h"
#import "AdvertsRecord.h"
#import "AdvertsVC.h"
#import "DEMONavigationController.h"
#import "EmergencyVC.h"
#import "MenuTableViewCell.h"
#import "LanguageHandler.h"

@interface DEMOMenuViewController1 ()

@end

@implementation DEMOMenuViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_btnMenu createTitle:@"MENU" withIcon:[UIImage imageNamed:@"Menu"]
                     font:[UIFont fontWithName:@"RobotoCondensed-Bold" size:17.0f]
               iconHeight:24
              iconOffsetY:-6];
    _btnMenu.bgColor = [UIColor clearColor];
    _btnMenu.borderWidth = 0.0f;
    _btnMenu.iconColor = [UIColor grayColor];
    _btnMenu.titleColor = [UIColor grayColor];


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _nameLbl.text = [Themes checkNullValue:[Themes getUserName]];
    _balanceLbl.text = [NSString stringWithFormat:@"Current Balance $%@" ,[Themes checkNullValue:[Themes GetWallet]]]; // Current Balance $3.90
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 9;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    DEMONavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"StarterNavVCSID"];
    switch (indexPath.row) {
        case 0:
        {
            BookARideVC *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"BookARideVCID"];
            navigationController.viewControllers = @[homeViewController];
        }
            break;
        case 1:
        {
            BookARideVC *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewFleetVC"];
            navigationController.viewControllers = @[homeViewController];
        }
            break;
        case 2:
        {
            BookARideVC *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"BookLaterVC"];
            navigationController.viewControllers = @[homeViewController];
        }
            break;
        case 3:
        {
            MyRideVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyRideVCID"];
            navigationController.viewControllers = @[secondViewController];
        }
            break;
        case 4:
        {
            MyprofileVC *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileVCID"];
            navigationController.viewControllers = @[homeViewController];
        }
            break;
        case 5:
        {
            MoneyVC *FourthViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyVCID"];
            navigationController.viewControllers = @[FourthViewController];
        }
            break;
        case 6:
        {
            EmergencyVC *SixViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmergencyVCID"];
            navigationController.viewControllers = @[SixViewController];
        }
            break;
        case 7:
        {
            InviteEarnVC *FifthViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteVCID"];
            navigationController.viewControllers = @[FifthViewController];
        }
            break;
        case 8:
        {
            [self performSelector:@selector(openEmailfeedback) withObject:self afterDelay:0.3];

        }
            break;

        default:
            break;
    }
    
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)openEmailfeedback{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"feedBackEmail"
     object:self userInfo:nil];
    
}

- (IBAction)onMenu:(id)sender
{
    [self.frostedViewController hideMenuViewController];
}

@end
