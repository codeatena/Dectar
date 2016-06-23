//
//  HeaderViewColorHandler.m
//  DectarDriver
//
//  Created by Aravind Natarajan on 03/02/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import "HeaderViewColorHandler.h"
#import "DectarCustomColor.h"

@implementation HeaderViewColorHandler

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
        self.backgroundColor=[UIColor whiteColor];
        
    }
    return self;
}

@end
