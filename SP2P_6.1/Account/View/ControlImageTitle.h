//
//  ControlImageTitle.h
//  SP2P_6.1
//
//  Created by tusm on 16/3/27.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControlImageTitle : UIControl
/**
 *  创建一个上面图片下面文字的button
 */
-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withImage:(UIImage *)image withColor:(UIColor *)color addTarget:(id)target action:(SEL)action;
@end
