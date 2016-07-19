//
//  ViewControllerBasicNotNetwork.h
//  SP2P_6.1
//
//  Created by tusm on 16/3/30.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
/**
 *  控制器NavgationBar的状态
 */
typedef NS_ENUM(NSInteger, NavgationStateNotNetwork){
    /**
     *  隐藏
     */
    NavgationStateNotNetworkHide,
    /**
     *  白色状态栏加返回按钮
     */
    NavgationStateNotNetworkWhiteWithBack,
    /**
     *  白色状态栏无返回按钮
     */
    NavgationStateNotNetworkWhiteNotBack,
};
/**
 *  基控制器无网络（主要控制状态栏，控制器的进退）
 */
@interface ViewControllerBasicNotNetwork : UIViewController
/**
 *  控制器NavgationBar的状态（在[super viewWillAppear:animated]前定义）
 */
@property(nonatomic,assign)NavgationStateNotNetwork navgationState;
/**
 *  提示框
 */
@property(nonatomic,strong)MBProgressHUD *hudBasic;

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
 *  进入下一个控制器
 *
 *  @param viewControllerToPresent <#viewControllerToPresent description#>
 *  @param flag                    <#flag description#>
 *  @param completion              <#completion description#>
 *  @param isNewNavgation          <#isNewNavgation description#>
 */
-(void)presentViewOrPushController:(UIViewController *)viewControllerToPresent
                          animated:(BOOL)flag
                        completion:(void (^)(void))completion withNewNavgation:(BOOL)isNewNavgation;
@end
