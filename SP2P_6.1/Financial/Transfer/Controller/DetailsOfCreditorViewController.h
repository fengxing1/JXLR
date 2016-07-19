//
//  DetailsOfCreditorViewController.h
//  SP2P_6.1
//
//  Created by Jerry on 14-7-8.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//债权转让详情
#import <UIKit/UIKit.h>

@interface DetailsOfCreditorViewController : ViewControllerBasicNotNetwork

@property (nonatomic,copy)NSString *titleString;

@property (nonatomic,copy)NSString *creditorId;

@property (nonatomic, copy) NSString *timeString;

@property (nonatomic, copy) NSString *rulingPriceStr;

@property (nonatomic, assign) CGFloat rate;
@end
