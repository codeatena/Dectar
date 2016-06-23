//
//  InviteEarnVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/27/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "InviteEarnVC.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "Themes.h"
#import "UrlHandler.h"
#import "ReferralRecord.h"
#import "REFrostedViewController.h"
#import "LanguageHandler.h"



@interface InviteEarnVC ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UITextFieldDelegate>
{
   
    NSString * Symbol;
}
@property (strong, nonatomic) IBOutlet UILabel *Amount;
@property (strong, nonatomic) IBOutlet UITextField *referralCode;
@property (strong, nonatomic) IBOutlet UILabel *youramount;
@property (strong, nonatomic) IBOutlet UIButton *MenuBtn;
@property (strong, nonatomic) IBOutlet UILabel *heading;
@property (strong, nonatomic) IBOutlet UILabel *star;
@property (strong, nonatomic) IBOutlet UILabel *letworld;
@property (strong, nonatomic) IBOutlet UILabel *hint_code;

@end

@implementation InviteEarnVC
@synthesize TableBG,scrollView,Amount,referralCode,youramount,MenuBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self referreal];
    [Themes statusbarColor:self.view];
    
    
    scrollView.contentSize = CGSizeMake(320, 400);
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    referralCode.inputView = dummyView;
    referralCode.delegate=self;
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_heading setText:JJLocalizedString(@"Invite_Friends", nil)];
    [_star setText:JJLocalizedString(@"Start_Inviting_friends", nil)];
    [_letworld setText:JJLocalizedString(@"Let_the_world_know", nil)];
    [_hint_code setText:JJLocalizedString(@"Share_your_referral_code", nil)];

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

/*- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:)) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}*/
- (IBAction)ShareBtn:(id)sender {
    NSString * ihave=JJLocalizedString(@"I_have_an", nil);
    NSString * code=JJLocalizedString(@"Coupon_Code_worth", nil);
    NSString * mycode=JJLocalizedString(@"with_My_code", nil);

    UIButton *btnAuthOptions=(UIButton*)sender;
    if (btnAuthOptions.tag==1) {
        
       
        
        NSString * msg = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",ihave,[Themes getAppName],code,Amount.text,mycode,referralCode.text];
        NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",msg];
        NSURL * whatsappURL = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
            [[UIApplication sharedApplication] openURL: whatsappURL];
        } else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"WhatsApp_not_installed", nil)  message:JJLocalizedString(@"Your_device_has_no_WhatsApp", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else if (btnAuthOptions.tag==2)
    {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = [NSString stringWithFormat:@"I have an %@ Coupon Code worth %@ with My code %@",[Themes getAppName],Amount.text,referralCode.text];
            controller.messageComposeDelegate=self;
            [self presentViewController:controller animated:YES completion:nil];
        }
        

    }
    else if (btnAuthOptions.tag==3) {
        
        /*NSURL *fbURL = [NSURL URLWithString:@"fb-messenger://user-thread/USER_ID"];
        if ([[UIApplication sharedApplication] canOpenURL: fbURL]) {
            [[UIApplication sharedApplication] openURL: fbURL];
        }*/
        
        NSString * msg = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",ihave,[Themes getAppName],code,Amount.text,mycode,referralCode.text];
        NSString * urlFB = [NSString stringWithFormat:@"fb-messenger://compose%@",msg];
        NSURL * fbURL = [NSURL URLWithString:[urlFB stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if ([[UIApplication sharedApplication] canOpenURL: fbURL]) {
            [[UIApplication sharedApplication] openURL: fbURL];
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"Facebook_Messenger", nil)  message:JJLocalizedString(@"Your_device_has_no_Facebook Messenger installed.", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }

    }
    else if (btnAuthOptions.tag==4) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
            [composeViewController setToRecipients:@[@""]];
            [composeViewController setMailComposeDelegate:self];
            [composeViewController setSubject:@""];
            [composeViewController setMessageBody:[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",ihave,[Themes getAppName],code,Amount.text,mycode,referralCode.text] isHTML:NO];
            [composeViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:composeViewController animated:YES completion:nil];
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mail" message:JJLocalizedString(@"please_config_your_mail", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else if (btnAuthOptions.tag==5) {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",ihave,[Themes getAppName],code,Amount.text,mycode,referralCode.text]];
            [tweetSheet addImage:[UIImage imageNamed:@"InviteCar"]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else {
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Ooops Twitter!" message:JJLocalizedString(@"Kindly_add_your", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];

        }
    }
    else if (btnAuthOptions.tag==6) {
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",ihave,[Themes getAppName],code,Amount.text,mycode,referralCode.text]];
            [controller addImage:[UIImage imageNamed:@"InviteCar"]];
            [self presentViewController:controller animated:YES completion:Nil];
        }
        else
        {
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Ooops Facebook!" message:JJLocalizedString(@"Kindly_add_your", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
            

        }
    }


}
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
       [referralCode resignFirstResponder];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)referreal
{
    NSDictionary*paramets=@{@"user_id":[Themes getUserID]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web referCode:paramets success:^(NSMutableDictionary *responseDictionary)
    
    {
        [Themes StopView:self.view];
        
        if ([responseDictionary count]>0)
        {
        responseDictionary=[Themes writableValue:responseDictionary];

        NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
        NSString * alert=[responseDictionary valueForKey:@"response"];
        [Themes StopView:self.view];

        if ([comfiramtion isEqualToString:@"1"])
        {
            ReferralRecord*objrecd=[[ReferralRecord alloc]init];
            objrecd.friendsamount=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"]valueForKey:@"friends_earn_amount"]];
            objrecd.referral_code=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"]valueForKey:@"referral_code"]];
            objrecd.your_earn=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"]valueForKey:@"your_earn"]];
            objrecd.your_earn_amount=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"]valueForKey:@"your_earn_amount"]];
            objrecd.Currecny=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"]valueForKey:@"currency"]];
            Symbol=[Themes findCurrencySymbolByCode:objrecd.Currecny];
            
            NSString * friendsrides=JJLocalizedString(@"Friends_Rides_you_earn", nil);
            NSString * friendsjoins=JJLocalizedString(@"Friends_joins", nil);

            youramount.text= [NSString stringWithFormat:@"%@ %@ %@",friendsrides,Symbol, objrecd.your_earn_amount];
            referralCode.text=objrecd.referral_code;
            Amount.text=[NSString stringWithFormat:@"%@ %@ %@",friendsjoins,Symbol,objrecd.friendsamount];
        }
        
        else
        {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
        }
            
        }
    } failure:^(NSError *error) {
       
[Themes StopView:self.view];
    }];
    
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
            else
                NSLog(@"Message failed");
    }
@end
