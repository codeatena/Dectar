//
//  SignUpWebViewController.m
//  DectarDriver
//
//  Created by Aravind Natarajan on 08/01/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import "SignUpWebViewController.h"

@interface SignUpWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SignUpWebViewController
@synthesize webView,headerLbl;

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (appdelegate.isInternetAvailableFor) {
        [self showActivityIndicator:YES];
        headerLbl.text=JJLocalizedString(@"Register", nil);
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:RegUrl]]];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self stopActivityIndicator];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self stopActivityIndicator];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
   
        if ([request.URL.absoluteString rangeOfString:CompletionUrl].location != NSNotFound){
            [self.navigationController popViewControllerAnimated:YES];
            return NO;
        }
    
    return YES;
}
- (IBAction)didClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
