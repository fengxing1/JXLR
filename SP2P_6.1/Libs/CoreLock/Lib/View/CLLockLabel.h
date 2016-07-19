//
//  CLLockLabel.h
//  CoreLock
//
//  Created by 黄杰 on 16/7/14.
//  Copyright (c) 2016年 黄杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLLockLabel : UILabel



/*
 *  普通提示信息
 */
-(void)showNormalMsg:(NSString *)msg;



/*
 *  警示信息
 */
-(void)showWarnMsg:(NSString *)msg;


@end
