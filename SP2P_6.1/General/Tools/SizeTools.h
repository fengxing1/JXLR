//
//  SizeTools.h
//  SP2P_6.1
//
//  Created by 邹显 on 16/3/18.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HeightNavigationAndStateBar 64  //nav高度
#define HeightStateBar 20 //状态栏高度
#define HeightTabBar 49  //底部Tab高度
#define HeightScreen [[UIScreen mainScreen] bounds].size.height
#define WidthScreen [[UIScreen mainScreen] bounds].size.width
//间距设置
#define SpaceSmall 5
#define SpaceMediumSmall 10
#define SpaceMediumBig 15
#define SpaceBig 20

//分隔线的高度
#define HeightLine 0.8

//首页
//广告展板宽高比例
#define RateAd  2.77

//理财
#define HeightCheckButton  40

@interface SizeTools : NSObject
+(float)getStringWidth:(NSString *)text  Font:(UIFont *)font;
+(float)getStringHeight:(NSString *)text  Font:(UIFont *)font;
+(float)getStringHeight:(NSString *)text Font:(UIFont *)font constrainedToSize:(CGSize)size;

//+(float)getStringHeight:(NSString *)text Font:(UIFont *)font withWidthMax:(CGFloat)widthMax;

//+(float)getStringHeight:(NSString *)text Font:(UIFont *)font maxWidth:(CGFloat)width;
@end
