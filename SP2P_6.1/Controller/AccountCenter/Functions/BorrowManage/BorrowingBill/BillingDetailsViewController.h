//
//  BillingDetailsViewController.h
//  SP2P_6.1
//
//  Created by Jerry on 14-7-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
//账单详情
@interface BillingDetailsViewController : ViewControllerBasicNotNetwork

@property (nonatomic, assign) NSString *billId;

@property (nonatomic, assign) BOOL isPay;

@property (nonatomic, copy) NSString *typeStr;

@end
