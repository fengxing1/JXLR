//
//  NetWorkBasic.h
//  SP2P_6.1
//
//  Created by tusm on 16/3/26.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
@interface NetWorkBasic : AFHTTPSessionManager
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

- (instancetype)init;
/**
 取消任务
 */
-(void) cancel;
-(BOOL) isNetworkEnabled;
@end
