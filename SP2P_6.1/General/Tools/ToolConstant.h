//
//  ToolConstant.h
//  YiuBook
//
//  Created by tusm on 15/9/25.
//  Copyright (c) 2015年 yiubook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolConstant : NSObject
+(NSString *)getStringNumber:(NSString *)text;
+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)isPureFloat:(NSString*)string;
+(BOOL)stringIsNil:(NSString *)text;
@end
