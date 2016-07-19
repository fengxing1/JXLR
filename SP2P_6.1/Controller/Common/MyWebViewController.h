//
//  MyWebViewController.h
//  SP2P_6.1
//
//  Created by EIMS-IOS on 15-2-28.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXLROpenAccountViewController.h"
/**
 *  汇付天下充值
 */
@interface MyWebViewController : ViewControllerBasicNotNetwork

@property (nonatomic, copy) NSString *html;
@property (nonatomic, copy) NSString *type;
@property (nonatomic,assign)NSInteger level;
@property (nonatomic,copy)NSString *amountString;
@property (nonatomic,copy)NSString *titleString;

@property (nonatomic,assign)OpenAccountType openAccountType;
@end
