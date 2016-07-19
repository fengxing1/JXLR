//
//  Investment.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Investment : NSObject
/*投资标题*/
@property (nonatomic, copy) NSString *title;
/*借款ID*/
@property (nonatomic, copy) NSString *borrowId;
/**/
@property (nonatomic, copy) NSString *levelStr;
/**/
@property (nonatomic, copy) NSString *imgurl;
/**/
@property (nonatomic, copy) NSString *unitstr;
/**/
@property (nonatomic, assign) BOOL isQuality;
/**/
@property (nonatomic, assign) CGFloat amount;
/**/
@property (nonatomic, copy) NSString *time;
/**/
@property (nonatomic, assign) int repaytime;
/**/
@property (nonatomic, assign) CGFloat rate;
/**/
@property (nonatomic, copy) NSString *numStr;
/**/
@property (nonatomic, assign) CGFloat progress;
//传值到利率计算机页面
@property (nonatomic, assign) int repayType;

@property (nonatomic, assign) int deadperiodUnit;

@property (nonatomic, assign) int deadType;

@property (nonatomic, assign) int bonus;

@property (nonatomic, assign) int awardScale;
/*
标状态（1、2、3）并且进度<100 投标  ＝100 满标  4:还款中  5:已还款  <0流标
 */
@property (nonatomic, assign) int status;
@end
