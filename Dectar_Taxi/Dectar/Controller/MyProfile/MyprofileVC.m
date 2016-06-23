//
//  MyprofileVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/27/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "MyprofileVC.h"
#import "Themes.h"
#import "ChangePasswordVC.h"
#import "AppDelegate.h"
#import "UrlHandler.h"
#import "Constant.h"
#import "OTP_VC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "REFrostedViewController.h"
#import "LoginMainVC.h"
#import "LanguageHandler.h"

@interface MyprofileVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    NSString * OTP_status;
    NSString * OTP_Code;
    NSString * Name;
    NSString * PhoneNumber;
    NSString * country;
    UIPickerView * CountryPicker;
    UIToolbar *mypickerToolbar;

}

@end

@implementation MyprofileVC
@synthesize menubutton,mobile_labl,savebtn,name_lbl,email_labl,nameeditbutton,mbleditbutton,logout,ScrollingView,country_fld,Countrycode_Array,CountryName_Array;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_profileLangButton setTitle:JJLocalizedString(@"English", nil) forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
    
    CountryName_Array=[NSArray new];
    Countrycode_Array=[NSArray new];
    
    CountryName_Array=@[@"Afghanistan(+93)", @"Albania(+355)",@"Algeria(+213)",@"American Samoa(+1684)",@"Andorra(+376)",@"Angola(+244)",@"Anguilla(+1264)",@"Antarctica(+672)",@"Antigua and Barbuda(+1268)",@"Argentina(+54)",@"Armenia(+374)",@"Aruba(+297)",@"Australia(+61)",@"Austria(+43)",@"Azerbaijan(+994)",@"Bahamas(+1242)",@"Bahrain(+973)",@"Bangladesh(+880)",@"Barbados(+1246)",@"Belarus(+375)",@"Belgium(+32)",@"Belize(+501)",@"Benin(+229)",@"Bermuda(+1441)",@"Bhutan(+975)",@"Bolivia(+591)",@"Bosnia and Herzegovina(+387)",@"Botswana(+267)",@"Brazil(+55)",@"British Virgin Islands(+1284)",@"Brunei(+673)",@"Bulgaria(+359)",@"Burkina Faso(+226)",@"Burma (Myanmar)(+95)",@"Burundi(+257)",@"Cambodia(+855)",@"Cameroon(+237)",@"Canada(+1)",@"Cape Verde(+238)",@"Cayman Islands(+1345)",@"Central African Republic(+236)",@"Chad(+235)",@"Chile(+56)",@"China(+86)",@"Christmas Island(+61)",@"Cocos (Keeling) Islands(+61)",@"Colombia(+57)",@"Comoros(+269)",@"Cook Islands(+682)",@"Costa Rica(+506)",@"Croatia(+385)",@"Cuba(+53)",@"Cyprus(+357)",@"Czech Republic(+420)",@"Democratic Republic of the Congo(+243)",@"Denmark(+45)",@"Djibouti(+253)",@"Dominica(+1767)",@"Dominican Republic(+1809)",@"Ecuador(+593)",@"Egypt(+20)",@"El Salvador(+503)",@"Equatorial Guinea(+240)",@"Eritrea(+291)",@"Estonia(+372)",@"Ethiopia(+251)",@"Falkland Islands(+500)",@"Faroe Islands(+298)",@"Fiji(+679)",@"Finland(+358)",@"France (+33)",@"French Polynesia(+689)",@"Gabon(+241)",@"Gambia(+220)",@"Gaza Strip(+970)",@"Georgia(+995)",@"Germany(+49)",@"Ghana(+233)",@"Gibraltar(+350)",@"Greece(+30)",@"Greenland(+299)",@"Grenada(+1473)",@"Guam(+1671)",@"Guatemala(+502)",@"Guinea(+224)",@"Guinea-Bissau(+245)",@"Guyana(+592)",@"Haiti(+509)",@"Holy See (Vatican City)(+39)",@"Honduras(+504)",@"Hong Kong(+852)",@"Hungary(+36)",@"Iceland(+354)",@"India(+91)",@"Indonesia(+62)",@"Iran(+98)",@"Iraq(+964)",@"Ireland(+353)",@"Isle of Man(+44)",@"Israel(+972)",@"Italy(+39)",@"Ivory Coast(+225)",@"Jamaica(+1876)",@"Japan(+81)",@"Jordan(+962)",@"Kazakhstan(+7)",@"Kenya(+254)",@"Kiribati(+686)",@"Kosovo(+381)",@"Kuwait(+965)",@"Kyrgyzstan(+996)",@"Laos(+856)",@"Latvia(+371)",@"Lebanon(+961)",@"Lesotho(+266)",@"Liberia(+231)",@"Libya(+218)",@"Liechtenstein(+423)",@"Lithuania(+370)",@"Luxembourg(+352)",@"Macau(+853)",@"Macedonia(+389)",@"Madagascar(+261)",@"Malawi(+265)",@"Malaysia(+60)",@"Maldives(+960)",@"Mali(+223)",@"Malta(+356)",@"MarshallIslands(+692)",@"Mauritania(+222)",@"Mauritius(+230)",@"Mayotte(+262)",@"Mexico(+52)",@"Micronesia(+691)",@"Moldova(+373)",@"Monaco(+377)",@"Mongolia(+976)",@"Montenegro(+382)",@"Montserrat(+1664)",@"Morocco(+212)",@"Mozambique(+258)",@"Namibia(+264)",@"Nauru(+674)",@"Nepal(+977)",@"Netherlands(+31)",@"Netherlands Antilles(+599)",@"New Caledonia(+687)",@"New Zealand(+64)",@"Nicaragua(+505)",@"Niger(+227)",@"Nigeria(+234)",@"Niue(+683)",@"Norfolk Island(+672)",@"North Korea (+850)",@"Northern Mariana Islands(+1670)",@"Norway(+47)",@"Oman(+968)",@"Pakistan(+92)",@"Palau(+680)",@"Panama(+507)",@"Papua New Guinea(+675)",@"Paraguay(+595)",@"Peru(+51)",@"Philippines(+63)",@"Pitcairn Islands(+870)",@"Poland(+48)",@"Portugal(+351)",@"Puerto Rico(+1)",@"Qatar(+974)",@"Republic of the Congo(+242)",@"Romania(+40)",@"Russia(+7)",@"Rwanda(+250)",@"Saint Barthelemy(+590)",@"Saint Helena(+290)",@"Saint Kitts and Nevis(+1869)",@"Saint Lucia(+1758)",@"Saint Martin(+1599)",@"Saint Pierre and Miquelon(+508)",@"Saint Vincent and the Grenadines(+1784)",@"Samoa(+685)",@"San Marino(+378)",@"Sao Tome and Principe(+239)",@"Saudi Arabia(+966)",@"Senegal(+221)",@"Serbia(+381)",@"Seychelles(+248)",@"Sierra Leone(+232)",@"Singapore(+65)",@"Slovakia(+421)",@"Slovenia(+386)",@"Solomon Islands(+677)",@"Somalia(+252)",@"South Africa(+27)",@"South Korea(+82)",@"Spain(+34)",@"Sri Lanka(+94)",@"Sudan(+249)",@"Suriname(+597)",@"Swaziland(+268)",@"Sweden(+46)",@"Switzerland(+41)",@"Syria(+963)",@"Taiwan(+886)",@"Tajikistan(+992)",@"Tanzania(+255)",@"Thailand(+66)",@"Timor-Leste(+670)",@"Togo(+228)",@"Tokelau(+690)",@"Tonga(+676)",@"Trinidad and Tobago(+1868)",@"Tunisia(+216)",@"Turkey(+90)",@"Turkmenistan(+993)",@"Turks and Caicos Islands(+1649)",@"Tuvalu(+688)",@"Uganda(+256)",@"Ukraine(+380)",@"United Arab Emirates(+971)",@"United Kingdom(+44)",@"United States(+1)",@"Uruguay(+598)",@"US Virgin Islands(+1340)",@"Uzbekistan(+998)",@"Vanuatu(+678)",@"Venezuela(+58)",@"Vietnam(+84)",@"Wallis and Futuna(+681)",@"West Bank(970)",@"Yemen(+967)",@"Zambia(+260)",@"Zimbabwe(+263)"];
    
     Countrycode_Array=@[@"+93",@"+355",@"+213",@"+1684",@"+376",@"+244",@"+1264",@"+672",@"+1268",@"+54",@"+374",@"+297",@"+61",@"+43",@"+994",@"+1242",@"+973",@"+880",@"+1246",@"+375",@"+32",@"+501",@"+229",@"+1441",@"+975",@"+591",@"+387",@"+267",@"+55",@"+1284",@"+673",@"+359",@"+226",@"+95",@"+257",@"+855",@"+237",@"+1",@"+238",@"+1345",@"+236",@"+235",@"+56",@"+86",@"+61",@"+61",@"+57",@"+269",@"+682",@"+506",@"+385",@"+53",@"+357",@"+420",@"+243",@"+45",@"+253",@"+1767",@"+1809",@"+593",@"+20",@"+503",@"+240",@"+291",@"+372",@"+251",@"+500",@"+298",@"+679",@"+358",@"+33",@"+689",@"+241",@"+220",@"+970",@"+995",@"+49",@"+233",@"+350",@"+30",@"+299",@"+1473",@"+1671",@"+502",@"+224",@"+245",@"+592",@"+509",@"+39",@"+504",@"+852",@"+36",@"+354",@"+91",@"+62",@"+98",@"+964",@"+353",@"+44",@"+972",@"+39",@"+225",@"+1876",@"+81",@"+962",@"+7",@"+254",@"+686",@"+381",@"+965",@"+996",@"+856",@"+371",@"+961",@"+266",@"+231",@"+218",@"+423",@"+370",@"+352",@"+853",@"+389",@"+261",@"+265",@"+60",@"+960",@"+223",@"+356",@"+692",@"+222",@"+230",@"+262",@"+52",@"+691",@"+373",@"+377",@"+976",@"+382",@"+1664",@"+212",@"+258",@"+264",@"+674",@"+977",@"+31",@"+599",@"+687",@"+64",@"+505",@"+227",@"+234",@"+683",@"+672",@"+850",@"+1670",@"+47",@"+968",@"+92",@"+680",@"+507",@"+675",@"+595",@"+51",@"+63",@"+870",@"+48",@"+351",@"+1",@"+974",@"+242",@"+40",@"+7",@"+250",@"+590",@"+290",@"+1869",@"+1758",@"+1599",@"+508",@"+1784",@"+685",@"+378",@"+239",@"+966",@"+221",@"+381",@"+248",@"+232",@"+65",@"+421",@"+386",@"+677",@"+252",@"+27",@"+82",@"+34",@"+94",@"+249",@"+597",@"+268",@"+46",@"+41",@"+963",@"+886",@"+992",@"+255",@"+66",@"+670",@"+228",@"+690",@"+676",@"+1868",@"+216",@"+90",@"+993",@"+1649",@"+688",@"+256",@"+380",@"+971",@"+44",@"+1",@"+598",@"+1340",@"+998",@"+678",@"+58",@"+84",@"+681",@"+970",@"+967",@"+260",@"+263"];
    
    
    
     ScrollingView.contentSize = CGSizeMake(ScrollingView.frame.size.width, logout.frame.origin.y+logout.frame.size.height+100);
    [Themes statusbarColor:self.view];
    
    country_fld.delegate=self;
    
    mobile_labl.text=[Themes getmobileNumber];
    name_lbl.text=[Themes getUserName];
    email_labl.text=[Themes getuserMail];
    country_fld.text=[Themes GetCountryCode];
    
    UITapGestureRecognizer * estimate=[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(Tapping)];
    estimate.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:estimate];
    
    savebtn.hidden=YES;
    //logout.layer.cornerRadius = 5;
    logout.layer.shadowColor = [UIColor blackColor].CGColor;
    logout.layer.shadowOpacity = 0.5;
    logout.layer.shadowRadius = 2;
    logout.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    [self.view endEditing:YES];
    
}
-(void)applicationLanguageChangeNotification:(NSNotification*)notification{

    [_heading setText:JJLocalizedString(@"Profile", nil)];
    [_signin_details setText:JJLocalizedString(@"SIGN_IN_DETAILS", nil)];
    [_Email_hint setText:JJLocalizedString(@"email", nil)];
    [_chang_hint setText:JJLocalizedString(@"change_Password", nil)];
    [savebtn setTitle:JJLocalizedString(@"save", nil) forState:UIControlStateNormal];
    [_my_details setText:JJLocalizedString(@"MY_DETAILS", nil)];
    [_name_hint setText:JJLocalizedString(@"name", nil)];
    [_mobile_hint setText:JJLocalizedString(@"mobile_number", nil)];
    [logout setTitle:JJLocalizedString(@"logout", nil) forState:UIControlStateNormal];
    [_profileLangButton setTitle:JJLocalizedString(@"English", nil) forState:UIControlStateNormal];
    
}
- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CountryPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [CountryPicker setDataSource: self];
    [CountryPicker setDelegate: self];
    CountryPicker.backgroundColor=[UIColor whiteColor];
    CountryPicker.showsSelectionIndicator = YES;
    country_fld.inputView = CountryPicker;
    
    mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    mypickerToolbar.barStyle = UIBarStyleDefault;
    [mypickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone)];
    [[UIBarButtonItem appearance] setTintColor:BGCOLOR];
    [barItems addObject:doneBtn];
    [mypickerToolbar setItems:barItems animated:YES];
    
    country_fld.inputAccessoryView = mypickerToolbar;
    savebtn.hidden=NO;

    return YES;
}
-(void)pickerDone
{

    [country_fld resignFirstResponder];
    mypickerToolbar.hidden=YES;
    CountryPicker.hidden=YES;
    
    NSInteger row;
    row = [CountryPicker selectedRowInComponent:0];
    country_fld.text= [Countrycode_Array objectAtIndex:row];
    savebtn.hidden=NO;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logout:(id)sender {
    
    
    NSDictionary *parameters=@{@"user_id":[Themes getUserID],
                               @"device":@"IOS",
                               };
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web loggout:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
         // NSLog(@"%@",responseDictionary);
         responseDictionary=[Themes writableValue:responseDictionary];

         NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
         NSString * alert=[responseDictionary valueForKey:@"response"];
         [Themes StopView:self.view];
         if ([comfiramtion isEqualToString:@"1"])
         {
             
             /*UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [Alert show];*/
             
             FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
             [FBSDKAccessToken setCurrentAccessToken:nil];
             [login logOut];
             
             [Themes ClearUserInfo];

             AppDelegate* appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
             [appdelegate disconnect];
             
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
             //LoginMainVC * objLoginVc=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginMainVCID"];
             LoginMainVC * objLoginVc=[storyboard instantiateViewControllerWithIdentifier:@"LoginMainVCID"];
             UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginVc];
             appdelegate.window.rootViewController = navigationController;

             
         }
         else
         {
            /* UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error\xF0\x9F\x9A\xAB" message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [Alert show];*/
             FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
             [FBSDKAccessToken setCurrentAccessToken:nil];
             [login logOut];
             
             [Themes ClearUserInfo];
             AppDelegate* appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
             [appdelegate disconnect];
             
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
//             LoginMainVC * objLoginVc=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginMainVCID"];
             LoginMainVC * objLoginVc=[storyboard instantiateViewControllerWithIdentifier:@"LoginMainVCID"];
             
             UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginVc];
             appdelegate.window.rootViewController = navigationController;

         }
         
         }
     }
            failure:^(NSError *error)
     {
         [Themes StopView:self.view];
        // [self logout:self];
     }];
}
-(void)Tapping
{
    [self.view endEditing:YES];
    [nameeditbutton setHidden:NO];
    [mbleditbutton setHidden:NO];
    savebtn.hidden=YES;

}
-(IBAction)Saving:(id)sender
{
    savebtn.hidden=YES;
    [self SaveNumber];

}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==name_lbl)
    {
        [nameeditbutton setHidden:YES];
        [mbleditbutton setHidden:NO];
        savebtn.hidden=YES;

    }
    else if (textField==mobile_labl)
    {
        [nameeditbutton setHidden:NO];
        [mbleditbutton setHidden:YES];
        savebtn.hidden=NO;

    }
    else if (textField==country_fld)
    {
        savebtn.hidden=NO;

    }
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    
    if (textField==name_lbl)
    {
        if ([textField.text isEqualToString:@""])
        {
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Sorry\xF0\x9F\x9A\xAB" message:JJLocalizedString(@"Kindly_Enter_UserName", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
            [textField resignFirstResponder];

        }
        else
        {
            [textField resignFirstResponder];

            [self SaveName];
            
        }

    }
    else if (textField==mobile_labl)
    {
        
        if ([textField.text isEqualToString:@""] && [country_fld.text isEqualToString:@""])
        {
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Sorry\xF0\x9F\x9A\xAB" message:JJLocalizedString(@"Kindly_Enter_Mobile_Number", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
        }
        else
        {
            [textField resignFirstResponder];

            [self SaveNumber];

        }


    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField==mobile_labl)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    
    return YES;

}
- (void)SaveName {
    
    
    NSDictionary *parameters=@{@"user_id":[Themes getUserID],
                               @"user_name":name_lbl.text};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web nameChange:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
         // NSLog(@"%@",responseDictionary);
         responseDictionary=[Themes writableValue:responseDictionary];

         NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
         NSString * alert=[responseDictionary valueForKey:@"response"];
         [Themes StopView:self.view];
         if ([comfiramtion isEqualToString:@"1"])
         {
             
             UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [Alert show];
             
             Name=[responseDictionary valueForKey:@"user_name"];
             [Themes saveUserName:Name];

             
         }
         else
         {
             NSString *titleStr = JJLocalizedString(@"Oops", nil);
             UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [Alert show];
             [self.view endEditing:YES];

         }
         
         }
     }
               failure:^(NSError *error)
     {
         [Themes StopView:self.view];
         [self.view endEditing:YES];

     }];


}
- (void) SaveNumber
{
    NSDictionary *parameters=@{@"user_id":[Themes getUserID],
                               @"country_code":country_fld.text,
                               @"phone_number":mobile_labl.text
                               };
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];

    [web numberChange:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         // NSLog(@"%@",responseDictionary);
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
         responseDictionary=[Themes writableValue:responseDictionary];

         NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
         NSString * alert=[responseDictionary valueForKey:@"response"];
         [Themes StopView:self.view];
         if ([comfiramtion isEqualToString:@"1"])
         {
             
             OTP_VC * otpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OTPVCID"];
             
            OTP_status=[responseDictionary valueForKey:@"otp_status"];
             OTP_Code=[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"otp"]];
             
             otpVC.OTP_Status=OTP_status;
             otpVC.OTP_Code=OTP_Code;
             otpVC.Checkking=@"Myprofile";
             otpVC.mobile_number=[responseDictionary valueForKey:@"phone_number"];
             otpVC.country_code=[responseDictionary valueForKey:@"country_code"];
             
              [self.navigationController pushViewController:otpVC animated:YES];
             
             UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [Alert show];
             
         }
         else
         {
             NSString *titleStr = JJLocalizedString(@"Oops", nil);
             UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@\xF0\x9F\x9A\xAB",titleStr] message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [Alert show];
             [savebtn setHidden:NO];
             [self.view endEditing:YES];

         }
         }
         
     }
            failure:^(NSError *error)
     {
         [Themes StopView:self.view];
         [savebtn setHidden:NO];
         [self.view endEditing:YES];


     }];
    

}
- (void)textFieldDidEndEditing:(UITextField *)textField
{

    if (textField==name_lbl)
    {
        [nameeditbutton setHidden:NO];
        [mbleditbutton setHidden:NO];
        savebtn.hidden=YES;

    }
    else if (textField==mobile_labl)
    {
        [nameeditbutton setHidden:NO];
        [mbleditbutton setHidden:NO];
        savebtn.hidden=YES;

    }
}
- (IBAction)ChangePassword:(id)sender {
    ChangePasswordVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeVCID"];
    [self.navigationController pushViewController:addfavour animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [CountryName_Array count];
}

// The data to return for the row and component (column) that's being passed in


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component

{
    
    return [CountryName_Array objectAtIndex:row];
    
}


- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    
    country_fld.text = [Countrycode_Array objectAtIndex:row];
    
    savebtn.hidden=NO;

}

- (IBAction)didClickLangBtn:(id)sender {
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"language %@",language);
    if([language hasPrefix:@"es"]){
        [Themes saveLanguage:@"en"];
        
       
        
    }else{
        
        [Themes saveLanguage:@"es"];
        
        
    }
    
    [Themes SetLanguageToApp];
    
    [_profileLangButton setTitle:JJLocalizedString(@"English", nil) forState:UIControlStateNormal];

}

@end
