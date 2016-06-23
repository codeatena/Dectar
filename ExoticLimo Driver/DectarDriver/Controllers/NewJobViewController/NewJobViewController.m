//
//  NewJobViewController.m
//  DectarDriver
//
//  Created by Aravind Natarajan on 03/03/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import "NewJobViewController.h"



@interface NewJobViewController ()

@end

@implementation NewJobViewController

@synthesize containerView,
headerLbl,
userImageView,
nameLbl,
phoneBtn,
ratingView,
addressLbl,
timeLbl,
okBtn,objRiderRecs;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDataUI];
    [self setData];
    // Do any additional setup after loading the view.
}
-(void)setData{
    nameLbl.text=objRiderRecs.userName;
    addressLbl.text=objRiderRecs.userLocation;
    timeLbl.text=objRiderRecs.userTime;
    [headerLbl setText:JJLocalizedString(@"You_have_a_new_Trip", nil)];
    [okBtn setTitle:JJLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    
    
    [userImageView sd_setImageWithURL:[NSURL URLWithString:objRiderRecs.userImage] placeholderImage:[UIImage imageNamed:@"PlaceHolderImg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [self loadRating:objRiderRecs.userReview];
}

-(void)setDataUI{
    userImageView.layer.cornerRadius=userImageView.frame.size.width/2;
    userImageView.layer.masksToBounds=YES;
    
    phoneBtn.layer.cornerRadius=phoneBtn.frame.size.width/2;
    phoneBtn.layer.borderWidth=0.75;
    phoneBtn.layer.borderColor=setGreenColor.CGColor;
    phoneBtn.layer.masksToBounds=YES;
    
    okBtn.layer.cornerRadius=3;
    okBtn.layer.masksToBounds=YES;
    
    containerView.layer.cornerRadius=8;
    containerView.layer.masksToBounds=YES;
    
}
-(void)loadRating:(NSString *)ratingCount{
    float rateCount=[ratingCount floatValue];
    
    self.ratingView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
    self.ratingView.fullSelectedImage = [UIImage imageNamed:@"StarFill"];
    self.ratingView.contentMode = UIViewContentModeScaleAspectFill;
    self.ratingView.maxRating = 5;
    self.ratingView.minRating = 1;
    self.ratingView.rating = rateCount;
    self.ratingView.editable = NO;
    self.ratingView.halfRatings = YES;
    self.ratingView.floatRatings = YES;
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

- (IBAction)didClickPhoneBtn:(id)sender {
    
    NSString * phoneNum=[NSString stringWithFormat:@"tel:%@",objRiderRecs.userPhoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
}

- (IBAction)didClickOkBtn:(id)sender {
    [self.view endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(didClickNewJobsOk)]) {
        [self.delegate didClickNewJobsOk];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
