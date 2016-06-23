//
//  HeaderLabelHandler.m
//  DectarDriver
//
//  Created by Aravind Natarajan on 03/02/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import "HeaderLabelHandler.h"

@implementation HeaderLabelHandler

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
        //self.backgroundColor=SetThemeColor;
        self.textColor=SetThemeColor;
        
    }
    return self;
}

@end
