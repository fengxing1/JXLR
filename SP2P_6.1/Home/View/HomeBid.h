//
//  HomeBid.h
//  SP2P_6.1
//
//  Created by Jaqen on 16/7/25.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Investment.h"

#define HeightViewInvestContent (WidthScreen/1.1)

@interface HomeBid : UIView

@property (nonatomic,strong) Investment *investment;
@property (nonatomic,strong) UIButton *btnContent;
@property (nonatomic,strong) UIButton *btnInvest;

-(void)initContentBackground;

@end
