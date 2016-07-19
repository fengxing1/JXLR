//
//  AddBankVCardViewController.h
//  SP2P_6.1
//
//  Created by Jerry on 14-6-27.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendValuedelegate.h"

#import "BankCard.h"

#define AddBankCardSuccess @"AddBankCardSuccess"


typedef NS_ENUM(NSInteger, BankCardEditType) {
    BankCardEditAdd,
    BankCardEditModify,
};
/**
 *  添加银行卡
 */
@interface AddBankVCardViewController : ViewControllerBasicNotNetwork

@property (nonatomic ,strong) BankCard *bankCard;

@property (nonatomic, assign) BankCardEditType editType;

@end
