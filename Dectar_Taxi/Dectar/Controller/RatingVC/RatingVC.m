//
//  RatingVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 9/3/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "RatingVC.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "ReviewRecord.h"
#import "RatingCell.h"
#import "LanguageHandler.h"

@interface RatingVC ()<UITableViewDataSource,UITableViewDelegate,RatingViewDelegate,UITextViewDelegate>
{
    NSMutableArray * reviewArray;
    NSString * ratingcount;
    UITextView*CommentText;
}
@end

@implementation RatingVC
@synthesize recordObj,submit_btn,rating_table,RideID_Rating,Rated_View,Header_labl,Tick_View,Skip_Btn,objRec;

- (void)viewDidLoad {
    [super viewDidLoad];
    reviewArray=[NSMutableArray array];
    rating_table.delegate=self;
    rating_table.dataSource=self;
    [Themes StopView:self.view];
    [Themes statusbarColor:self.view];
    

    rating_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *customBottomView = [[UIView alloc]init];
    customBottomView.frame=CGRectMake(0, 10, self.view.frame.size.width, 120);
    customBottomView.backgroundColor=[UIColor clearColor];
    rating_table.tableFooterView = customBottomView;
    
    CommentText=[[UITextView alloc]initWithFrame:CGRectMake(10,10,self.view.frame.size.width-20,100)];
    CommentText.delegate=self;
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 14.0 ];
    CommentText.font  = myFont;
    CommentText.textColor=[UIColor lightGrayColor];
    [CommentText setReturnKeyType:UIReturnKeyDone];
    [CommentText setBackgroundColor:[UIColor clearColor]];
    CommentText.autocapitalizationType=UITextAutocapitalizationTypeNone;
    CommentText.spellCheckingType=UITextSpellCheckingTypeNo;
    CommentText.autocorrectionType=UITextAutocorrectionTypeNo;
    [CommentText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [CommentText.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    CommentText.layer.cornerRadius = 5;
    CommentText.clipsToBounds = YES;
    [customBottomView addSubview:CommentText];
    Tick_View.transform = CGAffineTransformMakeScale(0.01, 0.01);

    [self setDatasToView];
    
   // [self setObjRec:_objRec];
    [self listPayment];
    
    [Header_labl setText:JJLocalizedString(@"Rating", nil)];
    [Skip_Btn setTitle:JJLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
    [_Thanks_Lbl setText:JJLocalizedString(@"thanks", nil)];
    [_Already setText:JJLocalizedString(@"You_rated", nil)];
    [submit_btn setTitle:JJLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [Themes StopView:self.view];
}

-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    CommentText.text=JJLocalizedString(@"Please_enter_your_comments_about_your_ride", nil) ;
    [Header_labl setText:JJLocalizedString(@"Rating", nil) ];
    [Skip_Btn setTitle:JJLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
    [_Thanks_Lbl setText:JJLocalizedString(@"thanks", nil)];
    [_Already setText:JJLocalizedString(@"You_rated", nil)];
    [submit_btn setTitle:JJLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
    

}

- (void) textViewDidBeginEditing:(UITextView *) textView {
    rating_table.frame=CGRectMake(0, rating_table.frame.origin.y-180, rating_table.frame.size.width, rating_table.frame.size.height+223);
    CommentText.text=@"";
    CommentText.textColor=[UIColor blackColor];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        rating_table.frame=CGRectMake(0, rating_table.frame.origin.y+180, rating_table.frame.size.width, rating_table.frame.size.height-223);
        
        return NO;
    }
    if(range.location==0 && ![text isEqualToString:@""])
    {
         CommentText.text = @"";
    }
    else if(range.location==0)
    {
         CommentText.text = JJLocalizedString(@"Please_enter_your_comments_about_your_ride", nil);
        CommentText.textColor=[UIColor lightGrayColor];

    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDatasToView
{
    //RideID_Rating=objRec.ride_id;
    [Themes StopView:self.view];
}

-(void)listPayment

{
    NSDictionary * parameters=@{@"optionsFor":@"driver",
                                @"ride_id":RideID_Rating};
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web ListReview:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
         
         NSLog(@"%@",responseDictionary);
         responseDictionary=[Themes writableValue:responseDictionary];

         NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
         
         if ([comfiramtion isEqualToString:@"1"])
         {
             [Themes StopView:self.view];
             
             
             NSString * RateStatus=[Themes checkNullValue:[responseDictionary valueForKey:@"ride_ratting_status"]];
             
            if([RateStatus  isEqual: @"1"])
            {
                rating_table.hidden=YES;
                Rated_View.hidden=NO;
                
                [Header_labl setText:JJLocalizedString(@"thanks", nil) ];
                
                //Header_labl.text=@"Thanks";
                [Skip_Btn setTitle:@"Done" forState:UIControlStateNormal];
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    // animate it to the identity transform (100% scale)
                    Tick_View.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished){
                    // if you want to do something once the animation finishes, put it here
                }];
                
                
                
            }
             else
             {
                 [Header_labl setText:JJLocalizedString(@"Rating", nil) ];
                 [Skip_Btn setTitle:JJLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
//                 [Skip_Btn setTitle:@"Skip" forState:UIControlStateNormal];
//
//                 Header_labl.text=@"Rating";

                 rating_table.hidden=NO;
                 Rated_View.hidden=YES;
             for (NSDictionary * objCatDict in responseDictionary[@"review_options"]) {
                 recordObj=[[ReviewRecord alloc]init];
                 recordObj.Review_title=[objCatDict valueForKey:@"option_title"];
                 recordObj.Review_ID =[objCatDict valueForKey:@"option_id"];
                 recordObj.Review_Rating=@"";
                 [reviewArray addObject:recordObj];
                 
             }
             [rating_table reloadData];
             }
             
         }
         else
         {
             
         }
         }
         
     }
             failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [reviewArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";//RatingCell
    
    RatingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RatingCell" owner:nil options:nil] objectAtIndex:0];
        
        
    }
   
        ReviewRecord *objRec=(ReviewRecord*)[reviewArray objectAtIndex:indexPath.row];
        [cell setSelectiveIndexpath:indexPath];
        [cell setObjReviewRecord:objRec];
        cell.delegate=self;
    
    
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
    
}

- (void)RatingGiven:(NSIndexPath *)SelectedIndexPath withValue:(CGFloat)value
{
     ReviewRecord * objBookingRecord=[reviewArray objectAtIndex:SelectedIndexPath.row];
    objBookingRecord.Review_Rating=[NSString stringWithFormat:@"%.2f", value];
    [reviewArray setObject:objBookingRecord atIndexedSubscript:SelectedIndexPath.row];
    [rating_table reloadData];
    
}
- (IBAction)Submit_rating:(id)sender {
    
    BOOL isCheckRating = NO;
    NSLog(@"%@",RideID_Rating);
   
        NSMutableDictionary * objRateDict=[[NSMutableDictionary alloc]init];
        for (int i=0; i<[reviewArray count]; i++) {
            ReviewRecord * onjReviewRec=[reviewArray objectAtIndex:i];
            NSString * str1=[NSString stringWithFormat:@"ratings[%d][option_title]",i];
             NSString * str2=[NSString stringWithFormat:@"ratings[%d][option_id]",i];
             NSString * str3=[NSString stringWithFormat:@"ratings[%d][rating]",i];
            
            if ([onjReviewRec.Review_Rating isEqualToString:@""]) {
                isCheckRating=YES;
            }else
            {
                [objRateDict setObject:onjReviewRec.Review_title forKey:str1];
                [objRateDict setObject:onjReviewRec.Review_ID forKey:str2];
                [objRateDict setObject:onjReviewRec.Review_Rating forKey:str3];
            }
           
        }
        [objRateDict setObject:@"driver" forKey:@"ratingsFor"];
        [objRateDict setObject:RideID_Rating forKey:@"ride_id"];
    
    if ([CommentText.text isEqualToString:JJLocalizedString(@"Please_enter_your_comments_about_your_ride", nil)])
    {
        CommentText.text = @"";

    }
        [objRateDict setObject:CommentText.text forKey:@"comments"];
        [Themes writableValue:objRateDict];
    if (isCheckRating==NO) {
        [self setobjRating:objRateDict];
    }else{
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Sorry\xF0\x9F\x9A\xAB" message:JJLocalizedString(@"please_give_the_review", nil )  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
    
    
    
}

-(void)setobjRating:(NSMutableDictionary*)dic
{
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web SubmirReview:dic success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
         NSLog(@"%@",responseDictionary);
         responseDictionary=[Themes writableValue:responseDictionary];

         NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
         NSString * message=[responseDictionary valueForKey:@"response"];
         [Themes StopView:self.view];
         if ([comfiramtion isEqualToString:@"1"])
         {
             NSString * alertTitle=JJLocalizedString(@"Thank_you", nil);
             UIAlertView * alert=[[UIAlertView alloc]initWithTitle:alertTitle message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
             
             AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             [del LogIn];
         }
         else if ([comfiramtion isEqualToString:@"0"])

         {
             UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Sorry\xF0\x9F\x9A\xAB" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];   
             
            AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [del LogIn];
             


         }
         
         }
     }
              failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
    

}
- (IBAction)Skip_rating:(id)sender {
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [del LogIn];
}
@end
