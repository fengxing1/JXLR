//
//  JXLRPopTipView.h
//  LX-UI模板
//
//  Created by eims1 on 16/2/20.
//  Copyright (c) 2016年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXLRPopTipView : UIView
@property (nonatomic,strong) UIButton *bottomBtn;//底部按钮

-(void)setTipViewWithTopImage:(NSString *)imageName withTitle:(NSString *)title withContent:(NSString *)content withButtonTitle:(NSString *)buttonTitle;

@end
