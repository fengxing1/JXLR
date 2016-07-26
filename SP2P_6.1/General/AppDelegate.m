//
//  EIMSAppDelegate.m
//  SP2P_6.1
//
//  Created by EIMS. on 14-6-6.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h"
#import "MyWebViewController.h"
#import "MainViewController.h"
#import "AdWebViewController.h"
#import "BPush.h"
#import "JSONKit.h"
#import "OpenUDID.h"
#import "ToolBlackView.h"
#import "ModelRemoteNotification.h"
#import <ShareSDK/ShareSDK.h>
#import "CLLockVC.h"
//腾讯SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <QQConnection/QQConnection.h>
//新浪微博SDK头文件
#import "WeiboSDK.h"
//微信SDK头文件
#import "WXApi.h"
#define SUPPORT_IOS8 1   //是否在IOS8设备运行
#import "IQKeyboardManager.h"
#import "InfoNewsViewController.h" //活动或新闻详情
#import "BillingDetailsViewController.h" //借款账单详情
#import "BorrowingDetailsViewController.h"//借款标详情

#define AppStoreAPI @"http://itunes.apple.com/lookup?id=1049683807"
#define AppStoreDownLoadUrl @"https://itunes.apple.com/cn/app/lai-rong-jin-fu/id1049683807?mt=8"



typedef NS_ENUM(NSInteger,RequestType){
    RequestTypeLogin=0
};
@interface AppDelegate ()< HTTPClientDelegate>


@property (assign,nonatomic) RemoteNotificationType remoteNotificationType;
@property (nonatomic,strong)ModelRemoteNotification *modelRemoteNotification;

@property (nonatomic, strong) UIView *viewContent;
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) NetWorkClient *requestClient;
@property (nonatomic, assign) RequestType requestType;
@property (nonatomic, strong) UIView *blockView;
@property (nonatomic, strong) UIView *blockViewRemoteNotification;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [ShareSDK registerApp:@"41721a1de002"];     //参数为ShareSDK官网中添加应用后得到的AppKey
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx2d9ef73af01f4a72" appSecret:@"d4624c36b6795d1d99dcf0547af5443d"
                           wechatCls:[WXApi class]];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"282517928"
                               appSecret:@"333b2e32950bca0d83919fc2db4fa747"
                             redirectUri:@"http://www.lai.cn/"];
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"1104929784"//41DBE3F8
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1104929784"
                           appSecret:@"jFBjqTcHUU23tKpL"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //连接邮件
    [ShareSDK connectMail];
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UIViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    [self startRootView];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;   //控制整个功能是否启用
    manager.shouldResignOnTouchOutside = YES;   //控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = YES;    //控制是否显示键盘上的工具条
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [application setApplicationIconBadgeNumber:0];
    
    
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
#warning 上线 AppStore 时需要修改BPushMode为BPushModeProduction 需要修改Apikey为自己的Apikey
    //在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:@"uZSvF8YrmDap4G1My4o8Bmyb" pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    //App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BPush handleNotification:userInfo];
    }
    
    return YES;
}

//开始启动
-(void) startRootView
{
    if([[AppDefaultUtil sharedInstance] isFirstLancher])
    {
        // 第一次启动，直接启动引导界面
        [[AppDefaultUtil sharedInstance] setRemeberUser:YES];
        
        [AppDelegateInstance setOpenType:@"1"];
        
        //启动引导页
        GuideViewController *guideView = [[GuideViewController alloc]  init];
        self.window.rootViewController = guideView;
        [self.window makeKeyAndVisible];
    } else {
        //主界面
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [UIApplication sharedApplication].statusBarHidden = NO;
        MainViewController *main = [[MainViewController alloc] rootViewController];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:main];
        [navigationController setNavigationBarHidden:YES];
        self.window.rootViewController = navigationController;
        [self.window makeKeyAndVisible];
        
        //Jaqen-start:应用启动开启手势验证
        
        if ([[AppDefaultUtil sharedInstance] getGesturesPasswordStatus]) {
            [CLLockVC showVerifyLockVCInVC:self.window.rootViewController forgetPwdBlock:^{
                NSLog(@"忘记密码");
            } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                NSLog(@"密码正确");
                [lockVC dismiss:0.5f];
            }];
        }
        
        //Jaqen-end
        
    }
}

- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#if SUPPORT_IOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif
//注册推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"deviceToken"];
    [userDefaults setObject:deviceToken forKey:@"deviceToken"];
    //注册 Device Token
    [BPush registerDeviceToken:[userDefaults objectForKey:@"deviceToken"]];
    //绑定
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        if (result) {
            [BPush setTag:@"P2P" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    
                }
            }];
        }
    }];
}

//注册百度云推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}


//收到百度云推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    [application setApplicationIconBadgeNumber:0];
    
    if ([userInfo objectForKey:@"id"] != nil &&![[userInfo objectForKey:@"id"] isEqual:[NSNull null]]&&[userInfo objectForKey:@"url"] != nil &&![[userInfo objectForKey:@"url"] isEqual:[NSNull null]]) {
        
        _modelRemoteNotification=[ModelRemoteNotification initWithUserInfo:userInfo];
        //处理URL链接
        if (_modelRemoteNotification.remoteNotificationType==RemoteNotificationTypeNewBidOne||_modelRemoteNotification.remoteNotificationType==RemoteNotificationTypeNewBidTwo||_modelRemoteNotification.remoteNotificationType==RemoteNotificationTypeActivite) {
            if (application.applicationState == UIApplicationStateActive)
            {
                [_blockViewRemoteNotification removeFromSuperview];
                _blockViewRemoteNotification=[ToolBlackView createRemoteNotificationWithModel:_modelRemoteNotification withButtonText:@"查 看" withTarget:self withAction:@selector(onClickShowRemoteNotification) withCloseAction:@selector(onClickCloseRemoteNotification)];
            }else{
                AdWebViewController *adWebView = [[AdWebViewController alloc] init];
                adWebView.urlStr = _modelRemoteNotification.url;
                adWebView.title=_modelRemoteNotification.title;
                adWebView.hidesBottomBarWhenPushed = YES;
                UINavigationController *billNav = [[UINavigationController alloc] initWithRootViewController:adWebView];
                [self.window.rootViewController presentViewController:billNav animated:YES completion:nil];
            }
        }else if(_modelRemoteNotification.remoteNotificationType==RemoteNotificationTypeURL){
            if (application.applicationState == UIApplicationStateActive)
            {
                
            }else{
                AdWebViewController *adWebView = [[AdWebViewController alloc] init];
                adWebView.urlStr = _modelRemoteNotification.url;
                adWebView.title=_modelRemoteNotification.title;
                adWebView.hidesBottomBarWhenPushed = YES;
                UINavigationController *billNav = [[UINavigationController alloc] initWithRootViewController:adWebView];
                [self.window.rootViewController presentViewController:billNav animated:YES completion:nil];
            }
        }
    }
}

//点击查看推送信息
-(void)onClickShowRemoteNotification{
    [_blockViewRemoteNotification removeFromSuperview];
    if (_remoteNotificationType==RemoteNotificationTypeURL&&_modelRemoteNotification.url!=nil&&[_modelRemoteNotification.url length]>0) {
        AdWebViewController *adWebView = [[AdWebViewController alloc] init];
        adWebView.urlStr = _modelRemoteNotification.url;
        adWebView.title=_modelRemoteNotification.title;
        adWebView.hidesBottomBarWhenPushed = YES;
        UINavigationController *billNav = [[UINavigationController alloc] initWithRootViewController:adWebView];
        [self.window.rootViewController presentViewController:billNav animated:YES completion:nil];
    }
}

//关闭推送信息
-(void)onClickCloseRemoteNotification{
    [_blockViewRemoteNotification removeFromSuperview];
}

