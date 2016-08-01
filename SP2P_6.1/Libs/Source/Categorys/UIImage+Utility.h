//
//  UIImage+Utility.h
//  XHImageViewer
//
//  Created by Jaqen on 16/8/1.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)

+ (UIImage *)fastImageWithData:(NSData *)data;
+ (UIImage *)fastImageWithContentsOfFile:(NSString *)path;

@end
