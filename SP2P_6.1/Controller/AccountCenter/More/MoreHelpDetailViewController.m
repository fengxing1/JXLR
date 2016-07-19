//
//  MoreHelpDetailViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14-6-14.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  帮助中心

#import "MoreHelpDetailViewController.h"

#import "ColorTools.h"

@interface MoreHelpDetailViewController ()<HTTPClientDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation MoreHelpDetailViewController

/**
 初始化数据
 */
- (void)initWithName:(NSString *)name ColumnId:(NSString *)ColumnId
{
    self.title = name;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"76" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@", ColumnId] forKey:@"id"];
    
    
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
    
    [self initView];
}

/**
 初始化数据
 */
- (void)initView
{
    self.title = @"帮助中心";
    
    [self initContent];
}

- (void)initContent
{
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = ColorBGGray;
    _webView.scrollView.contentInset=UIEdgeInsetsMake(0, 0, HeightNavigationAndStateBar, 0);
    [self.view addSubview:_webView];
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
        
        //DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        //DLOG(@"返回成功  content -> %@",[obj objectForKey:@"content"]);
        [_webView loadHTMLString:[obj objectForKey:@"content"] baseURL:nil];
        
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
