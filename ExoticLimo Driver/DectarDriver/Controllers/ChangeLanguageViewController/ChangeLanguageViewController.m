//
//  ChangeLanguageViewController.m
//  DectarDriver
//
//  Created by Aravind Natarajan on 18/03/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import "ChangeLanguageViewController.h"

@interface ChangeLanguageViewController ()


@end

@implementation ChangeLanguageViewController
@synthesize headerLbl,languageBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFont];
    languageBtn.layer.borderWidth=1;
    [languageBtn setTitleColor:SetThemeColor forState:UIControlStateNormal];
    languageBtn.layer.borderColor=SetThemeColor.CGColor;
    languageBtn.layer.cornerRadius=4;
    languageBtn.layer.masksToBounds=YES;
    // Do any additional setup after loading the view.
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [headerLbl setText:JJLocalizedString(@"Change_Language", nil)];
}
-(void)setFont{
    if([[Theme getCurrentLanguage]isEqualToString:@"es"]){
               [languageBtn setTitle:@"Español" forState:UIControlStateNormal];
    }else{
        [languageBtn setTitle:@"English" forState:UIControlStateNormal];
    }
    [headerLbl setText:JJLocalizedString(@"Change_Language", nil)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)didClickLanguageBtn:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:JJLocalizedString(@"Select_Lang", nil) delegate:self cancelButtonTitle:JJLocalizedString(@"CANCEL", nil) destructiveButtonTitle:nil otherButtonTitles:
                                  @"English",
                                  @"Español",
                                  nil];
    
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (actionSheet.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0://English
                    [self changeLanguage:0];
                    break;
                case 1://spanish
                    [self changeLanguage:1];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(void)changeLanguage:(NSInteger )buttonIndex{
    NSString * str;
    if(buttonIndex==0){
        str=@"en";
        [Theme saveLanguage:@"en"];
        [languageBtn setTitle:@"English" forState:UIControlStateNormal];
    }else if (buttonIndex==1){
        str=@"es";
        [Theme saveLanguage:@"es"];
        [languageBtn setTitle:@"Español" forState:UIControlStateNormal];
    }
    [Theme saveLanguage:str];
    [Theme SetLanguageToApp];
}

@end
