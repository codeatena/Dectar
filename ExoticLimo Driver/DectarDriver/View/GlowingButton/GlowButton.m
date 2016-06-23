//
//  GlowButton.m
//  Uibtn
//
//  Created by Aravind Natarajan on 23/12/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

#import "GlowButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation GlowButton{
    FBShimmeringView *_shimmeringView;
    CGFloat fingerPositionInView;
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.titleLabel.numberOfLines=1;
        self.layer.cornerRadius=4;
       
        [Theme setBoldFontForButtonBold:self];
        
        if([[Theme getCurrentLanguage] isEqualToString:@"es"]){
            [Theme setSmallBoldFontForButtonBold:self];
        }
       
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.3;
        
        
        //[self setImage:[UIImage imageNamed:@"GradBtn"] forState:UIControlStateNormal];
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panned:)];
        [self addGestureRecognizer:panRecognizer];
        
    }
    return self;
}
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext ();
//
//    // The color to fill the rectangle (in this case black)
//    CGContextSetRGBFillColor(context,37/255.0f,169/255.0f,239/255.0f,1.0);
//    //CGContextSetRGBFillColor(context,0.0,0.0f,0.0f,1.0);
//    // draw the filled rectangle
//    CGRect fillRect = CGRectMake(0,0,fingerPositionInView,self.bounds.size.height);
//    CGContextFillRect (context, fillRect);
//}
- (void)_panned:(UIPanGestureRecognizer *)panRecognizer
{
    CGPoint translation = [panRecognizer translationInView:self];
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        
        
        fingerPositionInView = translation.x + self.frame.origin.x;
        [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, fingerPositionInView-45, 0.0, 0.0)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, fingerPositionInView, 0.0, 0.0)];
        // [self setNeedsDisplayInRect:self.bounds];
        
    } else if (panRecognizer.state == UIGestureRecognizerStateChanged) {
        
        fingerPositionInView = translation.x + self.frame.origin.x;
        [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, fingerPositionInView-45, 0.0, 0.0)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, fingerPositionInView, 0.0, 0.0)];
        // [self setNeedsDisplayInRect:self.bounds];
    } else if (panRecognizer.state == UIGestureRecognizerStateEnded ||
               panRecognizer.state == UIGestureRecognizerStateCancelled) {
        if(fingerPositionInView>=self.frame.size.width-100){
            if ([self.delegate respondsToSelector:@selector(slideActive)]) {
                [self.delegate slideActive];
            }
        }
        fingerPositionInView = 0;
        [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, fingerPositionInView-45, 0.0, 0.0)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, fingerPositionInView, 0.0, 0.0)];
        // [self setNeedsDisplayInRect:self.bounds];
        
        
    }
    
}
@end
