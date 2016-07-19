//
//  MoreViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14-6-12.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "MoreViewController.h"
#import "ColorTools.h"
#import "BarButtonItem.h"
#import "TabViewController.h"
#import "MainViewController.h"
#import "SettingViewController.h"
#import "MoreAboutusViewController.h"
#import "MoreHelpViewController.h"
#import "MoreCustomViewController.h"

#define WHLogo  (WidthScreen*0.37)  //logo WH

@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate, HTTPClientDelegate,UIAlertViewDelegate>
{
    NSArray *_titleArrays;
}
@property (nonatomic , strong)  UITableView *moreTableView;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@end

@implementation MoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
}

/**
 初始化数据
 */
- (void)initData
{
    _titleArrays = @[@"关于我们",@"帮助中心",@"客服热线"];//@"检查更新",
}

/**
 初始化数据
 */
- (void)initView
{
    [self initContentView];
}

/**
 * 初始化内容详情
 */
- (void)initContentView
{
    self.title = @"设置";
    UIView *viewHeader=[[UIView alloc] initWithFrame:CGRectMake(0, SpaceSmall/2, WidthScreen, WidthScreen/2)];
    viewHeader.backgroundColor=ColorWhite;
    [self.view addSubview:viewHeader];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = [UIImage imageNamed:@"logo"];
    imageView.frame = CGRectMake((WidthScreen-WHLogo)/2, 0, WHLogo, WHLogo);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [viewHeader addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), WidthScreen, 30)];
    label.text = [NSString stringWithFormat:@"当前版本：V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    label.font = FontTextSmall;
    label.textAlignment = NSTextAlignmentCenter;
    [viewHeader addSubview:label];
    
    _moreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(viewHeader.frame)+SpaceMediumSmall, self.view.frame.size.width, 160) style:UITableViewStyleGrouped];
    _moreTableView.delegate = self;
    _moreTableView.dataSource = self;
    _moreTableView.scrollEnabled = NO;
    [_moreTableView setBackgroundColor:[UIColor clearColor]];
    _moreTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_moreTableView];
    
    UIButton *btnNotLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNotLogin.frame = CGRectMake(SpaceBig, CGRectGetMaxY(_moreTableView.frame)+SpaceMediumSmall, WidthScreen-SpaceBig*2, 40);
    [btnNotLogin setBackgroundImage:[ImageTools imageWithColor:ColorRedMain] forState:UIControlStateNormal];
    [btnNotLogin setBackgroundImage:[ImageTools imageWithColor:ColorRedMain withAlpha:AlphaColorRedMainHeightLight] forState:UIControlStateHighlighted];
    [btnNotLogin setTitle:@"退出登录" forState:UIControlStateNormal];
    [btnNotLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btnNotLogin.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    [btnNotLogin.layer setMasksToBounds:YES];
    [btnNotLogin.layer setCornerRadius:3.0];
    [btnNotLogin addTarget:self action:@selector(clickNotLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNotLogin];
}
/**
 *  退出登录
 */
-(void)clickNotLogin{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出账户" message:@"确定要退出此账户吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag = 10002;
    [alertView show];
}
#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return _titleArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SpaceSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingcell = @"settingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingcell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:settingcell];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, cell.frame.size.height)];
        imageView.image=[ImageTools imageWithColor:ColorBtnWhiteHighlight];
        cell.selectedBackgroundView=imageView;
    }
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    // 设置 cell 右边的箭头
//    if (indexPath.section != 0)
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = _titleArrays[indexPath.section];
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DLOG(@"name - %@", _titleArrays[indexPath.section]);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0://关于
        {
            MoreAboutusViewController *aboutUs = [[MoreAboutusViewController alloc] init];
            [self.navigationController pushViewController:aboutUs animated:YES];
        }
            break;
        case 1://帮助
        {
            MoreHelpViewController *help = [[MoreHelpViewController alloc] init];
            [self.navigationController pushViewController:help animated:YES];
        }
            break;
        case 2://服务
        {
            MoreCustomViewController *custom = [[MoreCustomViewController alloc] init];
            [self.navigationController pushViewController:custom animated:YES];
        }
            break;
    }
}

#pragma mark 版本更新
-(void) upload
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"127" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"2" forKey:@"deviceType"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    [SVProgressHUD load];
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        // 获取服务器版本
        NSString *version = [dics objectForKey:@"version"];
        
        if (3 < [[dics objectForKey:@"code"] integerValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新" message:[NSString stringWithFormat:@"有最新的版本%@，是否前往更新？", version] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
            alert.tag = 10000;
            [alert show];
            
        }else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 10001;
            [alert show];
            
        }
    }else {
        //DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            //DLOG(@"更新中...");
            
            // 正式站点
            NSURL *url = [NSURL URLWithString:@"https://appstore.qiwangyun.com/sp2p/ios/lairongjinfu/download.html"];
            // 测试站点
            [[UIApplication sharedApplication]openURL:url];
        }
    }else if(alertView.tag==10002){
        switch (buttonIndex) {
            case 0:
            {
                // 记录 退出状态
                if (AppDelegateInstance.userInfo != nil) {
                }
                
                [[AppDefaultUtil sharedInstance] setDefaultUserName:@""];// 清除用户昵称
                [[AppDefaultUtil sharedInstance] setDefaultUserPassword:@""];// 清除用户密码
                [[AppDefaultUtil sharedInstance] setDefaultAccount:@""];// 清除用户账号
                [[AppDefaultUtil sharedInstance] setDefaultUserCellPhone:@""];//清除手机号
                [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:@""];// 清除用户头像
                
                //Jaqen-start:关闭手势密码
                
                [[AppDefaultUtil sharedInstance] setGesturesPasswordStatusWithFlag:NO];
                
                //Jaqen-end
                
                AppDelegateInstance.userInfo = nil;
                AppDelegateInstance.userInfo.isLogin = 0;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil];
                [self back];
            }
                break;
            case 1:
                break;
        }

    }
}
@end
