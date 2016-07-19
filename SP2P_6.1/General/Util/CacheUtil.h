//
//  CacheUtil.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CacheFileHomeMessage @"CacheFileHomeMessage"  //首页缓存数据路径
@interface CacheUtil : NSObject

+(NSString *) creatCacheFileName:(NSDictionary *) parameters;

@end
