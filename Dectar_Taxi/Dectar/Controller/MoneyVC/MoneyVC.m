//
//  MoneyVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/28/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "MoneyVC.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "TranscationVC.h"
#import "Constant.h"
#import "Blurview.h"
#import "WebViewVC.h"
#import "PayPalVC.h"
#import "CardIO.h"
#import "REFrostedViewController.h"
#import "LanguageHandler.h"

@interface MoneyVC ()<UIWebViewDelegate,UITextFieldDelegate,CardIOPaymentViewControllerDelegate,UIAlertViewDelegate>
{
    NSString * minamount;
    NSString * maxamount;
    NSString * between;
    Blurview * bgView;
    NSString * currencySymbol;
    NSString * Auto_recharge;
    PayPalVC * PaypalVC;
    UIAlertView *alert2;
}



@property (strong, nonatomic) IBOutlet UIView *TitleView;

@end

@implementation MoneyVC
@synthesize MuenuBtn,Current_labl,TitleView,AddMoney_Btn,MiniAmount_lbl,MaxAmount_lbl,BetweenAmount,Amount_Field,paymentView,Paypal,CerditCard;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * Appname=[Themes getAppName];
    
    [AddMoney_Btn setTitle:[NSString stringWithFormat:@"ADD %@ MONEY",[Appname uppercaseString]] forState:UIControlStateNormal];
    
    self.Scrollview.contentSize=CGSizeMake(self.Scrollview.frame.size.width, CerditCard.frame.origin.y+CerditCard.frame.size.height+50);
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doSingleTap)] ;
    singleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:singleTap];
    
    [bgView setHidden:YES];
    [Themes statusbarColor:self.view];

    TitleView.layer.cornerRadius = 25.0f;
    TitleView.layer.masksToBounds = YES;
    
    AddMoney_Btn.layer.cornerRadius = 5;
    AddMoney_Btn.layer.shadowColor = [UIColor blackColor].CGColor;
    AddMoney_Btn.layer.shadowOpacity = 0.5;
    AddMoney_Btn.layer.shadowRadius = 2;
    AddMoney_Btn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);

    //[AddMoney_Btn setHidden:YES];
    Paypal.layer.cornerRadius = 5;
    Paypal.layer.shadowColor = [UIColor blackColor].CGColor;
    Paypal.layer.shadowOpacity = 0.5;
    Paypal.layer.shadowRadius = 2;
    Paypal.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    [Paypal setHidden:YES];
    
    _Sucess.layer.cornerRadius = 5;
    _Sucess.layer.shadowColor = [UIColor blackColor].CGColor;
    _Sucess.layer.shadowOpacity = 0.5;
    _Sucess.layer.shadowRadius = 2;
    _Sucess.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    [_Sucess setHidden:YES];

    CerditCard.layer.cornerRadius = 5;
    CerditCard.layer.shadowColor = [UIColor blackColor].CGColor;
    CerditCard.layer.shadowOpacity = 0.5;
    CerditCard.layer.shadowRadius = 2;
    CerditCard.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    [CerditCard setHidden:YES];

    MiniAmount_lbl.layer.cornerRadius = 5;
    MiniAmount_lbl.layer.shadowColor = [UIColor blackColor].CGColor;
    MiniAmount_lbl.layer.shadowOpacity = 0.5;
    MiniAmount_lbl.layer.shadowRadius = 2;
    MiniAmount_lbl.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    BetweenAmount.layer.cornerRadius = 5;
    BetweenAmount.layer.shadowColor = [UIColor blackColor].CGColor;
    BetweenAmount.layer.shadowOpacity = 0.5;
    BetweenAmount.layer.shadowRadius = 2;
    BetweenAmount.layer.shadowOffset = CGSizeMake(3.0f,3.0f);

    MaxAmount_lbl.layer.cornerRadius = 5;
    MaxAmount_lbl.layer.shadowColor = [UIColor blackColor].CGColor;
    MaxAmount_lbl.layer.shadowOpacity = 0.5;
    MaxAmount_lbl.layer.shadowRadius = 2;
    MaxAmount_lbl.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    Amount_Field.layer.borderColor=[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0].CGColor;
    Amount_Field.layer.borderWidth= 1.0f;
    Amount_Field.delegate=self;
    
    [self MyBalancce];
    [CardIOUtilities preload];
   


    // Do any additional setup after loading the view.
}

