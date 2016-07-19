//
//  ToolAlertMessage.m
//  YiuBook
//
//  Created by tusm on 15/5/19.
//  Copyright (c) 2015年 yiubook. All rights reserved.
//

#import "ToolAlertMessage.h"

@implementation ToolAlertMessage
+(void)ShowAlertMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor colorWithRed:28/225.0f green:28/225.0f blue:28/225.0f alpha:1.0f];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - LabelSize.width - 20)/2, [UIScreen mainScreen].bounds.size.height - 100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:2 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}
@end
