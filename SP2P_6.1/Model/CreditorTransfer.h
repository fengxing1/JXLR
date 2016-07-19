//
//  CreditorTransfer.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//债权转让
#define VoerDue  @"已过期"
#import <Foundation/Foundation.h>

@interface CreditorTransfer : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *apr;

@property (nonatomic, assign) NSInteger creditorId;

@property (nonatomic,copy)NSString *creditorImg;

@property (nonatomic, assign) BOOL isQuality;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) int  repaytime;

@property (nonatomic,assign)int remainTime;//剩余时间

@property (nonatomic, assign) NSInteger sortTime;

@property (nonatomic, copy) NSString *units;

@property (nonatomic, assign) CGFloat principal;// 本金

@property (nonatomic, assign) CGFloat minPrincipal;// 底价

@property (nonatomic, assign) CGFloat currentPrincipal; // 当前价格

@property (nonatomic, assign) NSInteger attentionDebtId;

+(instancetype)createCreditorTransfer;
@end
