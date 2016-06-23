//
//  RatingsViewController.m
//  DectarDriver
//
//  Created by Casperon Technologies on 9/3/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "RatingsViewController.h"

@interface RatingsViewController ()<RatingDelegate>

@end

@implementation RatingsViewController
@synthesize ratingHeaderLbl,txtLbl,ratingsTblView,rateRiderBtn,ratingsArray,custIndicatorView,rideid,commentTxtView,rateSuccessView,
rateOptionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    ratingsTblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setFont];
    [self loadTxtView];
    [self getDatasForRating];
}
-(void)loadTxtView{
    commentTxtView.hidden=YES;
    commentTxtView.textColor=[UIColor darkGrayColor];
    commentTxtView.text=JJLocalizedString(@"Comment_Optional", nil);
    commentTxtView.textAlignment = NSTextAlignmentLeft;
    [commentTxtView setDelegate:self];
    commentTxtView.layer.borderWidth=1;
    commentTxtView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    commentTxtView.layer.cornerRadius=5;
}
-(void)setFont{
    [self.skipBtn setTitle:JJLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
    [self.rateRiderBtn setTitle:JJLocalizedString(@"Rate_Rider", nil) forState:UIControlStateNormal];
    ratingHeaderLbl.text=JJLocalizedString(@"Please_Rate", nil);
    rateRiderBtn.hidden=YES;
    ratingHeaderLbl=[Theme setHeaderFontForLabel:ratingHeaderLbl];
    txtLbl=[Theme setHeaderFontForLabel:txtLbl];
    commentTxtView=[Theme setNormalFontForTextView:commentTxtView];
    rateRiderBtn=[Theme setBoldFontForButton:rateRiderBtn];
  //  rateRiderBtn.layer.cornerRadius=2;
   // rateRiderBtn.layer.masksToBounds=YES;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount=0;
    if([ratingsArray count]>0){
        rowCount=[ratingsArray count];
    }
    return rowCount;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RatingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ratingIdentifier"];
    if (cell == nil) {
        cell = [[RatingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:@"ratingIdentifier"];
        
    }
    cell.delegate=self;
    
        RatingsRecords * objRatingRec=[ratingsArray objectAtIndex:indexPath.row];
        [cell setRaingRecs:objRatingRec];
        [cell setIndexpath:indexPath];

    
       cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)getDatasForRating{
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web RateUser:[self setParametersGettingRateData]
              success:^(NSMutableDictionary *responseDictionary)
     {
         ratingsArray=[[NSMutableArray alloc]init];
         
         [self stopActivityIndicator];
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
             NSString * statusStr =[Theme checkNullValue:[responseDictionary objectForKey:@"ride_ratting_status"]];
             if ([statusStr isEqualToString:@"1"]) {
                 rateOptionView.hidden=YES;
                 rateSuccessView.hidden=NO;
                 ratingHeaderLbl.text=@"Thanks";
                 
             }else{
                 for (NSDictionary * reasonDict in responseDictionary[@"review_options"]){
                     RatingsRecords * objRatingRecs=[[RatingsRecords alloc]init];
                     objRatingRecs.rateId=[Theme checkNullValue:reasonDict[@"option_id"]];
                     objRatingRecs.rateReason=[Theme checkNullValue:reasonDict[@"option_title"]];
                     objRatingRecs.rateValue=@"";
                     [ratingsArray addObject:objRatingRecs];
                 }
                 commentTxtView.hidden=NO;
                 [rateRiderBtn setHidden:NO];
                 [ratingsTblView reloadData];
             }
             
         }else{
             // [self.view makeToast:@"Some error occured"];
         }
     }
              failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [self.view makeToast:kErrorMessage];
         
     }];

}
-(NSDictionary *)setParametersGettingRateData{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"optionsFor":@"rider",
                                  @"ride_id" : rideid
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
-(void)ratingSelected:(NSIndexPath *)index withValue:(float )rateValue{
    NSString * Value=[NSString stringWithFormat:@"%.2f",rateValue];
    RatingsRecords * objRatingsRecs=[ratingsArray objectAtIndex:index.row];
    objRatingsRecs.rateValue=Value;
    [ratingsArray setObject:objRatingsRecs atIndexedSubscript:index.row];
    [self.ratingsTblView beginUpdates];
    [self.ratingsTblView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    [self.ratingsTblView endUpdates];
}

- (IBAction)didClickBackBtn:(id)sender {
}

- (IBAction)didClickRateRideBtn:(id)sender {
    if([self setValidationForRating]){
        [self showActivityIndicator:YES];
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [web SubmitRateUser:[self setParametersForSubmitRating]
              success:^(NSMutableDictionary *responseDictionary)
         {
             [self stopActivityIndicator];
             if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
                 [self moveToHome];
             }else{
                  [self.view makeToast:[Theme checkNullValue:[responseDictionary objectForKey:@"response"]]];
             }
             
         }
              failure:^(NSError *error)
         {
             [self stopActivityIndicator];
             // [self moveToHome];
             [self.view makeToast:kErrorMessage];
             
         }];
    }
}

-(void)moveToHome{
    BOOL isHome=NO;
    BOOL isRootSkip=NO;
    for (UIViewController *controller1 in self.navigationController.viewControllers) {
        
        if ([controller1 isKindOfClass:[HomeViewController class]]) {
            
            [self.navigationController popToViewController:controller1
                                                  animated:YES];
            isHome=YES;
            isRootSkip=YES;
            
            break;
        }
    }
    if(isHome==NO){
        for (UIViewController *controller1 in self.navigationController.viewControllers) {
            
            if ([controller1 isKindOfClass:[StarterViewController class]]) {
                
                [self.navigationController popToViewController:controller1
                                                      animated:YES];
                isRootSkip=YES;
                break;
            }
        }
    }
    if(isRootSkip==NO){
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}
- (IBAction)didClickSkipBtn:(id)sender {
    BOOL isHome=NO;
     BOOL isRootSkip=NO;
   
        for (UIViewController *controller1 in self.navigationController.viewControllers) {
            
            if ([controller1 isKindOfClass:[HomeViewController class]]) {
                
                [self.navigationController popToViewController:controller1
                                                      animated:YES];
                isHome=YES;
                  isRootSkip=YES;
                break;
            }
        }
        if(isHome==NO){
            for (UIViewController *controller1 in self.navigationController.viewControllers) {
                
                if ([controller1 isKindOfClass:[StarterViewController class]]) {
                    
                    [self.navigationController popToViewController:controller1
                                                          animated:YES];
                    isRootSkip=YES;
                    break;
                }
            }
        }
    
    if(isRootSkip==NO){
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}
-(BOOL)setValidationForRating{
    BOOL isValid=YES;
    for (int i=0; i<[ratingsArray count]; i++) {
        RatingsRecords * objRatingsRecs=[ratingsArray objectAtIndex:i];
        float rateVal=[objRatingsRecs.rateValue floatValue];
        if(rateVal==0){
            NSString * is_mandatory=JJLocalizedString(@"is_mandatory", nil);
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Oops !!" message:[NSString stringWithFormat:@"%@ %@",objRatingsRecs.rateReason,is_mandatory] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            isValid=NO;
            break;
        }
    }
    return isValid;
}
-(NSDictionary *)setParametersForSubmitRating{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSString * cmtStr=[Theme checkNullValue:commentTxtView.text];
    if([cmtStr isEqualToString:JJLocalizedString(@"Comment_Optional", nil)]){
        cmtStr=@"";
    }
    NSMutableDictionary *dictForuser=[[NSMutableDictionary alloc] init];
    for (int i=0; i<[ratingsArray count]; i++) {
        NSString * str1=[NSString stringWithFormat:@"ratings[%d][option_title]",i];
        NSString * str2=[NSString stringWithFormat:@"ratings[%d][option_id]",i];
        NSString * str3=[NSString stringWithFormat:@"ratings[%d][rating]",i];
        RatingsRecords * objRatingsRecs=[ratingsArray objectAtIndex:i];
        [dictForuser setObject:objRatingsRecs.rateReason forKey:str1];
        [dictForuser setObject:objRatingsRecs.rateId forKey:str2];
        [dictForuser setObject:objRatingsRecs.rateValue forKey:str3];
        
        }
    [dictForuser setObject:@"rider" forKey:@"ratingsFor"];
     [dictForuser setObject:rideid forKey:@"ride_id"];
    [dictForuser setObject:[Theme checkNullValue:cmtStr] forKey:@"comments"];
    return dictForuser;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
   
    
   
    if ([textView.text isEqualToString:JJLocalizedString(@"Comment_Optional", nil)]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    
    if ([textView.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        
    }
    if ([textView.text isEqualToString:@""]) {
        textView.text = JJLocalizedString(@"Comment_Optional", nil);
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
     
        if ([textView.text isEqualToString:@""]) {
            textView.text = JJLocalizedString(@"Comment_Optional", nil);
            textView.textColor = [UIColor lightGrayColor]; //optional
        }

        return NO;
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