-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    NSString * money =JJLocalizedString(@"Money", nil);
    NSString * Recharge=JJLocalizedString(@"Recharge_Cabily", nil);
    NSString * casless=JJLocalizedString(@"Cashless_hassle", nil);
    
    
//    [_Option_lbl setText:[NSString stringWithFormat:@"%@ %@ %@",Recharge,[Themes getAppName],money]];
    [_Title_Label setText:[NSString stringWithFormat:@"%@ %@",[Themes getAppName],money]];
    [_Hint_lbl setText:[NSString stringWithFormat:@"%@ %@ %@",casless,[Themes getAppName],money]];
    [_Hint_lbl setText:JJLocalizedString(@"Your_current", nil)];
    [AddMoney_Btn setTitle:JJLocalizedString(@"ADD_CABILY_MONEY", nil) forState:UIControlStateNormal];
    
}

- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (PaypalVC.isSuccess==YES)
    {
        [self showSuccess];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadMybalance)
                                                 name:@"Walletrecharged"
                                               object:nil];
    [Themes StopView:self.view];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)loadMybalance
{
    [self MyBalancce];
    [Themes StopView:self.view];

    
}

- (void)showSuccess {
    self.Sucess.hidden = NO;
    self.Sucess.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:2.0];
    self.Sucess.alpha = 0.0f;
    [UIView commitAnimations];
}

