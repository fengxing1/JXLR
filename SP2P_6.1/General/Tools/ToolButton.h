//
//  ToolButton.h
//  SP2P_6.1
//
//  Created by tusm on 16/4/1.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  button 工具类
 */
@interface ToolButton : NSObject
/**
 *  创建主按钮（红色背景）
 *
 *  @param frame  <#frame description#>
 *  @param title  <#title description#>
 *  @param target <#target description#>
 *  @param action <#action description#>
 *
 *  @return <#return value description#>
 */
+(UIButton *)CreateMainButton:(CGRect)frame withTitle:(NSString *)title withTarget:(id)target  withAction:(SEL)action;
+(UIButton *)CreateMainButton:(CGRect)frame withTitle:(NSString *)title withColor:(UIColor *)color withTarget:(id)target  withAction:(SEL)action;
@end
