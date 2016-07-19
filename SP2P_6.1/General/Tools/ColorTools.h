//
//  ColorTools.h
//  EnterpriseWeb
//
//  Created by 李小斌 on 14-5-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

//设置RGB颜色值
#define SETCOLOR(R,G,B,A)	[UIColor colorWithRed:(CGFloat)R/255 green:(CGFloat)G/255 blue:(CGFloat)B/255 alpha:A]

#define ColorWhite  [ColorTools colorWithHexString:@"#ffffff"]
//Nav标题字体颜色
#define ColorNavTitle [ColorTools colorWithHexString:@"#222222"]

//控制器主背景色
#define ColorBGGray [ColorTools colorWithHexString:@"#eff0f4"]

//进度条背景色
#define ColorProgressBackground [ColorTools colorWithHexString:@"#dcdee4"]

//白色按钮高亮时颜色
#define ColorBtnWhiteHighlight [ColorTools colorWithHexString:@"#f8f8f8"]

//正文字体颜色
#define ColorTextContent [ColorTools colorWithHexString:@"#333333"]

//标题字体颜色
#define ColorTextTitleImport [ColorTools colorWithHexString:@"#222222"]

//辅助字体颜色
#define ColorTextVice [ColorTools colorWithHexString:@"#999999"]

//分隔线颜色
#define ColorLine [ColorTools colorWithHexString:@"#dcdee4"]

//理财选择按钮灰色背景
#define ColorCheckButtonGray [ColorTools colorWithHexString:@"#cccccc"]

// 登录框 边框色值
#define KlayerBorder  [ColorTools colorWithHexString:@"#d9d9d9"]

//大篇幅文字 按钮无效背景
#define ColorBigContentText [ColorTools colorWithHexString:@"#666666"]

//来融绿色值
#define KGreenColor  [ColorTools colorWithHexString:@"#c7eccb"]

//绿色颜色值
#define GreenColor ColorRedMain

//透明的黑色
#define ColorBlackView  SETCOLOR(0,0,0,0.3)
#define ColorBlackTop [ColorTools colorWithHexString:@"#e1ddda"]

//粉红颜色值
#define PinkColor  [ColorTools colorWithHexString:@"#e34f4f"]
//蓝色字体颜色值
#define BluewordColor  [ColorTools colorWithHexString:@"#436EEE"]
//主色调红色值
#define ColorRedMain  [ColorTools colorWithHexString:@"#fd5353"]
#define AlphaColorRedMainHeightLight  0.6
//主色调红色值高亮
#define ColorHeightRedMain  [ColorTools colorWithHexString:@"#fd4a49"]
//江西来融蓝色值
#define KBlueColor  [ColorTools colorWithHexString:@"#2fbdf2"]
// 黑色
#define KBlackColor  [ColorTools colorWithHexString:@"#3a3a3a"]

@interface ColorTools : NSObject

/** 颜色转换 IOS中十六进制的颜色转换为UIColor（RGB） **/
+ (UIColor *) colorWithHexString: (NSString *)color;
@end
