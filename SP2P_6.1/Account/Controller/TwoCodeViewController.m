//
//  TwoCodeViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  二维码

#import "TwoCodeViewController.h"

#import "ColorTools.h"
#import "ExtensionMemberViewController.h"
#import "IncomeViewController.h"

@interface TwoCodeViewController ()<UITableViewDataSource, UITableViewDelegate, HTTPClientDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *codeScroll;
@property (nonatomic, strong) UITableView *twoTableView;
@property (nonatomic, copy) NSString *iId;  // 存储当前ID值
@property (nonatomic, copy) NSString *boolId; // 判断ID是否有值
@property (nonatomic, copy) NSString *imgUrl; // 分享二维码图片链接
@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation TwoCodeViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化视图
    [self initView];
}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    
    [self initContentView];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"CPS推广二维码";
    
    // 导航条 右边 设置按钮
    BarButtonItem *barShare=[BarButtonItem barItemWithTitle:@"分享" widthImage:[UIImage imageNamed:@"bar_right"] selectedImage:[UIImage imageNamed:@"bar_right_press"] withIsImageLeft:NO target:self action:@selector(clickShare)];
    [self.navigationItem setRightBarButtonItem:barShare];
}

/**
 * 初始化内容详情
 */
- (void)initContentView
{
    //DLOG(@"self.view. width - > %f", self.view.frame.size.width);
    _codeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WidthScreen, HeightScreen-HeightNavigationAndStateBar)];
    _codeScroll.contentInset=UIEdgeInsetsMake(0, 0, HeightNavigationAndStateBar, 0);
    _codeScroll.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_codeScroll];
    
    // 二维码图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.frame = CGRectMake((self.view.frame.size.width - 160) * 0.5, SpaceBig, 160, 160);
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_codeScroll addSubview:_imageView];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 188)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [_codeScroll addSubview:whiteView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 205, self.view.frame.size.width, 35)];
    titleLabel.text = @"CPS推广简介";
    titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0];
    [_codeScroll addSubview:titleLabel];
    
    // 画直线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 240, self.view.frame.size.width, 1)];
    lineView.backgroundColor = ColorBGGray;
    [_codeScroll addSubview:lineView];
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 251, self.view.frame.size.width - 20, 100)];
    desLabel.text = @"CPS: 会员通过把自己的推广二维码分享到自己的空间，网站，朋友圈等方式进行代理推广，由此链接产生的会员交易额计入会员的直销代理成绩。按照代理成绩进行结算。";
    desLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
    desLabel.numberOfLines = 0;
    
    [_codeScroll addSubview:desLabel];
    
    _twoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 396, self.view.frame.size.width, 88) style:UITableViewStyleGrouped];
    _twoTableView.delegate = self;
    _twoTableView.dataSource = self;
    _twoTableView.scrollEnabled = NO;
    _twoTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_twoTableView setBackgroundColor:ColorBGGray];
    [_codeScroll addSubview:_twoTableView];
    _codeScroll.contentSize = CGSizeMake(self.view.frame.size.width, 504);
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // 设置cell的边框
    if (indexPath.section == 0) {
        cell.textLabel.text = @"我成功推广的会员";
    }else{
        cell.textLabel.text = @"我的推广收入";
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DLOG(@"name _titleArrays[indexPath.section");
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            ExtensionMemberViewController *extensionView = [[ExtensionMemberViewController alloc] init];
            [self.navigationController pushViewController:extensionView animated:YES];
        }
            break;
        case 1:
        {
            IncomeViewController *incomeView = [[IncomeViewController alloc] init];
            [self.navigationController pushViewController:incomeView animated:YES];
        }
    }
}


#pragma mark 1、返回   2、分享
-(void)clickShare{
    //DLOG(@"分享");
    if (AppDelegateInstance.userInfo == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        
    }else {
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"来融金服火爆上市，小伙伴们快来装逼一起飞。 %@",Baseurl]
                                           defaultContent:@"来融金服"
                                                    image:[ShareSDK imageWithUrl:_imgUrl]
                                                    title:@"来融金服"
                                                      url:Baseurl
                                              description:@"来融金服火爆上市，小伙伴们快来装逼一起飞。"
                                                mediaType:SSPublishContentMediaTypeNews];
        
        [ShareSDK showShareActionSheet:nil
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions: nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSResponseStateSuccess)
                                    {
                                        //DLOG(@"分享成功");
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        //DLOG(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]]];
                                    }
                                }];
    }
}

/**
 加载数据
 */
- (void)requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"亲，请登录！"];
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"28" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
}

#pragma mark HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
   
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        //DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        if ([obj objectForKey:@"promoteImg"]!= nil && ![[obj objectForKey:@"promoteImg"]isEqual:[NSNull null]])
        {
            if ([[obj objectForKey:@"promoteImg"] hasPrefix:@"http"]) {
                
                _imgUrl = [NSString stringWithFormat:@"%@", [obj objectForKey:@"promoteImg"]];
            }else{
                
                _imgUrl = [NSString stringWithFormat:@"%@%@",Baseurl, [obj objectForKey:@"promoteImg"]];
            }}
      
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_imgUrl]];
        //DLOG(@"_imageView.image -> %@", [NSString stringWithFormat:@"%@%@",Baseurl, [obj objectForKey:@"promoteImg"]]);
        
    }else {
        //DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        
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
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
