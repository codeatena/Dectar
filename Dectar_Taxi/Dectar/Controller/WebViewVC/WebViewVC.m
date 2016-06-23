//
//  WebViewVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 9/15/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "WebViewVC.h"
#import "Themes.h"
#import "Constant.h"
#import "RatingVC.h"
#import "LanguageHandler.h"
@interface WebViewVC ()

@end

@implementation WebViewVC
@synthesize FromComing,FromWhere,parameters,TransWenView,Ride_ID,StripeProcess;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (FromComing==YES)
    {
        NSString *Urlstr=[NSString stringWithFormat:@"%@mobile/wallet-recharge/payform?user_id=%@&total_amount=%@",AppbaseUrl,[Themes getUserID],parameters];
        NSURL *nsurl=[NSURL URLWithString:Urlstr];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [TransWenView loadRequest:nsrequest];
    }
    else if (StripeProcess==YES)
        
    {
        NSString *Urlstr=[NSString stringWithFormat:@"%@mobile/wallet-recharge/stripe-process?user_id=%@&total_amount=%@",AppbaseUrl,[Themes getUserID],parameters];
        NSURL *nsurl=[NSURL URLWithString:Urlstr];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [TransWenView loadRequest:nsrequest];
    }
    else if (FromComing==NO)
    {
        NSString *Urlstr=[NSString stringWithFormat:@"%@mobile/proceed-payment?mobileId=%@",AppbaseUrl,parameters];
        NSURL *nsurl=[NSURL URLWithString:Urlstr];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [TransWenView loadRequest:nsrequest];
        TransWenView.scalesPageToFit=YES;
    }
    else if (FromWhere==YES)
    {
        NSString *Urlstr=[NSString stringWithFormat:@"%@mobile/proceed-payment?mobileId=%@",AppbaseUrl,parameters];
        NSURL *nsurl=[NSURL URLWithString:Urlstr];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [TransWenView loadRequest:nsrequest];
    }
    else if (FromWhere==NO)
    {
        NSString *Urlstr=[NSString stringWithFormat:@"%@mobile/proceed-payment?mobileId=%@",AppbaseUrl,parameters];
        NSURL *nsurl=[NSURL URLWithString:Urlstr];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [TransWenView loadRequest:nsrequest];

    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_heading setText:JJLocalizedString(@"Transaction_View", nil)];
}
- (IBAction)Dissmis:(id)sender {
  
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:JJLocalizedString(@"Warning", nil)
                              
                              message:JJLocalizedString(@"If_you_Close_the", nil)
                              delegate:self
                              cancelButtonTitle:JJLocalizedString(@"CANCEL", nil)
                              otherButtonTitles:@"OK", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self.view removeFromSuperview];
 		[TransWenView stopLoading];
        
    }
}
#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting the load, show the activity indicator in the status bar
    //[Themes StartView:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
   // [Themes StopView:self.view];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSURL *currentURL = [[webView request] URL];
    NSLog(@"%@",[currentURL description]);
    
    if (FromComing==YES)
    {
        if ([[currentURL description] containsString:@"/wallet-recharge/failed"]) {
            [self.navigationController popViewControllerAnimated:YES];
            
           /* UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some Network problem try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];*/
        }
        else  if ([[currentURL description] containsString:@"/wallet-recharge/pay-completed"])
        {
            [self.navigationController popViewControllerAnimated:YES];
            
           /* UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success!" message:@"Amount added to you Wallet SccessFully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];*/
            // [self MyBalancce];
            
        }
        
        else if ([[currentURL description] containsString:@"/wallet-recharge/failed"]) {
            [self.navigationController popViewControllerAnimated:YES];
            
            /*UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some Network problem try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];*/
            
        }
    }
    else if (FromComing==NO)
    {
        if ([[currentURL description] containsString:@"pay-failed"]) {
            /*UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some Network problem try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];*/
            [self.navigationController popViewControllerAnimated:YES];

        }
        else  if ([[currentURL description] containsString:@"pay-completed"])
        {
            RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
            [objLoginVC setRideID_Rating:Ride_ID];
            [self presentViewController:objLoginVC animated:YES completion:nil];
            
        }
        
        else if ([[currentURL description] containsString:@"failed"]) {
           /* UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some Network problem try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];*/
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if  (FromWhere ==NO || FromWhere ==YES)
    {
        if ([[currentURL description] containsString:@"pay-failed"]) {
           /* UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some Network problem try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];*/
            [self.navigationController popViewControllerAnimated:YES];

        }
        else  if ([[currentURL description] containsString:@"pay-completed"])
        {
            RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
            [objLoginVC setRideID_Rating:Ride_ID];
            [self presentViewController:objLoginVC animated:YES completion:nil];
            
            
        } else if ([[currentURL description] containsString:@"failed"]) {
            /*UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some Network problem try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];*/
            
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
    
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"%@",[request description]);

    if (FromComing==YES)
    {
        if ([[request description] containsString:@"/wallet-recharge/failed"]) {
            [self.navigationController popViewControllerAnimated:YES];
            
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
            
        }
        else  if ([[request description] containsString:@"/wallet-recharge/pay-completed"])
        {
            [self.navigationController popViewControllerAnimated:YES];
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:JJLocalizedString(@"Amount_added", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Walletrecharged"
                                                                object:nil
                                                              userInfo:nil];
            //[self MyBalancce];
            
            
        }
        else  if ([[request description] containsString:@"/wallet-recharge/pay-cancel"]) {
            [self.navigationController popViewControllerAnimated:YES];
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
            
        }
        

    }
    else if (FromComing==NO)
    {
        if ([[request description] containsString:@"pay-failed"]) {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
            [self.navigationController popViewControllerAnimated:YES];

        }
        else  if ([[request description] containsString:@"pay-completed"])
        {
            RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
            [objLoginVC setRideID_Rating:Ride_ID];
            [self presentViewController:objLoginVC animated:YES completion:nil];
            
        }
        else  if ([[request description] containsString:@"Cancel"]) {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(@"Your_Payment_cancelled", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
            [self.navigationController popViewControllerAnimated:YES];

        }
        

    }
    else if  (FromWhere ==NO || FromWhere ==YES)
    {
        if ([[request description] containsString:@"pay-failed"]) {
            [self.navigationController popViewControllerAnimated:YES];

        }
        else  if ([[request description] containsString:@"pay-completed"])
        {
           
            RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
            [objLoginVC setRideID_Rating:Ride_ID];
            [self presentViewController:objLoginVC animated:YES completion:nil];
            
        }
        else  if ([[request description] containsString:@"Cancel"]) {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(@"Your_Payment_cancelled", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
    }
    
        return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [Themes StopView:self.view];
    // report the error inside the webview
    /*UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Oops\xF0\x9F\x9A\xAB" message:@"Some Network problem try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [Alert show];*/
    [self.navigationController popViewControllerAnimated:YES];

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
