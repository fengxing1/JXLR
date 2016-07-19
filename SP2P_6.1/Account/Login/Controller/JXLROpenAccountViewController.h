//
//  JXLROpenAccountViewController.h
//  LX-UI模板
//
//  Created by eims1 on 16/2/19.
//  Copyright (c) 2016年 sky. All rights reserved.
//

//实名认证

#import <UIKit/UIKit.h>
typedef enum{
    OpenAccountTypeDefault,
    OpenAccountTypeRegister,
    OpenAccountTypeTender,
    OpenAccountTypeRecharge,
    OpenAccountTypeRelease,
    OpenAccountTypeWithdraw
}OpenAccountType;
@interface JXLROpenAccountViewController : ViewControllerBasicNotNetwork
@property (nonatomic, copy) NSString *type;//进入开户页面
@property (nonatomic, assign)OpenAccountType openAccountType;
@end