//返回绑定等调用的结果
- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethodBind isEqualToString:method]) {
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        
        if (returnCode == 0) {
            //在内存中备份，以便短时间内进入可以看到这些值，而不需要重新bind
            self.appId = appid;
            self.channelId = channelid;
            self.userId = userid;
        }
    } else if ([BPushRequestMethodUnbind isEqualToString:method]) {
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == 0) {
            
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //获取 appid
    self.appId = [BPush getAppId];
    self.userId = [BPush getUserId];
    self.channelId = [BPush getChannelId];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 从前台进入后台
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // 从后台进入前台
    if ([[AppDefaultUtil sharedInstance] getDefaultAccount] !=nil && ![[[AppDefaultUtil sharedInstance] getDefaultAccount] isEqualToString:@""] && [[AppDefaultUtil sharedInstance] getDefaultUserPassword] !=nil && ![[[AppDefaultUtil sharedInstance] getDefaultUserPassword] isEqualToString:@""]) {
        [self refreshLogin];
    }
    [_blockViewRemoteNotification removeFromSuperview];
    [application setApplicationIconBadgeNumber:0];
    [self updateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

#pragma mark Request 网络请求数据
/**
 *  刷新用户登录数据
 */
-(void)refreshLogin{
    _requestType=RequestTypeLogin;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *name = [[AppDefaultUtil sharedInstance] getDefaultAccount];
    NSString *password = [[AppDefaultUtil sharedInstance] getDefaultUserPassword];
    NSString *deviceType = [[AppDefaultUtil sharedInstance] getdeviceType];
    [parameters setObject:@"1" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:name forKey:@"name"];
    [parameters setObject:password forKey:@"pwd"];
    if(AppDelegateInstance.userId !=nil && AppDelegateInstance.channelId != nil)
    {
        [parameters setObject:AppDelegateInstance.userId forKey:@"userId"];
        [parameters setObject:AppDelegateInstance.channelId forKey:@"channelId"];
    }else{
        [parameters setObject:@"" forKey:@"userId"];
        [parameters setObject:@"" forKey:@"channelId"];
    }
    [parameters setObject:deviceType forKey:@"deviceType"];
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

-(void)updateApp{
    
    NSDate *dateLast=[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsTimeIntervalUpdate];
    int hours;
    if(dateLast==nil){
        hours=9;
    }else{
        NSTimeInterval time=[[NSDate date] timeIntervalSinceDate:dateLast];
        hours=((int)time)/3600;
    }
    
    if (hours>=TimeIntervalUpdate) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:UserDefaultsTimeIntervalUpdate];
        
        if(_blockView==nil){
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];//CFBundleVersion
            
            if (![ToolConstant stringIsNil:_lastVersion]) {
                NSComparisonResult result=[currentVersion compare:_lastVersion];
                
                if(result == NSOrderedAscending)
                {
                    _blockView=[ToolBlackView createRemindWithContent:[NSString stringWithFormat:@"%@", _releaseNotes] withTarget:self withAction:@selector(onClickUpdata) withCloseAction:@selector(onClickUpdataClose)];
                }
            }
        }else{
            _blockView.hidden=NO;
        }
    }
}

//版本更新
-(void)onClickUpdata{
    NSURL *url = [NSURL URLWithString:AppStoreDownLoadUrl];
    [[UIApplication sharedApplication]openURL:url];
}
-(void)onClickUpdataClose{
    _blockView.hidden=YES;
}
//字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        return nil;
    }
    return dic;
}
#pragma mark HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    if (dics.count == 0) {
        return;
    }
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        if(_requestType==RequestTypeLogin)//登录
        {
            UserInfo *usermodel = [[UserInfo alloc] init];
            
            if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"creditRating"]] hasPrefix:@"http"])
            {
                usermodel.userCreditRating = [obj objectForKey:@"creditRating"];
                
            }else{
                usermodel.userCreditRating =  [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"creditRating"]];
            }
            usermodel.userName = [obj objectForKey:@"username"];
            if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"headImg"]] hasPrefix:@"http"]) {
                
                usermodel.userImg = [NSString stringWithFormat:@"%@", [obj objectForKey:@"headImg"]];
            }else{
                usermodel.userImg = [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"headImg"]];
            }
            usermodel.userLimit = [obj objectForKey:@"creditLimit"];
            usermodel.isVipStatus = [obj objectForKey:@"vipStatus"];
            usermodel.userId = [obj objectForKey:@"id"];
            usermodel.isLogin = @"1";
            usermodel.accountAmount = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"accountAmount"] doubleValue]];
            usermodel.availableBalance = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"availableBalance"] doubleValue]];
            usermodel.freeze = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"freeze"] doubleValue]];
            usermodel.totalIncome = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"totalIncome"] doubleValue]];
            usermodel.receivingAmount = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"receivingAmount"] doubleValue]];
            
            AppDelegateInstance.userInfo = usermodel;
            
            // 通知全局广播 LeftMenuController 修改UI操作
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:[obj objectForKey:@"username"]];
        }
    }else {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    
}

// 无可用的网络
-(void) networkError
{
    
}
@end