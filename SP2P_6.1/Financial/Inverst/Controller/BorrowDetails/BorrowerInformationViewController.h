//
//  BorrowerInformationViewController.h
//  SP2P_6.1
//
//  Created by Jerry on 14-7-3.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  借款人信息
 */
@interface BorrowerInformationViewController : ViewControllerBasicNotNetwork

@property (nonatomic, strong)NSString *borrowerID;
@property (nonatomic,strong) NSString *borrowId;
@property (nonatomic,assign) float paceNum;
@end
