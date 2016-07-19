//
//  ToolConstant.m
//  YiuBook
//
//  Created by tusm on 15/9/25.
//  Copyright (c) 2015年 yiubook. All rights reserved.
//

#import "ToolConstant.h"

@implementation ToolConstant
+(NSString *)getStringNumber:(NSString *)text{
    NSScanner *scanner = [NSScanner scannerWithString:text];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    return [NSString stringWithFormat:@"%d",number];
}
//判断是否为整形：

+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
+(BOOL)stringIsNil:(NSString *)text{
    if(text==nil||[text isEqualToString:@""]){
        return YES;
    }else{
        return NO;
    }
}
@end
