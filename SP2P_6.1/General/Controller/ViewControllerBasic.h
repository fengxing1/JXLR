//
//  ViewControllerBasic.h
//  YiuBook
//
//  Created by tusm on 15/10/21.
//  Copyright (c) 2015年 yiubook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "NetWorkRequestManager.h"
/**
 *  控制器NavgationBar的状态
 */
typedef NS_ENUM(NSInteger, NavgationState){
    /**
     *  隐藏
     */
    NavgationStateHide,
    /**
     *  白色状态栏加返回按钮
     */
    NavgationStateWhiteWithBack,
    /**
     *  白色状态栏无返回按钮
     */
    NavgationStateWhiteNotBack,
};
/**
 *  基控制器（主要控制网络，提示框，状态栏，控制器的进退）
 */
@interface ViewControllerBasic : UIViewController<NetWorkRequestManagerDeletage>
/**
 *  网络连接管理类
 */
@property(nonatomic,strong)NetWorkRequestManager *netWorkRM;
/**
 *  提示框
 */
@property(nonatomic,strong)MBProgressHUD *hudBasic;
/**
 *  控制器NavgationBar的状态（在[super viewWillAppear:animated]前定义）
 */
@property(nonatomic,assign)NavgationState navgationState;
/**
 *  显示提示框
 *
 *  @param hudText 提示框内容
 */
-(void)showHudWitText:(NSString *)hudText;
/**
 *  隐藏提示框
 */
-(void)hidHud;
/**
 *  退出当前控制器
 */
-(void)back;
/**
 *  进入下一个控制器
 *
 *  @param viewControllerToPresent 控制器
 *  @param flag                    是否开启跳转动画
 *  @param completion              完成跳转执行的任务
 */
-(void)presentViewOrPushController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
/**
 *  进入下一个控制器(是否带Nav)
 *
 *  @param viewControllerToPresent <#viewControllerToPresent description#>
 *  @param flag                    <#flag description#>
 *  @param completion              <#completion description#>
 *  @param isNewNavgation          <#isNewNavgation description#>
 */
-(void)presentViewOrPushController:(UIViewController *)viewControllerToPresent
                          animated:(BOOL)flag
                        completion:(void (^)(void))completion withNewNavgation:(BOOL)isNewNavgation;
/**
 *  网络请求失败
 *
 *  @param error
 */
-(void)responseFailure:(NSError *)error;
/**
 *  网络不可用
 */
-(void)networkError;
@end
