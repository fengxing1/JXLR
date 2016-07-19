//
//  ViewControllerBasic.m
//  YiuBook
//
//  Created by tusm on 15/10/21.
//  Copyright (c) 2015年 yiubook. All rights reserved.
//

#import "ViewControllerBasic.h"

@interface ViewControllerBasic ()

@end

@implementation ViewControllerBasic
-(id)init{
    self=[super init];
    if(self){
        [self setupBasic];
        self.navgationState=NavgationStateWhiteWithBack;
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupViewBasic];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.netWorkRM.delegate=nil;
    self.netWorkRM.delegate=self;
    switch (self.navgationState) {
        case NavgationStateWhiteWithBack:{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            self.navigationController.navigationBar.hidden=NO;
            self.navigationController.navigationBar.translucent=NO;
            [self.navigationController.navigationBar setBarTintColor:ColorWhite];
            [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:ColorNavTitle, NSForegroundColorAttributeName,FontNavTitle, NSFontAttributeName, nil]];
            
            // 导航条返回按钮
            BarButtonItem *barButtonLeft=[BarButtonItem barItemWithTitle:@"返回" widthImage:[UIImage imageNamed:@"bar_left"] selectedImage:[UIImage imageNamed:@"bar_left_press"] withIsImageLeft:YES target:self action:@selector(back)];
            [self.navigationItem setLeftBarButtonItem:barButtonLeft];
        }
            break;
        case NavgationStateWhiteNotBack:{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            self.navigationController.navigationBar.hidden=NO;
            self.navigationController.navigationBar.translucent=NO;
            [self.navigationController.navigationBar setBarTintColor:ColorWhite];
            [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:ColorNavTitle, NSForegroundColorAttributeName,FontNavTitle, NSFontAttributeName, nil]];
        }
            break;
        case NavgationStateHide:{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            self.navigationController.navigationBar.hidden=YES;
        }
            break;
        default:
            break;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.hudBasic!=nil)
        [self.hudBasic hide:YES];
}
-(void)setupViewBasic{
    self.view.backgroundColor=ColorBGGray;
}
-(void)setupBasic{
    self.netWorkRM=[NetWorkRequestManager instanceRequest];
}
/**
 *  显示提示框
 *
 *  @param hudText 提示框内容
 */
-(void)showHudWitText:(NSString *)hudText{
    if(self.hudBasic!=nil)
        self.hudBasic=nil;
    UIWindow *window=[[[UIApplication sharedApplication] windows] lastObject];
    self.hudBasic=[[MBProgressHUD alloc] initWithView:window];
    [window addSubview:self.hudBasic];
    self.hudBasic.mode=MBProgressHUDModeIndeterminate;
    self.hudBasic.labelText=hudText;
    [self.hudBasic show:YES];
    [self performSelector:@selector(hidHud) withObject:nil afterDelay:8.0f];
}
/**
 *  隐藏提示框
 */
-(void)hidHud{
    [self.hudBasic hide:YES];
    self.hudBasic=nil;
}
/**
 *  退出当前控制器
 */
-(void)back{
    [self hidHud];
    [self.view endEditing:YES];
    if(self.navigationController.viewControllers.count>1){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 *  进入下一个控制器
 *
 *  @param viewControllerToPresent 控制器
 *  @param flag                    是否开启跳转动画
 *  @param completion              完成跳转执行的任务
 */
-(void)presentViewOrPushController:(UIViewController *)viewControllerToPresent
                          animated:(BOOL)flag
                        completion:(void (^)(void))completion{
    if(self.navigationController.viewControllers.count>0){
        [self.navigationController pushViewController:viewControllerToPresent animated:flag];
    }else{
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:viewControllerToPresent];
        [self presentViewController:nav animated:flag completion:completion];
    }
}
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
                        completion:(void (^)(void))completion withNewNavgation:(BOOL)isNewNavgation{
    if(self.navigationController.viewControllers.count>0&&!isNewNavgation){
        [self.navigationController pushViewController:viewControllerToPresent animated:flag];
    }else{
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:viewControllerToPresent];
        [self presentViewController:nav animated:flag completion:completion];
    }
}
#pragma deletage NetWork
/**
 *  网络请求失败
 *
 *  @param error
 */
-(void)responseFailure:(NSError *)error{
    [self hidHud];
    [SVProgressHUD showErrorWithStatus:@"网络请求失败！"];
}
/**
 *  网络不可用
 */
-(void)networkError{
    [self hidHud];
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}
@end
