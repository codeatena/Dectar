//
//  PaddingLabel.m
//  Dectar
//
//  Created by AnCheng on 6/20/16.
//  Copyright © 2016 CasperonTechnologies. All rights reserved.
//

#import "PaddingLabel.h"

@implementation PaddingLabel

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawTextInRect:(CGRect)rect {
    // Drawing code
    
    UIEdgeInsets insets = {0, 5, 0, 10};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
