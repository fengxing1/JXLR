//
//  CLLockVC.h
//  CoreLock
//
//  Created by 黄杰 on 16/7/14.
//  Copyright (c) 2016年 黄杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    //设置密码
    CoreLockTypeSetPwd=0,
    
    //输入并验证密码
    CoreLockTypeVeryfiPwd,
    
    //修改密码
    CoreLockTypeModifyPwd,
    
}CoreLockType;



@interface CLLockVC : UIViewController<UIAlertViewDelegate>

@property (nonatomic,assign) CoreLockType type;

/** 直接进入修改页面的 */
@property (nonatomic,assign) BOOL isDirectModify;

/*
 *  是否有本地密码缓存？即用户是否设置过初始密码？
 */
+(BOOL)hasPwd;





/*
 *  展示设置密码控制器
 */
+(instancetype)showSettingLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock;



/*
 *  展示验证密码输入框
 */
+(instancetype)showVerifyLockVCInVC:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock;



/*
 *  展示验证密码输入框
 */
+(instancetype)showModifyLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock;


/*
 *  消失
 */
-(void)dismiss:(NSTimeInterval)interval;





@end