-(void)doSingleTap
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)GetTranscationList:(id)sender {
    
    TranscationVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"TranscationVCID"];
    [self.navigationController pushViewController:addfavour animated:YES];
}
- (IBAction)GointToPaypal:(id)sender {
    
    /*PaypalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"paypalVCID"];
    PaypalVC.Amount_String=Amount_Field.text;
    PaypalVC.isRecharge=YES;
    PaypalVC.details=@"Recharge Cabily Money";
    [self.navigationController pushViewController:PaypalVC animated:YES];*/
    minamount=[minamount stringByReplacingOccurrencesOfString:currencySymbol
                                                   withString:@""];
    
    NSString *str = [Amount_Field text];
    int RollNumber = [str intValue];

    if ([Amount_Field.text isEqualToString:@""])
    {
        NSString *titleStr = JJLocalizedString(@"Oops", nil);
        UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(@"please_enter_amount", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
    }
    else if (RollNumber < [minamount integerValue])
    {
        NSString *titleStr = JJLocalizedString(@"Oops", nil);
        UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(@"please_enter_amount", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
    }
    else
    {
        alert2= [[UIAlertView alloc]initWithTitle:@"Recharge" message:@"What Kind Transcation You need? \n Kindly Select one option !!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Pay Pal",@"Card.IO", nil];
        [alert2 show];
    }

    //[self presentViewController:PaypalVC animated:YES completion:nil];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if (alertView == alert2) {
    
    NSString *string = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([string isEqualToString:@"Pay Pal"]) {
        
        PaypalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"paypalVCID"];
        PaypalVC.Amount_String=Amount_Field.text;
        PaypalVC.isRecharge=YES;
        NSString * nameofApp=[NSString stringWithFormat:@"Recharge %@ Wallet",[Themes getAppName]];
        PaypalVC.details=nameofApp;
        [self.navigationController pushViewController:PaypalVC animated:YES];
    }
    else if ([string isEqualToString:@"Card.IO"]) {
        
        CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
        scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:scanViewController animated:YES completion:nil];
    }
    
    }
}
- (IBAction)CredirCard:(id)sender {
    
    [self AddWalletAmount:sender];

//    if ([Amount_Field.text isEqualToString:@""])
//    {
//        UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Oops\xF0\x9F\x9A\xAB" message:@"please enter amount to add your wallet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [Alert show];
//    }
//    
//    else
//    {
//        /* bgView=[[[NSBundle mainBundle] loadNibNamed:@"Blurview" owner:self options:nil] objectAtIndex:0];
//         bgView.frame=self.view.frame;
//         [self.view addSubview:bgView];
//         [self.view bringSubviewToFront:paymentView];*/
//        
//        
//        /*paymentView.hidden=NO;
//         NSString *Urlstr=[NSString stringWithFormat:@"%@mobile/wallet-recharge/payform?user_id=%@&total_amount=%@",AppbaseUrl,[Themes getUserID],Amount_Field.text];
//         NSURL *nsurl=[NSURL URLWithString:Urlstr];
//         NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//         [paymentView loadRequest:nsrequest];
//         [bgView setHidden:NO];*/
//        
//        WebViewVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewVCID"];
//        addfavour.FromComing=YES;
//        addfavour.parameters=Amount_Field.text;
//        [self presentViewController:addfavour animated:YES completion:nil];
//        
//    }
    
    

}
#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    
   NSLog(@"Scan succeeded with info: %@", [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.redactedCardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv]); 
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)MyBalancce
{
    NSDictionary*paramets=@{@"user_id":[Themes getUserID]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web GetMoney:paramets success:^(NSMutableDictionary *responseDictionary)
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
            currencySymbol=[Themes findCurrencySymbolByCode:[[responseDictionary valueForKey:@"response"] valueForKey:@"currency"]];
            Auto_recharge=[responseDictionary valueForKey:@"auto_charge_status"];
            Current_labl.text=[NSString stringWithFormat:@"%@%@",currencySymbol,[[responseDictionary valueForKey:@"response"] valueForKey:@"current_balance"]];
            maxamount=[NSString stringWithFormat:@"%@%@",currencySymbol,[[[responseDictionary valueForKey:@"response"] valueForKey:@"recharge_boundary"]valueForKey:@"max_amount"]];
            minamount=[NSString stringWithFormat:@"%@%@",currencySymbol,[[[responseDictionary valueForKey:@"response"] valueForKey:@"recharge_boundary"]valueForKey:@"min_amount"]];
            [Themes SaveWallet:[[responseDictionary valueForKey:@"response"] valueForKey:@"current_balance"]];
            between=[NSString stringWithFormat:@"%@%@",currencySymbol,[[[responseDictionary valueForKey:@"response"] valueForKey:@"recharge_boundary"]valueForKey:@"middle_amount"]];
            [MiniAmount_lbl setTitle:minamount forState:UIControlStateNormal];
            [MaxAmount_lbl setTitle:maxamount forState:UIControlStateNormal];
            [BetweenAmount setTitle:between forState:UIControlStateNormal];
           // Amount_Field.placeholder=[NSString stringWithFormat:@"Enter amount between  %@ - %@",minamount,maxamount];
            
            Amount_Field.placeholder=JJLocalizedString([NSString stringWithFormat:@"Enter_amount_between  %@ - %@",minamount,maxamount], nil);
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
- (IBAction)Addamount:(id)sender {
    
    UIButton *btnAuthOptions=(UIButton*)sender;
    if (btnAuthOptions.tag==1)
    {
        minamount = [minamount stringByReplacingOccurrencesOfString:currencySymbol
                                             withString:@""];
        Amount_Field.text=minamount;
        [MiniAmount_lbl setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:91.0/255.0 blue:0/255.0 alpha:1.0]];
        [MaxAmount_lbl setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]];
        [BetweenAmount setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]];
    }
    else if (btnAuthOptions.tag==2)
    {
        between = [between stringByReplacingOccurrencesOfString:currencySymbol
                                                         withString:@""];
        Amount_Field.text=between;
        [MiniAmount_lbl setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]];
        [MaxAmount_lbl setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]];
        [BetweenAmount setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:91.0/255.0 blue:0/255.0 alpha:1.0]];
    }
    else if (btnAuthOptions.tag==3)
    {
        maxamount = [maxamount stringByReplacingOccurrencesOfString:currencySymbol
                                                         withString:@""];
        
        Amount_Field.text=maxamount;
        [MiniAmount_lbl setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]];
        [MaxAmount_lbl setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:91.0/255.0 blue:0/255.0 alpha:1.0]];
        [BetweenAmount setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]];
    }

}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (Amount_Field) {
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(doneClicked:)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        Amount_Field.inputAccessoryView = keyboardDoneButtonView;
    }
    self.Scrollview.contentOffset=CGPointMake(0, 200);
}
- (void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
    self.Scrollview.contentOffset=CGPointMake(0, 0);

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*if (textField == Amount_Field) {
        if (string.length == 0) {
            return YES;
        }
        maxamount=[maxamount stringByReplacingOccurrencesOfString:currencySymbol
                                                       withString:@""];
        
        NSString *editedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSInteger editedStringValue = editedString.integerValue;
        return editedStringValue <= [maxamount integerValue];
    }
    
    if (textField==Amount_Field)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 4;
    }*/

    if (textField==Amount_Field)
    {
        NSString *text1=[Amount_Field.text stringByAppendingString:string];
 
        maxamount=[maxamount stringByReplacingOccurrencesOfString:currencySymbol
                                                       withString:@""];
        between = [between stringByReplacingOccurrencesOfString:currencySymbol
                                                     withString:@""];
        minamount = [minamount stringByReplacingOccurrencesOfString:currencySymbol
                                                         withString:@""];

        
        if ([text1 isEqualToString:maxamount])
        {
            [MaxAmount_lbl setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:91.0/255.0 blue:0/255.0 alpha:1.0]];

        }
        else
        {
            [MaxAmount_lbl setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]];

        }
        
        if ([text1 isEqualToString:between])
        {
            [BetweenAmount setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:91.0/255.0 blue:0/255.0 alpha:1.0]];
            
        }
        else
        {
            [BetweenAmount setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]];
            
        }
        if ([text1 isEqualToString:minamount])
        {
            [MiniAmount_lbl setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:91.0/255.0 blue:0/255.0 alpha:1.0]];
            
        }
        else
        {
            [MiniAmount_lbl setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]];
            
        }
        
        
    }
    if (textField == Amount_Field) {
        if (string.length == 0) {
            return YES;
        }
        maxamount=[maxamount stringByReplacingOccurrencesOfString:currencySymbol
                                                       withString:@""];
        
        NSString *editedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSInteger editedStringValue = editedString.integerValue;
        return editedStringValue <= [maxamount integerValue];
    }
    
   
    return YES;
    
}
- (IBAction)AddWalletAmount:(id)sender {
    
    minamount=[minamount stringByReplacingOccurrencesOfString:currencySymbol
                                                   withString:@""];
    
    NSString *str = [Amount_Field text];
    int RollNumber = [str intValue];
    
    if ([Amount_Field.text isEqualToString:@""])
    {
        NSString *titleStr = JJLocalizedString(@"Oops", nil);
        UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(@"please_enter_amount", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
    }
    else if (RollNumber < [minamount integerValue])
    {
        NSString *titleStr = JJLocalizedString(@"Oops", nil);
        UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:JJLocalizedString(@"please_enter_amount", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
    }
    else
    {
       /* bgView=[[[NSBundle mainBundle] loadNibNamed:@"Blurview" owner:self options:nil] objectAtIndex:0];
        bgView.frame=self.view.frame;
        [self.view addSubview:bgView];
        [self.view bringSubviewToFront:paymentView];*/

        
    /*paymentView.hidden=NO;
    NSString *Urlstr=[NSString stringWithFormat:@"%@mobile/wallet-recharge/payform?user_id=%@&total_amount=%@",AppbaseUrl,[Themes getUserID],Amount_Field.text];
    NSURL *nsurl=[NSURL URLWithString:Urlstr];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [paymentView loadRequest:nsrequest];
        [bgView setHidden:NO];*/
        
        if ([Auto_recharge isEqualToString:@"1"])
        {
            NSDictionary*paramets=@{@"user_id":[Themes getUserID],
                                    @"total_amount":Amount_Field.text};
            
            UrlHandler *web = [UrlHandler UrlsharedHandler];
            [Themes StartView:self.view];
            [web AddAmount:paramets success:^(NSMutableDictionary *responseDictionary)
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
                         
                         UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:JJLocalizedString(@"Transaction_Successful", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [Alert show];
                         [self MyBalancce];
                         Amount_Field.text=@"";
                         [Amount_Field resignFirstResponder];

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
        else
        {
            WebViewVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewVCID"];
            addfavour.FromComing=YES;
            addfavour.parameters=Amount_Field.text;
            [self.navigationController pushViewController:addfavour animated:YES];
        }
       

    }
}

@end
