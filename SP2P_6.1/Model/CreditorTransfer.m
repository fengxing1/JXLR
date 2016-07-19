//
//  CreditorTransfer.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "CreditorTransfer.h"

@implementation CreditorTransfer

//测试
+(instancetype)createCreditorTransfer{
    CreditorTransfer *bean = [[CreditorTransfer alloc] init];
    bean.title = @"不收利息转让，需要用钱，需要用钱，需要用钱";
    bean.apr = @"10.5";
    bean.time =@"2016-03-26 00:00:00";
    bean.principal = 1111.34;
    bean.minPrincipal = 1000.00;
    bean.currentPrincipal = 100.00;
    return bean;
}
@end
