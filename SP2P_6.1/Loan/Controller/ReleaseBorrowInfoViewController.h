//
//  ReleaseBorrowInfoViewController.h
//  SP2P_6.1
//
//  Created by Jerry on 14-7-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  发布借款标
 */
@interface ReleaseBorrowInfoViewController : ViewControllerBasicNotNetwork

@property (nonatomic, copy) NSString *productID;
@property (nonatomic, assign) int isRepayment; // 是否秒还借款 （1 秒还借款  0 其他借款）
@property (nonatomic, copy) NSString * edfwStr;
@end