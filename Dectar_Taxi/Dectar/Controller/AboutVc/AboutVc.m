//
//  AboutVc.m
//  Dectar
//
//  Created by Aravind Natarajan on 9/14/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "AboutVc.h"
#import "Constant.h"
#import "TTTAttributedLabel.h"
#import "REFrostedViewController.h"
#import "Themes.h"

@interface AboutVc ()
{
    NSString *BaseURl;
}

@end

@implementation AboutVc
@synthesize MenuBtn,Describ_label,More_info_URL;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [_Version_Label setText:[NSString stringWithFormat:@"VERSION : %@",version]];
    
    [Themes statusbarColor:self.view];
    
    [Describ_label sizeToFit];
    
    BaseURl =[NSString stringWithFormat:@"%@",AppbaseUrl];
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:BaseURl];
    [str addAttribute: NSLinkAttributeName value: AppbaseUrl range: NSMakeRange(0, str.length)];
    More_info_URL.attributedText = str;
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.More_info_URL addGestureRecognizer:singleFingerTap];
    [More_info_URL sizeToFit];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:BaseURl]];
    
    //Do stuff here...
}
- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
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

@end
