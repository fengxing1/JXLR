//
//  ReportViewController.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-24.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
// 举报=======================================

#import <UIKit/UIKit.h>
/**
 *  举报
 */
@interface ReportViewController : ViewControllerBasicNotNetwork
@property (nonatomic, copy)NSString *bidIdSign;
@property (nonatomic, copy)NSString *reportName;
@property (nonatomic, copy)NSString *borrowName;

@end
