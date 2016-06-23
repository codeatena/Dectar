//
//  GlowButton.h
//  Uibtn
//
//  Created by Aravind Natarajan on 23/12/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBShimmeringView.h"
#import "Theme.h"
@protocol SlideButtonDelegat <NSObject>

@optional
- (void) slideActive;



@end
@interface GlowButton : UIButton
@property (nonatomic, assign) id<SlideButtonDelegat> delegate;
@end
