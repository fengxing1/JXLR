//
//  SizeTools.m
//  SP2P_6.1
//
//  Created by 邹显 on 16/3/18.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "SizeTools.h"

@implementation SizeTools
//获取文字的宽度
+(float)getStringWidth:(NSString *)text  Font:(UIFont *)font{
    return [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]].width;
}
//获取文字的高度，一行显示
+(float)getStringHeight:(NSString *)text  Font:(UIFont *)font{
    return [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]].height;
}
//获取文字的高度 设置内容的尺寸
+(float)getStringHeight:(NSString *)text Font:(UIFont *)font constrainedToSize:(CGSize)size{
    return  [text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size.height;
}

////获取文字的高度  设置内容的最大宽度
//+(float)getStringHeight:(NSString *)text Font:(UIFont *)font withWidthMax:(CGFloat)widthMax{
//    return  [self getStringHeight:text Font:font constrainedToSize:CGSizeMake(widthMax, HeightScreen)];
//}

@end
