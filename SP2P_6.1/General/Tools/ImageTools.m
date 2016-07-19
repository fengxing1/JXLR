//
//  ImageTools.m
//  SP2P_6.1
//
//  Created by 邹显 on 16/3/18.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "ImageTools.h"

@implementation ImageTools
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size{
    CGRect rect=CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef contextRef=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, color.CGColor);
    CGContextFillRect(contextRef, rect);
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+(UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size withAlpha:(float)alpha{
    UIImage *image=[ImageTools imageWithColor:color withSize:size];
    return [ImageTools imageByApplyingAlpha:alpha image:image];
}

+(UIImage *)imageWithColor:(UIColor *)color{
    return [ImageTools imageWithColor:color withSize:CGSizeMake(1, 1)];
}

+(UIImage *)imageWithColor:(UIColor *)color withAlpha:(float)alpha{
    return [ImageTools imageWithColor:color withSize:CGSizeMake(1, 1) withAlpha:alpha];
}
@end
