//
//  UIImage+Yiu.m
//  WeiBo
//
//  Created by tusm on 15/7/8.
//  Copyright (c) 2015年 yiubook. All rights reserved.
//

#import "UIImage+Yiu.h"

@implementation UIImage (Yiu)
+(UIImage *)StretchableImageWithName:(NSString *)name{
    UIImage *image=[self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
}
@end
