//
//  MoreCustomViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14-6-14.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  客服热线

#import "MoreCustomViewController.h"

#import "ColorTools.h"


@interface MoreCustomViewController ()<HTTPClientDelegate>

@property (nonatomic, copy) UILabel *customerLabel;
@property (nonatomic, strong) UIButton *logoView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation MoreCustomViewController

// 加载页面之前 加载数据
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"128" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];

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
    self.title = @"客服热线";
    
    [self initContent];
}

- (void)initContent
{
    _logoView = [UIButton buttonWithType:UIButtonTypeCustom];
    _logoView.frame = CGRectMake((self.view.frame.size.width - 80) * 0.5, SpaceBig, 80, 80);
    [_logoView.layer setMasksToBounds:YES];
    [_logoView.layer setCornerRadius:30.0]; //设置矩形四个圆角半径
//    [_logoView addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [_logoView setBackgroundImage:[UIImage imageNamed:@"header"] forState:UIControlStateNormal];
    [self.view addSubview:_logoView];// 登陆头像
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_logoView.frame)+SpaceMediumBig, self.view.frame.size.width, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    _customerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    _customerLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:_customerLabel];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{

}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        _customerLabel.text = [NSString stringWithFormat:@"客服热线: %@", [obj objectForKey:@"hotline"]];
        
    }else {
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
