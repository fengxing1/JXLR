//
//  General.h
//  SP2P_6.1
//
//  Created by tusm on 16/3/24.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IS_IOS7   (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1)
#define TimeIntervalUpdate  8   //更新间隔时间
#define UserDefaultsTimeIntervalUpdate @"UserDefaultsTimeIntervalUpdate"  //更新间隔时间持久化ID

@interface General : NSObject

@end
