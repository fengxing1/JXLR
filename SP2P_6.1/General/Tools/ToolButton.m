//
//  ToolButton.m
//  SP2P_6.1
//
//  Created by tusm on 16/4/1.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "ToolButton.h"
@implementation ToolButton
+(UIButton *)CreateMainButton:(CGRect)frame withTitle:(NSString *)title withTarget:(id)target  withAction:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateNormal];
    [button setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = FontTextContent;
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:3.0];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(UIButton *)CreateMainButton:(CGRect)frame withTitle:(NSString *)title withColor:(UIColor *)color withTarget:(id)target  withAction:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:[ImageTools imageWithColor:color] forState:UIControlStateNormal];
    [button setBackgroundImage:[ImageTools imageWithColor:color withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = FontTextContent;
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:3.0];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end
