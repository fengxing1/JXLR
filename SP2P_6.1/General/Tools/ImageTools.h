//
//  ImageTools.h
//  SP2P_6.1
//
//  Created by 邹显 on 16/3/18.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageTools : NSObject
+(UIImage *)imageWithColor:(UIColor *)color;
+(UIImage *)imageWithColor:(UIColor *)color withAlpha:(float)alpha;
+(UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image;
+(UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size;
+(UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size withAlpha:(float)alpha;
@end
