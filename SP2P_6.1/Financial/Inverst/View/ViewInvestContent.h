//
//  ViewInvestContent.h
//  SP2P_6.1
//
//  Created by 邹显 on 16/3/21.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Investment.h"
#define HeightViewInvestContent (WidthScreen/2.4)
@interface ViewInvestContent : UIView
@property(nonatomic,strong)Investment *investment;
@property(nonatomic,strong)UIButton *btnContent;
@property(nonatomic,strong)UIButton *btnInvest;
-(void)initContentBackground;
@end
